org 0x100

mov ah, 0x06    ; Call Console IO function
mov dl, 'A'     ; Character to output (ASCII 0x41)

int 0x21        ; Call DOS interrupt

mov dl, 'B' 	; call again after
int 0x21		; here we go

mov ah, 0x06    ; Call Console IO function
mov dl, '$'     ; new line please

ret     		; Exit program int 0x20 || ret = return to caller