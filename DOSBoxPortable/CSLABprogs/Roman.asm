; chapter 2: print A + CRLF ~ used Listing 2.1
; call ascii symbol -> 'I' = I, decimal 73 = I, hex 0x49 = I
org 0x100

mov ah, 0x02    ; Call Console IO function io 0x06 vs o 0x02

mov dl, 73      ; I 73 0x49
int 0x21        ; Call DOS interrupt

mov dl, 0x27    ; apostrophe 39 0x27
int 0x21        ; Call DOS interrupt

mov dl, 'm'     ; m 109 0x6D
int 0x21        ; Call DOS interrupt

mov dl, ' '     ; space 32 0x20
int 0x21        ; Call DOS interrupt

mov dl, 'R'     ; R 82 0x52
int 0x21        ; Call DOS interrupt

mov dl, 'o'     ; o 111 0x6F
int 0x21        ; Call DOS interrupt

mov dl, 0x6D    ; m 109 0x6D
int 0x21        ; Call DOS interrupt

mov dl, 97      ; a 97 0x61
int 0x21        ; Call DOS interrupt

mov dl, 'n'     ; n 110 0x6E
int 0x21        ; Call DOS interrupt

mov dl, 46      ; dot 46 0x2E
int 0x21        ; Call DOS interrupt

mov dl, 0x0D    ; Carriage return (CR)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF)
int 0x21        ; Call DOS interrupt

ret             ; Exit program