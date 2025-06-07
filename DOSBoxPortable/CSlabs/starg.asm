; star pyramid v2
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
    sub al, 0x30      ; Convert ASCII to number '0' 0x30
    mov [height], al ; Store height

    ; Print newline
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
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
    jz print_stars   ; Skip if no spaces needed
    mov ah, 0x02
    mov dl, ' '
print_spaces:
    int 0x21
    dec bh
    jnz print_spaces

print_stars:
    ; Calculate stars needed (2n-1)
    mov al, cl
    add al, cl
    dec al
    mov bh, al       ; Stars count = 2*current line - 1

    ; Print stars
    mov ah, 0x02
    mov dl, [symbol]
print_stars_loop:
    int 0x21
    dec bh
    jnz print_stars_loop

    ; Move to next line
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
    int 0x21

    ; Check if done
    inc cl
    cmp cl, [height]
    jbe draw_line

    ; Exit program
    mov ax, 0x4C00
    int 0x21

section .data
    prompt db 'Enter pyramid height (1-9): $'
    height db 0
    symbol db '*'