[org 0x0100]
jmp start

;---------------------------------------;
; Countdown timer variables
chrs:       dw 0                        ; countdown hours
cmin:       dw 3                        ; countdown minutes (initial value 3)
csec:       dw 0                        ; countdown seconds
cms:        dw 0                        ; countdown milliseconds
cdt:        db 0                        ; countdown timer on/off flag
oldkb:      dd 0                        ; old keyboard interrupt vector

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
    cmp al, 174         ; 0xAE - 0x80 = 0x2E
    jne oldKbHandler
    
    ; Toggle countdown timer
    cmp byte [cs:cdt], 1
    je cdt_stop
    
    ; Start countdown
    mov byte [cs:cdt], 1
    jmp EOI1
    
cdt_stop:
    ; Stop countdown
    mov byte [cs:cdt], 0
    jmp EOI1
    
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
    push 494            ; video mem offset for display
    call printTime
    
    ; Only update if countdown is active
    cmp byte [cs:cdt], 1
    jne timerEOI
    
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
    
    ; Adjust hours
    add word [cs:chrs], 24
    
    ; Check if countdown reached zero
    mov ax, [cs:chrs]
    add ax, [cs:cmin]
    add ax, [cs:csec]
    add ax, [cs:cms]
    jnz timerEOI
    
    ; Countdown finished - stop timer
    mov byte [cs:cdt], 0
    
timerEOI:
    mov al, 0x20
    out 0x20, al        ; send EOI to PIC
    pop es
    popa
    iret

;---------------------------------------;

start:
    ; Save old keyboard interrupt vector
    xor ax, ax
    mov es, ax
    mov ax, [es:9*4]
    mov [oldkb], ax
    mov ax, [es:9*4+2]
    mov [oldkb+2], ax
    
    ; Initialize countdown timer values
    mov word [cs:chrs], 0
    mov word [cs:cmin], 3    ; 3 minutes countdown
    mov word [cs:csec], 0
    mov word [cs:cms], 0
    mov byte [cs:cdt], 0     ; initially stopped
    
    call clrscr
    
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