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

;рисования креста
draw_cross:
    mov cx, 135   
    mov dx, 125   
    
hor_up:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	dec dx
    cmp dx, 75   
    jne hor_up

vert_up:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	inc cx
    cmp cx, 185   
    jne vert_up      
         
    
hor_down:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	inc dx
    cmp dx, 125   
    jne hor_down

vert_down:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	dec cx
    cmp cx, 135   
    jne vert_down
	
	ret