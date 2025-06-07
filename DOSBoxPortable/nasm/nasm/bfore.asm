org 0x100

mov ah, 08h
int 21h
mov [numS], al
mov [numE], byte '0'

mov ah, 00h
mov al, 03h
int 10h

mov dh, 0
mov dl, 40


loop starter

ret






starter:
	mov al, [numS]
	cmp al, [numE]
	jle while_end
	
	
	;Неработаюий вывод niga
	mov ah, 13h
	mov al, 01h
	mov cx, 1
	mov bl, 0b00000010
	mov dh, dh
	mov dl, 32
	mov bp, numS
	int 10h
	
	;mov ah, 09h
	;mov al, [numS]
	;mov bl, 0b00000010
	;mov cx, 1
	;int 10

	;Вывод сообщения msg
	mov ah, 13h
	mov al, 01h
	mov cx, 14
	mov bl, 0b00000100
	mov dh, dh
	mov dl, 40
	mov bp, msg
	int 10h

	dec byte [numS]
	inc dh
	call set_corsor
	jmp starter


while_end:
	mov ah, 13h
	mov al, 01h
	mov cx, 9
	mov bl, 0b00000100
	mov dh, dh
	mov dl, 32
	mov bp, msgEnd
	int 10h
	ret

set_corsor:
	mov ah, 02h
	int 10h
	ret
	
	
	
	

numS db 9
numE db 0

msg db 'niga go to eat'
msgEnd db 'niga none'