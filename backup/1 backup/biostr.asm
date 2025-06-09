org 0x100

mov ah, 0x00       ; Set video mode
mov al, 0x03       ; 80x25 text mode
int 0x10

mov ah, 0x13       ; BIOS string write function
mov al, 0x01       ; Update cursor after writing
mov cx, 36         ; String length
mov bl, 0x04       ; Red text attribute (00000100b)
mov dh, 12         ; Center row (12/25)
mov dl, 32         ; Center column (32/80)
mov bp, string     ; String address
int 0x10

mov ah, 0x0E       ; BIOS teletype output function
mov al, 0x0D       ; Carriage return
int 0x10           ; Call BIOS interrupt

mov al, 0x0A       ; Line feed

ret

string db 'We are in Pitirim Sorokin University'