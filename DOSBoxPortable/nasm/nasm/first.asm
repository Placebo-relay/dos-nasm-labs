org 0x100

mov ah, 01h
int 21h
sub al, 48

mov ch, 48
sub ch, al

xor cx, cx
mov cl, ch

inc cl


mov ah, 06h
mov dl, 57
dec_int:
	push dx
	mov dl, 0hd
	int 21h
	mov dl, 0ha
	int 21h
	
	pop dx
	
	int 21h
	dec dl
	
loop dec_int

ret