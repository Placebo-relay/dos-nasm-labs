org 100h

; Первое число
mov ah, 09h
mov dx, fmsg
int 21h

mov ah, 01h
int 21h
sub al, '0'
mov bh, al

mov ah, 02h
mov dl, 0ah
int 21h


; Второе число
mov ah, 09h
mov dx, smsg
int 21h


mov ah, 01h
int 21h
sub al, '0'
mov ch, al


mov ah, 02h
mov dl, 0ah
int 21h

;сложение значений

add bh, ch
aaa


;Вывод числа
mov ah, 02h
add al, '0'
mov dl, al
int 21h
add ah, '0'
mov dl, ah
int 21h

ret



fmsg db 'Input first number: $'
smsg db 'Input second number: $'
Final_msg db 'The result is: $'


