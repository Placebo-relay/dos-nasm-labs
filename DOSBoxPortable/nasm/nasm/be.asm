org 0x100

mov ah, 01h
int 21h
sub al, '0'
mov [numE], byte al ; получаем число от пользователя


;BIOS
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
    mov dx, 100   
    
white:
    mov ah, 0Ch
    mov al, 04h
    int 10h
	
	inc cx
    cmp cx, 320   
    jne white
	
	mov cx, 0
	inc dx
	inc byte [numS]
	
	mov al, [numS]
	cmp al, [numE] 
	jle white
	
	jmp blue
	
blue:
	ret
	
numE db 0
numS db 0