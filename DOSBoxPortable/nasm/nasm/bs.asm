org 0x100

mov ah, 00h
mov al, 13h
int 10h

; Рисуем крест
call draw_cross

mov ah, 00h
int 16h
mov ah, 00h
mov al, 03h
int 10h


mov ax, 4C00h
int 21h

; mov al, 15h -- белый, mov al, 01h -- синий, mov al, 04h -- крастнй

;рисования креста
draw_cross:
    mov cx, 0   
    mov dx, 0   
    
white:
    mov ah, 0Ch
    mov al, 07h
    int 10h
	
	inc cx
    cmp cx, 320   
    jne white
	
	mov cx, 0
	inc dx
	cmp dx, 67
	jl white
	
	jmp blue
	
	
blue:
    mov ah, 0Ch
    mov al, 01h
    int 10h
	
	inc cx
    cmp cx, 320   
    jne blue
	
	mov cx, 0
	
	inc dx
	cmp dx, 133
	jl blue
	
	jmp red

red:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	inc cx
    cmp cx, 320   
    jne red
	
	mov cx, 0
	inc dx
	cmp dx, 200
	jl red
	
	ret