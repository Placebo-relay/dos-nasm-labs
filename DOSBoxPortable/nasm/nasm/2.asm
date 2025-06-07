org 0x100

mov ah, 0x06   ; DOS "direct console I/O" function
mov dl, 'A'   ; Character 'A' to output (0x41)

mov ch, ah     ; Copy AH to CH (upper 8 bits of CX)
; or: mov cx, ax ; Copy entire AX to CX

int 0x21       ; Call DOS interrupt
int 0x20       ; Exit program