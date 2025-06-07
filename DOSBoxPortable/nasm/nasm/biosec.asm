org 0x100

; Инициализация видеорежима 80x25
mov ah, 00h
mov al, 03h
int 10h


mov dh, 4
mov dl, 40
mov [num], byte '0'
call set_cursor


ploop:
	mov al, [num]
	cmp byte [num], '9'+1
	je exit
	
	mov ah, 09h
	mov bl, 0b00000100
	mov cx, 1
	int 10h
	
	inc dh
	inc byte [num]
	
	call set_cursor

	jmp ploop
ret


set_cursor:
	mov ah, 02h
	int 10h
	ret

exit:
	ret
	

num db 0
