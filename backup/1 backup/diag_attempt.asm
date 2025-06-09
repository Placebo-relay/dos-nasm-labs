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
    mov cx, 0   
    mov dx, 0     
    
vertical_loop:
    mov ah, 0Ch
    mov al, 04h
    int 10h
    inc dx
	inc cx
	inc cx
	
    cmp cx, 320   
    jl vertical_loop
    
    
    mov dx, 200   
    mov cx, 0     
    
horizontal_loop:
    mov ah, 0Ch
    mov al, 04h
    int 10h
    inc cx
	inc cx
	dec dx
	
	
    cmp cx, 320   
    jl horizontal_loop
    
    ret