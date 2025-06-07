org 0x100

	mov ah, 00h
	mov al, 12h
	int 10h

	mov ax, 0000h
	int 33h

	mov ax, 0001h
	int 33h

	mov ax, 000ch
	mov cx, 0002h
	mov dx, mouseHander
	int 33h

	nouples:
		mov al, [count]
		cmp al, 2
		jl nouples

	mov ax, 0014h
	mov cx, 0000h
	int 33h

	mov ah, 00h
	mov al, 03h
	int 10h

ret



mouseHander:
	push ax
	mov al, 01h
	mov [pres_mouse], al
	pop ax
	inc byte [count]
	retf
	
pres_mouse db 00h
count db 0