org 0x100

jmp start

;---------------------------------------;
; Data Section
;---------------------------------------;

hours:      dw 0
minutes:    dw 0
seconds:    dw 0

splits:     times 10 dw 0,0,0  ; Array for 10 splits (hr,min,sec each)
split_count db 0
split_pos   db 6               ; Starting row for splits display

old_kb_vec: dd 0               ; Keyboard interrupt vector
old_timer:  dd 0               ; Timer interrupt vector

;---------------------------------------;
; Clear Screen
;---------------------------------------;

clrscr:
    pusha
    push es
    
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ax, 0x0720      ; Space with gray on black
    mov cx, 2000        ; 80x25 characters
    
    cld
    rep stosw
    
    pop es
    popa
    ret

;---------------------------------------;
; Print Time Labels
;---------------------------------------;

print_labels:
    pusha
    push es
    
    mov ax, 0xB800
    mov es, ax
    mov di, 160         ; Start at line 1
    
    ; Print "CURRENT TIME: HRS:MIN:SEC"
    mov si, time_label
    mov cx, time_label_len
    
print_label_loop:
    mov al, [si]
    mov [es:di], al
    add di, 2
    inc si
    loop print_label_loop
    
    pop es
    popa
    ret

time_label db 'CURRENT TIME: HRS:MIN:SEC'
time_label_len equ $ - time_label

;---------------------------------------;
; Print 2-digit Number
;---------------------------------------;

print_num:
    push bp
    mov bp, sp
    pusha
    push es
    
    mov ax, 0xB800
    mov es, ax
    mov di, [bp+4]      ; Screen position
    mov ax, [bp+6]      ; Number to print
    
    mov bl, 10
    div bl              ; AL = quotient, AH = remainder
    
    ; Print tens digit
    add al, '0'
    mov [es:di], al
    add di, 2
    
    ; Print units digit
    add ah, '0'
    mov [es:di], ah
    
    pop es
    popa
    pop bp
    ret 4

;---------------------------------------;
; Print Current Time (HH:MM:SS)
;---------------------------------------;

print_time:
    pusha
    
    ; Calculate screen position (line 3)
    mov ax, 80 * 2 * 2  ; 2 lines down (0=first line), 2 bytes per char
    push ax
    
    ; Print hours
    push word [hours]
    push ax
    call print_num
    
    ; Print colon
    mov bx, 0xB800
    mov es, bx
    add ax, 6
    mov di, ax
    mov byte [es:di], ':'
    
    ; Print minutes
    push word [minutes]
    add ax, 2
    push ax
    call print_num
    
    ; Print colon
    add ax, 6
    mov di, ax
    mov byte [es:di], ':'
    
    ; Print seconds
    push word [seconds]
    add ax, 2
    push ax
    call print_num
    
    popa
    ret

;---------------------------------------;
; Print All Splits
;---------------------------------------;

print_splits:
    pusha
    
    mov cl, [split_count]
    test cl, cl
    jz no_splits
    
    mov ch, 0
    mov si, splits
    
split_loop:
    ; Calculate screen position
    mov al, [split_pos]
    sub al, cl
    mov bl, 80 * 2      ; 80 columns * 2 bytes
    mul bl              ; AX = row offset
    add ax, 160         ; Start below main timer
    
    ; Print split number
    push ax
    mov bx, 0xB800
    mov es, bx
    mov di, ax
    mov al, '0'
    add al, [split_count]
    sub al, cl
    mov [es:di], al
    add di, 4
    mov byte [es:di], ':'
    
    ; Print split time
    push word [si+4]    ; sec
    push word [si+2]    ; min
    push word [si]      ; hr
    add ax, 6
    push ax
    call print_time
    
    add si, 6           ; Next split entry (6 bytes per split)
    loop split_loop
    
no_splits:
    popa
    ret

;---------------------------------------;
; Keyboard Interrupt Handler
;---------------------------------------;

kbisr:
    push ax
    in al, 0x60         ; Read keyboard scan code
    
    ; SPACE = record split
    cmp al, 0x39        
    jne check_esc
    
    ; Add split if < 10
    mov al, [split_count]
    cmp al, 10
    jae kb_done
    
    ; Store current time in splits array
    mov bl, 6           ; 6 bytes per split (hr,min,sec)
    mul bl
    mov si, splits
    add si, ax
    
    mov ax, [hours]
    mov [si], ax
    mov ax, [minutes]
    mov [si+2], ax
    mov ax, [seconds]
    mov [si+4], ax
    
    inc byte [split_count]
    jmp kb_done
    
check_esc:
    ; ESC = exit program
    cmp al, 0x01        
    jne old_kb_handler
    
    ; Restore original interrupts
    cli
    mov ax, 0
    mov es, ax
    mov ax, [old_kb_vec]
    mov [es:9*4], ax
    mov ax, [old_kb_vec+2]
    mov [es:9*4+2], ax
    
    mov ax, [old_timer]
    mov [es:8*4], ax
    mov ax, [old_timer+2]
    mov [es:8*4+2], ax
    sti
    
    ; Terminate
    mov ax, 0x4C00
    int 0x21
    
old_kb_handler:
    pop ax
    jmp far [cs:old_kb_vec]

kb_done:
    mov al, 0x20
    out 0x20, al
    pop ax
    iret

;---------------------------------------;
; Timer Interrupt Handler (18.2 Hz)
;---------------------------------------;

timer_isr:
    pusha
    push ds
    push es
    
    ; Set DS to our code segment
    mov ax, cs
    mov ds, ax
    
    ; Update time (18.2 interrupts/second)
    inc word [seconds]
    cmp word [seconds], 60
    jb update_display
    
    ; Minute rollover
    mov word [seconds], 0
    inc word [minutes]
    cmp word [minutes], 60
    jb update_display
    
    ; Hour rollover
    mov word [minutes], 0
    inc word [hours]

update_display:
    call clrscr
    call print_labels
    call print_time
    call print_splits
    
    ; End of interrupt
    mov al, 0x20
    out 0x20, al
    
    pop es
    pop ds
    popa
    iret

;---------------------------------------;
; Main Program
;---------------------------------------;

start:
    ; Save original interrupt vectors
    mov ax, 0
    mov es, ax
    mov ax, [es:9*4]
    mov [old_kb_vec], ax
    mov ax, [es:9*4+2]
    mov [old_kb_vec+2], ax
    
    mov ax, [es:8*4]
    mov [old_timer], ax
    mov ax, [es:8*4+2]
    mov [old_timer+2], ax
    
    ; Install new interrupt handlers
    cli
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    mov word [es:8*4], timer_isr
    mov [es:8*4+2], cs
    sti
    
    ; Initialize display
    call clrscr
    call print_labels
    call print_time
    
    ; Terminate and stay resident
    mov dx, start       ; Start address
    add dx, 15          ; Round up
    mov cl, 4
    shr dx, cl          ; Convert bytes to paragraphs (divide by 16)
    add dx, 16          ; Add PSP size (256 bytes = 16 paragraphs)
    mov ax, 0x3100
    int 0x21