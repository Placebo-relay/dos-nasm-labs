org 100h

section .text
    mov ah, 09h
    mov dx, msg
    int 21h

    mov ah, 01h ; DOS "read character" function
    int 21h     ; Waits for a keypress

    ret

msg db 'Press any key...$'