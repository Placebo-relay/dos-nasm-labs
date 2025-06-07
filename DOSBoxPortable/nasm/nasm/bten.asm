org 0x100

	mov ah, 00h
	mov al, 13h
	int 10h
	
	
	
	call draw_cross
	
	mov ah, 00h
	int 16h
	mov ah, 00h
	mov al, 03h
	int 10h
	
ret

draw_cross:
    mov cx, 20 ; Координаты начала X and Y 
	mov dx,	20
	
	
square_up:
    mov ah, 0Ch
    mov al, [square_color]
    int 10h
	
	inc cx
	inc byte [numS]
	
	mov bl, [numS]
	cmp bl, [square_size]
	jne square_up
	
	mov [numS], byte 0
	jmp square_right

square_right:
    mov ah, 0Ch
    mov al, [square_color]
    int 10h
	
	inc dx
	inc byte [numS]
	
	mov bl, [numS]
	cmp bl, [square_size]
	jne square_right
	
	mov [numS], byte 0
	jmp square_down
	
square_down:
    mov ah, 0Ch
    mov al, [square_color]
    int 10h
	
	dec cx
	inc byte [numS]
	
	mov bl, [numS]
	cmp bl, [square_size]
	jne square_down
	
	mov [numS], byte 0
	jmp square_left
	
square_left:
    mov ah, 0Ch
    mov al, [square_color]
    int 10h
	
	dec dx
	inc byte [numS]
	
	mov bl, [numS]
	cmp bl, [square_size]
	jne square_left
	
	mov [numS], byte 0
	
	sub [square_size], byte 10
	dec byte [square_color]
	add cx, 5
	add dx, 5
	
	mov bh, [square_color] 
	cmp bh, 0
	jg square_up
	
	ret
	
	
pend:
	ret







square_size db 160
numS db 0

square_color db 15