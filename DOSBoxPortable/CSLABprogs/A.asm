; chapter 2: print A + CRLF ~ used Listing 2.1
org 0x100

mov ah, 0x02    ; Call Console IO function io 0x06 vs o 0x02
mov dl, 'A'     ; Character to output (ASCII 0x41)
int 0x21        ; Call DOS interrupt

mov dl, 0x0D    ; Carriage return (CR)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF)
int 0x21        ; Call DOS interrupt

ret              ; Exit program