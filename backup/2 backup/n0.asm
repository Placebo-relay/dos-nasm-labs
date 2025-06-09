org 100h

section .text
start:
    ; Print prompt
    mov ah, 9
    mov dx, prompt
    int 21h

    ; Read input
    mov ah, 0Ah
    mov dx, input_buffer
    int 21h

    ; Convert input to number
    mov si, input_buffer + 2  ; Point to input string
    xor bx, bx                ; Clear BX for result
    mov cl, [input_buffer + 1] ; Get input length
    cmp cl, 0
    je exit_program            ; Exit if no input

convert_loop:
    mov al, [si]
    cmp al, '0'
    jb convert_done
    cmp al, '9'
    ja convert_done
    
    ; Multiply current total by 10 and add new digit
    mov ax, bx
    mov dx, 10
    mul dx             ; AX = BX * 10
    mov bx, ax
    sub byte [si], '0' ; Convert ASCII to digit
    add bl, [si]       ; Add new digit
    adc bh, 0          ; Handle carry if needed
    
    inc si
    dec cl
    jnz convert_loop

convert_done:
    ; Print newline
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Start from input number (BX) and count down to 0
    mov cx, bx         ; Start counter at input number

print_loop:
    ; Print current number
    call print_number
    
    ; Print newline
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    ; Check if we've reached 0
    cmp cx, 0
    je exit_program
    
    ; Decrement counter
    dec cx
    jmp print_loop

print_number:
    pusha
    mov ax, cx        ; Number to print in AX
    xor cx, cx        ; Digit counter
    mov bx, 10

    ; Handle zero case
    test ax, ax
    jnz extract_digits
    mov dl, '0'
    mov ah, 2
    int 21h
    jmp print_done

extract_digits:
    xor dx, dx
    div bx            ; AX = quotient, DX = remainder
    push dx
    inc cx
    test ax, ax
    jnz extract_digits

print_digits:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_digits

print_done:
    popa
    ret

exit_program:
    mov ah, 4Ch
    int 21h

section .data
    prompt db 'Enter a number (22 best, 0-99 + enter) or get 0: $'
    input_buffer db 3        ; max 2 digits + Enter
             db 0           ; bytes read
             times 3 db 0   ; actual buffer

section .bss
    digit_buffer resb 3