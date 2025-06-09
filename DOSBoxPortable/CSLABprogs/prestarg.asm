org 0x100

section .data
prompt db "Enter a number (0-99): $"
error_msg db "Invalid input! Enter 0-99.$"
newline db 0x0D, 0x0A, 0

section .bss
buffer resb 3        ; buffer for input characters + null

section .text
start:
    ; Print prompt
    mov ah, 9
    mov dx, prompt
    int 0x21

    ; Read input characters until Enter
    lea si, [buffer]
    xor cx, cx        ; count of chars
read_char:
    mov ah, 0x01
    int 0x21
    cmp al, 13        ; Enter key
    je validate
    ; store character
    mov [si], al
    inc si
    inc cx
    jmp read_char

validate:
    ; null-terminate input
    mov byte [si], 0

    ; validate input: only digits, length 1 or 2
    lea si, [buffer]
    mov al, [si]
    cmp al, '0'
    jb invalid
    cmp al, '9'
    ja invalid

    mov bl, [si+1]
    cmp bl, 0
    je single_digit
    cmp bl, '0'
    jb invalid
    cmp bl, '9'
    ja invalid

    ; convert input to number
    ; if one digit
    cmp bl, 0
    je convert_one
    ; two digits: number = (digit1 - '0')*10 + (digit2 - '0')
    mov al, [si]
    sub al, '0'
    mov ah, 0
    mov bl, [si+1]
    sub bl, '0'
    mov cl, 10
    mul cl        ; AL * 10 -> AX
    ; add second digit
    mov al, bl
    add ax, ax    ; No, better:
    ; Correct way:
    mov al, [si]
    sub al, '0'
    mov bl, [si+1]
    sub bl, '0'
    mov cl, 10
    mul cl        ; AL * 10 -> AX
    add ax, bx    ; add ones digit
    jmp check_range

convert_one:
    mov al, [si]
    sub al, '0'
    mov bx, ax     ; store number in bx
    jmp check_range

invalid:
    mov ah, 9
    mov dx, error_msg
    int 0x21
    jmp $

check_range:
    mov ax, bx
    cmp ax, 0
    jl invalid
    cmp ax, 99
    jg invalid

    ; Loop from input down to 0
    mov cx, ax      ; counter
    mov dx, 0       ; current number in dx

print_loop:
    ; convert dx to string
    push cx
    push dx

    ; handle zero explicitly
    cmp dx, 0
    jne convert_number
    mov byte [buffer], '0'
    mov byte [buffer+1], 0
    jmp print_str

convert_number:
    ; convert dx to string (max 2 digits)
    mov ax, dx
    xor dx, dx
    mov si, buffer

    ; divide by 10 to get tens
    mov ax, dx
    mov bx, ax
    mov cx, 10
    div cx
    ; quotient in al (tens), remainder in ah (ones)
    ; but in NASM, div divides dx:ax by operand
    ; Let's do a simple division:
    mov ax, dx
    xor dx, dx
    mov cx, 10
    div cx
    ; now:
    ; al = tens digit
    ; ah = ones digit
    add al, '0'
    mov [si], al
    mov bl, ah
    add bl, '0'
    mov [si+1], bl
    mov byte [si+2], 0

print_str:
    ; print number string
    mov ah, 9
    mov dx, si
    int 0x21

    ; print CRLF
    mov ah, 9
    mov dx, newline
    int 0x21

    ; restore registers
    pop dx
    pop cx

    ; decrement dx
    dec dx
    loop print_loop

    ; Exit
    mov ah, 0x4C
    xor al, al
    int 0x21