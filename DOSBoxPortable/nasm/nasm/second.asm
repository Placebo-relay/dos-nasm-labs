;1 число
mov ah, 09h
mov dx, fmsg
int 21h

mov ah, 01h
int 21h
sub al, '0'
mov bh, al
mov cl, bh

;отступ
mov ah, 02h
mov dl, 0ah
int 21h

;2 число
mov ah, 09h
mov dx, smsg
int 21h

mov ah, 01h
int 21h
sub al, '0'
mov ch, al


;отступ
mov ah, 02h
mov dl, 0ah
int 21h
;отступ
call pscan

mov ah, 09h
mov dx, Final_msg
int 21h


add cl, ch 
add cl, '0'


;Ввыводит результат
mov ah, 02h
add bh, '0'
mov dl, bh
int 21h

mov dl, '+'
int 21h

add ch, '0'
mov dl, ch
int 21h

mov dl, '='
int 21h

mov dl, cl
int 21h


ret


fmsg db 'Input first number: $'
smsg db 'Input second number: $'
Final_msg db 'The result is: $'
Eror_msg db 'Num > 4 $'

pscan:
	cmp bh, 4
	jg pend
	
	cmp ch, 4
	jg pend
	
	ret
	

pend:
	mov ah, 09h
	mov dx, Eror_msg
	int 21h
	mov ax, 4C00h
    int 21h


	