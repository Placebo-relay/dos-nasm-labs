; PRESS C FOR COUNT
[org 0x0100]
jmp start

;---------------------------------------;
; Countdown timer variables
chrs:       dw 0                        ; countdown hours
cmin:       dw 0                        ; countdown minutes
csec:       dw 0                        ; countdown seconds (will be set by user)
cms:        dw 0                        ; countdown milliseconds
cdt:        db 0                        ; countdown timer on/off flag
oldkb:      dd 0                        ; old keyboard interrupt vector
input_buf:  times 6 db 0                ; buffer for user input
prompt:     db 'Press C to start after: please enter seconds (1-3599): $'

;---------------------------------------;

clrscr:
    pusha
    push es
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ax, 0x0720      ; space with attribute 07
    mov cx, 2000
    cld
    rep stosw
    pop es
    popa
    ret

;---------------------------------------;

printLayout:
    pusha
    push es
    mov ax, 0xB800
    mov es, ax
    
    ; Print "COUNTDOWN TIMER" title
    mov di, 260
    mov byte[es:di], 'C'
    mov byte[es:di+2], 'O'
    mov byte[es:di+4], 'U'
    mov byte[es:di+6], 'N'
    mov byte[es:di+8], 'T'
    mov byte[es:di+10], 'D'
    mov byte[es:di+12], 'O'
    mov byte[es:di+14], 'W'
    mov byte[es:di+16], 'N'
    mov byte[es:di+18], ' '
    mov byte[es:di+20], 'T'
    mov byte[es:di+22], 'I'
    mov byte[es:di+24], 'M'
    mov byte[es:di+26], 'E'
    mov byte[es:di+28], 'R'
	mov byte[es:di+30], ' '
	mov byte[es:di+32], 'k'
	mov byte[es:di+34], 'e'
	mov byte[es:di+36], 'y'
	mov byte[es:di+38], '-'
	mov byte[es:di+40], 'C'
    
    ; Print time labels
    mov di, 420
    mov byte[es:di], 'H'
    mov byte[es:di+2], 'R'
    mov byte[es:di+4], 'S'
    mov byte[es:di+8], ':'
    mov byte[es:di+12], 'M'
    mov byte[es:di+14], 'I'
    mov byte[es:di+16], 'N'
    mov byte[es:di+20], ':'
    mov byte[es:di+24], 'S'
    mov byte[es:di+26], 'E'
    mov byte[es:di+28], 'C'
    mov byte[es:di+32], ':'
    mov byte[es:di+36], 'M'
    mov byte[es:di+38], 'L'
    mov byte[es:di+40], 'S'
    
    pop es
    popa
    ret

;---------------------------------------;

printstr:
    push bp
    mov bp, sp
    pusha
    push es
    
    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]      ; video mem offset
    mov ax, [bp+6]      ; number to print
    
    mov bx, 10
    mov cx, 0
    
nextdigit:
    mov dx, 0
    div bx
    add dl, 0x30        ; convert to ASCII
    push dx
    inc cx
    cmp ax, 0
    jnz nextdigit
    
    cmp cx, 1
    jnz nextpos
    mov byte [es:di], '0'
    add di, 2
    
nextpos:
    pop dx
    mov dh, 0x07        ; attribute
    mov [es:di], dx
    add di, 2
    loop nextpos
    
    pop es
    popa
    pop bp
    ret 4

;---------------------------------------;

printTime:
    push bp
    mov bp, sp
    pusha
    push es
    
    mov ax, 0xB800
    mov es, ax
    mov di, [bp+4]      ; video mem offset
    
    ; print hours
    push word [bp+6]    ; hours
    add di, 2
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print minutes
    push word [bp+8]    ; minutes
    add di, 4
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print seconds
    push word [bp+10]   ; seconds
    add di, 4
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print milliseconds
    push word [bp+12]   ; milliseconds
    add di, 4
    push di
    call printstr
    
    pop es
    popa
    pop bp
    ret 10

;---------------------------------------;


kbisr:
    push ax
    in al, 0x60         ; read keyboard scan code

    ; Check for 'C' key (scan code 0x2E when released)
    cmp al, 174        ; 0xAE - 0x80 = 0x2E 0x9C 174
    jne oldKbHandler
    
    ; Don't allow starting if timer is already at 0
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz EOI1             ; if all zero, don't allow starting
    
    ; Toggle countdown timer
    cmp byte [cs:cdt], 1
    je cdt_stop
    
    ; Start countdown
    mov byte [cs:cdt], 1
    jmp EOI1
	   

cdt_stop:
    ; Stop countdown
    mov byte [cs:cdt], 0
    
