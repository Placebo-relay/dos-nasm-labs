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
    sub al, '0'       ; Convert ASCII to number
    mov [height], al  ; Store height

    ; Print newline
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
    int 0x21

    ; Pyramid drawing logic
    mov cl, 0         ; Current line number (starts at 0)
    
draw_line:
    ; Calculate spaces needed (centering)
    mov al, [height]
    dec al
    sub al, cl
    mov bh, al        ; Spaces count = (height-1) - current line

    ; Print leading spaces
    cmp bh, 0
    jz print_coeffs   ; Skip if no spaces needed
    mov ah, 0x02
    mov dl, ' '
print_spaces:
    int 0x21
    dec bh
    jnz print_spaces

print_coeffs:
    ; Calculate coefficients for current line (CL = line number)
    mov ch, 0         ; CH = coefficient index (0 to CL)
    
coeff_loop:
    ; Calculate sign (-1)^(n-k)
    mov al, cl
    sub al, ch
    and al, 1         ; Check if (n-k) is odd/even
    mov dl, '+'        ; Default sign
    jz print_sign
    mov dl, '-'        ; Negative if (n-k) is odd
    
print_sign:
    mov ah, 0x02
    int 0x21          ; Print sign
    
    ; Get binomial coefficient
    mov bl, cl        ; BL = n
    mov bh, ch        ; BH = k
    call binomial     ; Returns coefficient in AX
    
    ; Print coefficient (1 or 2 digits)
    call print_number
    
    ; Print space between coefficients
    mov ah, 0x02
    mov dl, ' '
    int 0x21
    
    ; Next coefficient
    inc ch
    cmp ch, cl
    jbe coeff_loop

    ; Move to next line
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
    int 0x21

    ; Check if done
    inc cl
    mov al, [height]
    dec al            ; Lines run from 0 to height-1
    cmp cl, al
    jbe draw_line

    ; Exit program
    mov ax, 0x4C00
    int 0x21

; Prints number in AX (1 or 2 digits)
print_number:
    push ax
    push bx
    push dx
    
    cmp ax, 10
    jb single_digit
    
    ; Two-digit number
    mov bl, 10
    div bl            ; AH = remainder, AL = quotient
    mov bh, ah        ; Save remainder
    
    ; Print tens digit
    add al, '0'
    mov dl, al
    mov ah, 0x02
    int 0x21
    
    ; Print ones digit
    mov al, bh
    add al, '0'
    mov dl, al
    int 0x21
    jmp done_print
    
single_digit:
    add al, '0'
    mov dl, al
    mov ah, 0x02
    int 0x21
    
done_print:
    pop dx
    pop bx
    pop ax
    ret

; Binomial coefficient lookup for n <= 8
; Input: BL = n, BH = k
; Output: AX = C(n,k)
binomial:
    push bx
    push si
    mov si, binom_table
    mov al, bl        ; AL = n
    mov ah, 0
    mov bl, 9         ; Each row has up to 9 entries
    mul bl            ; AX = n*9 (row offset)
    add si, ax
    mov al, bh        ; AL = k
    mov ah, 0
    add si, ax
    add si, ax        ; Each entry is 2 bytes
    mov ax, [si]      ; Get coefficient from table
    pop si
    pop bx
    ret

section .data
    prompt db 'Enter pyramid height (1-8): $'
    height db 0
    
    ; Precomputed binomial coefficients C(n,k) for n=0..8 (now as words)
    binom_table:
        dw 1,0,0,0,0,0,0,0,0    ; n=0
        dw 1,1,0,0,0,0,0,0,0    ; n=1
        dw 1,2,1,0,0,0,0,0,0    ; n=2
        dw 1,3,3,1,0,0,0,0,0    ; n=3
        dw 1,4,6,4,1,0,0,0,0    ; n=4
        dw 1,5,10,10,5,1,0,0,0  ; n=5
        dw 1,6,15,20,15,6,1,0,0 ; n=6
        dw 1,7,21,35,35,21,7,1,0 ; n=7
        dw 1,8,28,56,70,56,28,8,1 ; n=8