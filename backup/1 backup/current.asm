[org 0x100]
jmp start

; Data Section
time_str:    db 'Time: 00:00:00', 0Dh, '$'  ; Time display string
exit_msg:    db 0Dh, 0Ah, 'Press ESC to exit', '$'
oldkb:       dd 0                            ; Original keyboard ISR
exit_flag:   db 0                            ; Exit flag

; Get RTC Time (CH=hours, CL=minutes, DH=seconds)
get_rtc_time:
    mov ah, 0x02
    int 0x1A
    ret

; Convert BCD to Binary (AL=BCD, returns AL=binary)
bcd_to_bin:
    push cx
    mov cl, al
    and al, 0x0F            ; Lower nibble
    shr cl, 4               ; Upper nibble
    mov ah, 10
    mul ah                  ; Multiply upper digit by 10
    add al, cl              ; Add lower digit
    pop cx
    ret

; Convert number to ASCII (AL=number, returns AX=ASCII)
num_to_ascii:
    push bx
    mov bl, 10
    div bl                  ; AH=remainder, AL=quotient
    add ax, '00'            ; Convert both digits to ASCII
    xchg al, ah             ; Proper digit order
    pop bx
    ret

; Update Time String
update_time:
    pusha
    call get_rtc_time
    
    ; Convert and update hours
    mov al, ch
    call bcd_to_bin
    call num_to_ascii
    mov [time_str+6], ax    ; Position after "Time: "
    
    ; Convert and update minutes
    mov al, cl
    call bcd_to_bin
    call num_to_ascii
    mov [time_str+9], ax    ; Position after first colon
    
    ; Convert and update seconds
    mov al, dh
    call bcd_to_bin
    call num_to_ascii
    mov [time_str+12], ax   ; Position after second colon
    popa
    ret

; Clear Screen using DOS
clrscr:
    mov ax, 0x0600          ; Scroll window up
    mov bh, 0x07            ; Normal attribute
    xor cx, cx              ; Upper-left (0,0)
    mov dx, 0x184F          ; Lower-right (24,79)
    int 0x10
    
    ; Set cursor to top-left
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10
    ret

; Keyboard ISR
kbisr:
    push ax
    in al, 0x60
    
    ; Check for ESC key
    cmp al, 0x01
    jne .not_esc
    mov byte [cs:exit_flag], 1
    
.not_esc:
    mov al, 0x20
    out 0x20, al
    pop ax
    iret

; Main Program
start:
    call clrscr
    
    ; Display exit message
    mov ah, 0x09
    mov dx, exit_msg
    int 0x21
    
    ; Save original keyboard ISR
    xor ax, ax
    mov es, ax
    mov ax, [es:9*4]
    mov [oldkb], ax
    mov ax, [es:9*4+2]
    mov [oldkb+2], ax
    
    ; Install our keyboard ISR
    cli
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    sti
    
.main_loop:
    ; Set cursor to beginning of line
    mov ah, 0x02
    xor bh, bh
    mov dh, 0
    xor dl, dl
    int 0x10
    
    ; Update and display time
    call update_time
    mov ah, 0x09
    mov dx, time_str
    int 0x21
    
    ; Check for exit
    cmp byte [cs:exit_flag], 1
    je .exit
    
    ; Wait approximately 1 second
    mov cx, 0x0001
    mov dx, 0x86A0
    mov ah, 0x86
    int 0x15
    
    jmp .main_loop

.exit:
    ; Restore keyboard ISR
    cli
    mov ax, [cs:oldkb]
    mov [es:9*4], ax
    mov ax, [cs:oldkb+2]
    mov [es:9*4+2], ax
    sti
    
    ; Clear screen before exit
    call clrscr
    
    ; Return to DOS
    mov ax, 0x4C00
    int 0x21