EOI1:
    mov al, 0x20
    out 0x20, al        ; send EOI to PIC
    pop ax
    iret
    
oldKbHandler:
    pop ax
    jmp far [cs:oldkb]  ; jump to original ISR

;---------------------------------------;

countdownTimer:
    pusha
    push es
    
    call printLayout
    
    ; Print current countdown time
    push word [cs:cms]
    push word [cs:csec]
    push word [cs:cmin]
    push word [cs:chrs]
    push 738           ; video mem offset for display !!!738=perfect
    call printTime
    
    ; Only update if countdown is active
    cmp byte [cs:cdt], 1
    jne timerEOI
    
    ; Check if we've already reached zero
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz timerStopped     ; if all zero, stop the timer
    
    ; Decrement milliseconds
    mov ax, [cs:cms]
    sub ax, 55
    cmp ax, 0
    jge update_ms
    
    ; Adjust if milliseconds went negative
    add ax, 1000
    dec word [cs:csec]
    
update_ms:
    mov [cs:cms], ax
    
    ; Check if seconds need adjustment
    cmp word [cs:csec], 0
    jge check_minutes
    
    ; Adjust seconds
    add word [cs:csec], 60
    dec word [cs:cmin]
    
check_minutes:
    cmp word [cs:cmin], 0
    jge check_hours
    
    ; Adjust minutes
    add word [cs:cmin], 60
    dec word [cs:chrs]
    
check_hours:
    cmp word [cs:chrs], 0
    jge timerEOI
    
    ; This should never happen as we check for zero above
    mov word [cs:chrs], 0
    
    ; Check if countdown reached zero
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz timerEOI
    
timerStopped:
    ; Countdown finished - stop timer
    mov byte [cs:cdt], 0
    
    ; Ensure all values are zero
    mov word [cs:chrs], 0
    mov word [cs:cmin], 0
    mov word [cs:csec], 0
    mov word [cs:cms], 0
    
timerEOI:
    mov al, 0x20
    out 0x20, al        ; send EOI to PIC
    pop es
    popa
	
    iret

;---------------------------------------;

get_input:
    ; Display prompt
    mov ah, 09h
    mov dx, prompt
    int 21h
    
    ; Read user input
    mov ah, 0ah
    mov dx, input_buf
    mov byte [input_buf], 5      ; max 5 characters to read
    int 21h
    
    ; Convert ASCII to number
    mov si, input_buf + 2        ; point to first digit
    xor ax, ax                   ; clear ax for result
    mov cx, 10                   ; multiplier
    
convert_loop:
    mov bl, [si]
    cmp bl, 0dh                  ; check for carriage return
    je convert_done
    sub bl, '0'                  ; convert ASCII to digit
    mul cx                       ; ax = ax * 10
    add ax, bx                   ; add new digit
    inc si
    jmp convert_loop
    
convert_done:
    ; Validate input (1-3599 seconds)
    cmp ax, 1
    jl invalid_input
    cmp ax, 3599
    jg invalid_input
    
    ; Store seconds
    mov [cs:csec], ax
    
    ; Convert seconds to hours:minutes:seconds
    xor dx, dx
    mov bx, 60
    div bx                      ; ax = minutes, dx = seconds
    mov [cs:csec], dx
    
    xor dx, dx
    div bx                      ; ax = hours, dx = minutes
    mov [cs:cmin], dx
    mov [cs:chrs], ax
    
    ret
    
invalid_input:
    ; Clear input buffer
    mov byte [input_buf+2], 0
    
    ; Print error message
    mov ah, 09h
    mov dx, invalid_msg
    int 21h
    
    ; Wait for key press
    mov ah, 0
    int 16h
    
    ; Try again
    call clrscr
    jmp get_input

invalid_msg db 0dh, 0ah, 'Invalid input! Must be 1-3599 seconds.', 0dh, 0ah, '$'

;---------------------------------------;

start:
    ; Initialize screen
    call clrscr
    
    ; Get user input for countdown time
    call get_input
    
    ; Clear screen again after input
    call clrscr
    
    ; Save old keyboard interrupt vector
    xor ax, ax
    mov es, ax
    mov ax, [es:9*4]
    mov [oldkb], ax
    mov ax, [es:9*4+2]
    mov [oldkb+2], ax
    
    ; Initialize countdown timer values (already set by get_input)
    mov word [cs:cms], 0
    mov byte [cs:cdt], 0     ; initially stopped
    
    ; Install new interrupt handlers
    cli
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    mov word [es:8*4], countdownTimer
    mov [es:8*4+2], cs
    sti
    
    ; Terminate and stay resident
    mov dx, start + 15
    mov cl, 4
    shr dx, cl
    mov ax, 0x3100
    int 0x21