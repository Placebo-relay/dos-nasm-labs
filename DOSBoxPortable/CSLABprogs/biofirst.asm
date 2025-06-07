org 0x100

; Инициализация видеорежима 80x25
mov ah, 00h
mov al, 03h
int 10h

; Начальная позиция курсора (строка 4, колонка 40)
mov dh, 4
mov dl, 40
call set_cursor

mov si, msg

ploop:
	mov al, [si]
	cmp al, 0
	je exit
	mov ah, 09h
	mov bl, 0b00000100
	mov cx, 1
	int 10h
	inc dl
	call set_cursor
	inc si
	jmp ploop


ret


set_cursor:
	mov ah, 02h
	int 10h
	ret

exit:
	ret
	
	
msg db 'ALEXSEY', 0

