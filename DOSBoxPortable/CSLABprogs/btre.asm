org 0x100

mov ah, 0x00 
mov al, 0x03 
int 0x10 

mov dh, 0 
mov dl, 0 

mov al, 0
xor bl, bl 
mov cx, 0x0001 

list_attributes:
	mov ah, 0x02 
	int 0x10 

	mov ah, 0x09 
	int 0x10 

	inc dl
	cmp dl, 80

	jnz .next_column 

	inc dh 
	mov dl, 0
	.next_column:
		inc bl 
		test bl, 0xff 
		inc al
		jnz list_attributes 

ret
