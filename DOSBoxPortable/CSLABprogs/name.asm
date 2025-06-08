; name
org 0x100

; Инициализация видеорежима 80x25
mov ah, 00h
mov al, 03h
int 10h

; Очистка экрана
mov ah, 0x0C
mov al, 0x20
mov bh, 0x00
mov cx, 0
mov dx, 0x184F  ; 80*25-1
int 10h

; Начальная позиция курсора (строка 4, колонка 40)
mov dh, 4
mov dl, 4
call set_cursor

mov si, msg

ploop:
    mov al, [si]
    cmp al, 0
    je exit

    ; Set text color to light green (0x0A)
    mov ah, 0x0B          ; Set text attribute
    mov bh, 0             ; Page number
    mov bl, 0x0A          ; Light green text on black background
    int 10h               ; Set the text attribute

    mov ah, 0Eh          ; BIOS teletype function
    int 10h              ; Print character in AL
    call delay           ; Call delay after printing
    inc si               ; Move to the next character
    jmp ploop

set_cursor:
    mov ah, 02h
    int 10h
    ret

delay:
    ; Simple delay loop
    mov cx, 0xFFFF       ; Adjust this value for longer/shorter delay
delay_loop:
    loop delay_loop
    ret

exit:
    ; Properly terminate the program
    mov ax, 4C00h
    int 21h
    ret

msg db "Hello, world! I'm Roman. I am totally typing!", 0x0D, 0x0A, "Computer architecture is great!", 0x0D, 0x0A, "Use Pareto principle (20% gives 80% of value) to optimise code!", 0x0D, 0x0A, "try my gems: CURRENT, TIMER", 0x0D, 0x0A, 0
