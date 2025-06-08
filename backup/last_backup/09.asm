; chapter 2: print numbers 0-9 with spaces (SIMPLE CRINGE VERSION)
org 0x100

mov ah, 0x02    ; Call Console OUTPUT CHAR function

; Output number 0
mov dl, '0'     ; Load ASCII for '0' (decimal 48, hex 0x30)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 1
mov dl, '1'     ; Load ASCII for '1' (decimal 49, hex 0x31)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 2
mov dl, '2'     ; Load ASCII for '2' (decimal 50, hex 0x32)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 3
mov dl, '3'     ; Load ASCII for '3' (decimal 51, hex 0x33)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 4
mov dl, '4'     ; Load ASCII for '4' (decimal 52, hex 0x34)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 5
mov dl, '5'     ; Load ASCII for '5' (decimal 53, hex 0x35)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 6
mov dl, '6'     ; Load ASCII for '6' (decimal 54, hex 0x36)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 7
mov dl, '7'     ; Load ASCII for '7' (decimal 55, hex 0x37)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 8
mov dl, '8'     ; Load ASCII for '8' (decimal 56, hex 0x38)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 9
mov dl, '9'     ; Load ASCII for '9' (decimal 57, hex 0x39)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Print carriage return and line feed
mov dl, 0x0D    ; Carriage return (CR) (decimal 13, hex 0x0D)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF) (decimal 10, hex 0x0A)
int 0x21        ; Call DOS interrupt

ret             ; Exit program