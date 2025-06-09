org 0x100

section .text
start:
    ; Print prompt
    mov ah, 0x09
    mov dx, prompt
    int 0x21

    ; Read first digit
    mov ah, 0x01
    int 0x21
    mov [first_digit], al

    ; Read second digit (if present)
    mov ah, 0x01
    int 0x21
    mov [second_digit], al

    ; Check if second digit is CR (Enter pressed)
    cmp al, 0x0D
    je single_digit_input

    ; Validate two-digit input (10-29)
    mov al, [first_digit]
    cmp al, '1'
    jb invalid_input
    cmp al, '2'
    ja invalid_input

    mov al, [second_digit]
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input

    ; Convert two digits to number
    mov al, [first_digit]
    sub al, '0'
    mov bl, 10
    mul bl
    mov bl, al
    mov al, [second_digit]
    sub al, '0'
    add al, bl
    mov [height], al
    jmp draw_pyramid

single_digit_input:
    ; Validate single digit (1-9)
    mov al, [first_digit]
    cmp al, '1'
    jb invalid_input
    cmp al, '9'
    ja invalid_input

    ; Convert to number
    sub al, '0'
    mov [height], al
    jmp draw_pyramid

invalid_input:
    ; Move to next line
    mov ah, 0x09
    mov dx, newline
    int 0x21

    ; Print error message
    mov ah, 0x09
    mov dx, error_msg
    int 0x21

    ; Move to next line
    mov ah, 0x09
    mov dx, newline
    int 0x21

    ; Prompt again
    jmp start

draw_pyramid:
    ; Move to next line
    mov ah, 0x09
    mov dx, newline
    int 0x21

    ; Pyramid drawing logic
    mov cl, 1        ; Current line number (starts at 1)
    mov bl, [height] ; Total height

draw_line:
    ; Calculate spaces needed
    mov al, bl
    sub al, cl
    mov bh, al       ; Spaces count = height - current line

    ; Print leading spaces
    cmp bh, 0
    jz print_stars
    mov ah, 0x02
    mov dl, ' '

print_spaces:
    int 0x21
    dec bh
    jnz print_spaces

print_stars:
    ; Calculate stars needed (2n-1)
    mov al, cl
    add al, cl       ; x2
    dec al           ; -1
    mov bh, al       ; Stars count = 2*current line - 1

    ; Print stars
    mov ah, 0x02
    mov dl, [symbol]

print_stars_loop:
    int 0x21
    dec bh
    jnz print_stars_loop

    ; Move to next line
    mov ah, 0x09
    mov dx, newline
    int 0x21

    ; Check if done
    inc cl
    cmp cl, [height]
    jbe draw_line

    ; Exit program
    mov ax, 0x4C00
    int 0x21

section .data
    prompt db 'Enter pyramid height (best 1-24, 29 max): $'
    error_msg db 'Invalid input! Please enter a number between 1 and 29.$'
    first_digit db 0
    second_digit db 0
    height db 0
    symbol db '*'
    newline db 0x0D, 0x0A, '$'