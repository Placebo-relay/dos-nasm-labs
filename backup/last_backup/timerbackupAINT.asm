org 0x100

section .data
    prompt db 'Enter countdown time (1-99 seconds): $'
    invalid_msg db 'Invalid input! Please enter 1-99.$'
    clear_screen db 0x1B, '[2J$'  ; ANSI clear screen
    big_num_top db ' _  ', '     ', ' _  ', ' _  ', '     ', ' _  ', ' _  ', ' _  ', ' _  ', ' _  ', '$'
    big_num_mid db '| | ', '  | ', ' _| ', ' _| ', '|_| ', '|_  ', '|_  ', '  | ', '|_| ', '|_| ', '$'
    big_num_bot db '|_| ', '  | ', '|_  ', ' _| ', '  | ', ' _| ', '|_| ', '  | ', '|_| ', ' _| ', '$'

section .bss
    seconds_left resb 1
    last_second resb 1
    cursor_row resb 1
    cursor_col resb 1
    input_buffer resb 3

section .text
start:
    ; Clear screen
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

    ; Set cursor position for prompt
    mov ah, 0x02
    mov bh, 0
    mov dh, 10
    mov dl, 20
    int 0x10

    ; Print prompt (light cyan)
    mov bl, 0x0B
    mov si, prompt
    mov cx, 33
    call print_colored

    ; Read input
    call read_number
    cmp ax, 1
    jb invalid_input
    cmp ax, 99
    ja invalid_input

    mov [seconds_left], al
    mov byte [last_second], 0xFF  ; Initialize with invalid value

    ; Clear screen for countdown
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

countdown_loop:
    ; Get current second from RTC
    mov ah, 0x02
    int 0x1A
    mov al, dh      ; Seconds in BCD format
    call bcd_to_bin ; Convert to binary

    ; Only update display when second changes
    cmp al, [last_second]
    je countdown_loop
    mov [last_second], al

    ; Check if time expired
    cmp byte [seconds_left], 0
    je countdown_end

    ; Display current time
    call display_big_number

    ; Decrement counter
    dec byte [seconds_left]
    jmp countdown_loop

countdown_end:
    ; Display "00"
    mov byte [seconds_left], 0
    call display_big_number

    ; Wait for keypress
    mov ah, 0x00
    int 0x16

    ; Exit
    mov ax, 0x4C00
    int 0x21

invalid_input:
    ; Set cursor position for error
    mov ah, 0x02
    mov bh, 0
    mov dh, 12
    mov dl, 20
    int 0x10

    ; Print error (light red)
    mov bl, 0x0C
    mov si, invalid_msg
    mov cx, 34
    call print_colored

    ; Wait 2 seconds
    mov cx, 0x001E
    mov dx, 0x8480
    mov ah, 0x86
    int 0x15

    jmp start

; ----------------------------
; Helper Functions
; ----------------------------

read_number:
    ; Reads 1 or 2 digit number, returns in AX
    mov di, input_buffer
    mov cx, 2
    xor bx, bx
    
.read_digit:
    mov ah, 0x01
    int 0x21
    cmp al, 0x0D    ; Enter pressed?
    je .process_input
    sub al, '0'
    cmp al, 9
    ja .invalid
    mov [di], al
    inc di
    loop .read_digit
    
    ; Read one more char to consume Enter
    mov ah, 0x01
    int 0x21
    
.process_input:
    cmp di, input_buffer
    je .invalid     ; No input
    
    mov al, [input_buffer]
    mov ah, 0
    cmp di, input_buffer+1
    je .single_digit
    
    ; Two digits
    mov bl, 10
    mul bl
    add al, [input_buffer+1]
    jmp .done
    
.single_digit:
    ; Just return the single digit
    jmp .done
    
.invalid:
    xor ax, ax      ; Return 0 if invalid
    
.done:
    ret

bcd_to_bin:
    ; Converts BCD in AL to binary
    push cx
    mov ch, al
    and ch, 0x0F
    shr al, 4
    mov cl, 10
    mul cl
    add al, ch
    pop cx
    ret

display_big_number:
    ; Display [seconds_left] as big number
    pusha
    
    ; Calculate digits
    mov al, [seconds_left]
    xor ah, ah
    mov bl, 10
    div bl          ; AL = tens, AH = units
    
    mov bl, al      ; Save tens digit
    mov bh, ah      ; Save units digit
    
    ; Set starting position (centered)
    mov byte [cursor_row], 8
    mov byte [cursor_col], 30
    
    ; Display tens digit (even if 0)
    call set_cursor
    mov si, big_num_top
    call print_digit_part
    
    inc byte [cursor_row]
    call set_cursor
    mov si, big_num_mid
    call print_digit_part
    
    inc byte [cursor_row]
    call set_cursor
    mov si, big_num_bot
    call print_digit_part
    
    ; Display units digit
    sub byte [cursor_row], 2
    add byte [cursor_col], 5
    
    call set_cursor
    mov si, big_num_top
    mov bl, bh      ; Use units digit
    call print_digit_part
    
    inc byte [cursor_row]
    call set_cursor
    mov si, big_num_mid
    mov bl, bh
    call print_digit_part
    
    inc byte [cursor_row]
    call set_cursor
    mov si, big_num_bot
    mov bl, bh
    call print_digit_part
    
    popa
    ret

print_digit_part:
    ; Prints part of big digit (SI=table, BL=digit)
    pusha
    mov al, bl
    xor ah, ah
    mov cx, 4       ; Each digit part is 4 bytes
    mul cx
    add si, ax
    
    mov cx, 4
    mov ah, 0x09
    mov bh, 0
    mov bl, 0x0E    ; Yellow color
.print_char:
    lodsb
    cmp al, '$'
    je .done
    push cx
    mov cx, 1
    int 0x10
    
    ; Move cursor right
    mov ah, 0x03
    int 0x10
    inc dl
    mov ah, 0x02
    int 0x10
    
    mov ah, 0x09
    pop cx
    loop .print_char
.done:
    popa
    ret

set_cursor:
    ; Sets cursor to [cursor_row], [cursor_col]
    mov ah, 0x02
    mov bh, 0
    mov dh, [cursor_row]
    mov dl, [cursor_col]
    int 0x10
    ret

print_colored:
    ; Prints colored string (SI=string, CX=length, BL=color)
    pusha
    mov ah, 0x09
    mov bh, 0
.print_char:
    lodsb
    cmp al, '$'
    je .done
    push cx
    mov cx, 1
    int 0x10
    
    ; Move cursor right
    mov ah, 0x03
    int 0x10
    inc dl
    mov ah, 0x02
    int 0x10
    
    mov ah, 0x09
    pop cx
    loop .print_char
.done:
    popa
    ret