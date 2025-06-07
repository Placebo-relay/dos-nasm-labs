org 0x100

mov ah, 01h
int 21h
sub al, '0'
mov bl, 10
mul bl
mov ch, al

mov ah, 01h
int 21h
sub al, '0'
mov dh, al
	
add ch, dh
	


mov cl, ch ; Количество пустых ячеек
mov bl, 1 ; количество звездочек в этаже
mov dl, 0 ; кол-во выведеных этажей

m_loop:
	;делает 1 отступа после введленого числа
	mov ah, 02h
	mov dl, 0ah
	int 21h
	
	mov bh, 0 ; счетчик пустых ячеек
	mov al, 0 ; счетчик звездочек
	
	shl cl, 1
	shr bl, 2
	shr dl, 1

loop pstart


ret


pstart:
	cmp dl, ch
	jg pend
	
	call void
	
	jmp pstart
	
	
pend:
	ret



void:
	cmp bh, cl
	je star
	
	mov ah, 02h
	mov dl, 0
	int 21h
	
	inc ch
	jmp void
	

	
star:
	cmp al, bl
	je m_loop
	mov ah, 02h
	mov dl, '*'
	int 21h
	
	inc al
	jmp star



	
	

	
	
