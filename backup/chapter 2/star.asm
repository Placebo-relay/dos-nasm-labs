org 0x100

section .text
start:
    ; Print prompt
    mov ah, 0x09
    mov dx, prompt
    int 0x21
	
    ; Read user input (single digit 1-9)
    mov ah, 0x01
    int 0x21
	
    ; Validate input
    cmp al, '1'      ; Check if input is less than '1'
    jb invalid_input
    cmp al, '9'      ; Check if input is greater than '9'
    ja invalid_input
    sub al, 0x30     ; Convert ASCII to number '0' 0x30
    mov [height], al ; Store height
    jmp draw_pyramid  ; Jump to pyramid drawing logic

invalid_input:
    ; Move to next line
    mov ah, 0x09 ;
    mov dx, newline ; Переход на новую строку
    int 0x21 ;

    ; Print error message
    mov ah, 0x09
    mov dx, error_msg
    int 0x21

    ; Move to next line
    mov ah, 0x09 ;
    mov dx, newline ; Переход на новую строку
    int 0x21 ;

    ; Prompt again
    jmp start

draw_pyramid:
    ; Move to next line
    mov ah, 0x09 ;
    mov dx, newline ; Переход на новую строку
    int 0x21 ;

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
    add al, cl	; x2
    dec al ; -1
    mov bh, al       ; Stars count = 2*current line - 1

    ; Print stars
    mov ah, 0x02
    mov dl, [symbol]

print_stars_loop:
    int 0x21
    dec bh
    jnz print_stars_loop

    ; Move to next line
    mov ah, 0x09 ;
    mov dx, newline ; Переход на новую строку
    int 0x21 ;
	
    ; Check if done
    inc cl
    cmp cl, [height]
    jbe draw_line

    ; Exit program = OS reclaims resources
    mov ax, 0x4C00
    int 0x21

section .data
    prompt db 'Enter pyramid height (1-9): $'
    error_msg db 'Invalid input! Please enter a digit between 1 and 9.$'
    height db 0
    symbol db '*'
    newline db 0x0a, 0x0d, '$'
