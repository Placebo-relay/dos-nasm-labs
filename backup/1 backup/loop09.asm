; chapter 2: print numbers 0-9 with spaces (LOOP VERSION)
org 0x100

mov ah, 0x02      ; Call Console IO function

; Output numbers 0 to 9
mov bl, 0         ; Initialize BL to 0 (starting number)

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
    inc bl         ; Increment number
    cmp bl, 10     ; Compare with 10
    jl print_loop  ; Loop if less than 10

; Print carriage return and line feed
mov dl, 0x0D      ; Carriage return (CR)
int 0x21          ; Call DOS interrupt

mov dl, 0x0A      ; Line feed (LF)
int 0x21          ; Call DOS interrupt

ret                ; Exit program