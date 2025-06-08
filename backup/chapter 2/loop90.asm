; chapter 2: print numbers 9-0 with spaces (LOOP VERSION)
org 0x100

mov ah, 0x02      ; Call Console IO function

; Output numbers 9 to 0
mov bl, 9         ; Initialize BL to 9 (starting number)

print_loop:
    ; Convert number in BL to ASCII
    add bl, '0'    ; Convert to ASCII by adding '0' (48)
    mov dl, bl     ; Move the ASCII character to DL
    int 0x21       ; Call DOS interrupt to print character

    ; Print space after each number
    mov dl, ' '    ; Load space character
    int 0x21       ; Call DOS interrupt to print space

    ; Prepare for next iteration
    sub bl, '0'    ; Convert back to integer
    dec bl         ; Decrement number
    cmp bl, 0     ; Compare with 0
    jge print_loop  ; Loop if greater than or equal to 0

; Print carriage return and line feed
mov dl, 0x0D      ; Carriage return (CR)
int 0x21          ; Call DOS interrupt

mov dl, 0x0A      ; Line feed (LF)
int 0x21          ; Call DOS interrupt

ret                ; Exit program