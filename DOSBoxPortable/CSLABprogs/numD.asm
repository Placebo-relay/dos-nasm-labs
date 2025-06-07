org 0x100

mov ah, 01h
int 21h
sub al, '0'
mov ch, al ; первое число
 
mov ah, 01h
int 21h
sub al, '0'
mov dh, al ; второе число

;делает отступ после введленого числа
mov ah, 02h
mov dl, 0ah
int 21h
mov dl, 0ah
int 21h
	
	
m_loop:
	mov bh, dh
	
loop while_start


ret





;Бесконечный цыкл
while_start:
	cmp bh, 0
	jl while_end	; если ячейка bh == 0, переходит в while_end и заканчивает программу
	
	;выводит числа/символы
	mov ah, 02h
	mov dl, ch
	add dl, '0'
	int 21h

	mov ah, 02h
	mov dl, dh
	add dl, '0'
	int 21h
	
	;делает отступ после введленого числа
	mov ah, 02h
	mov dl, 0ah
	int 21h
	
	
	dec dh
	dec bh
	jmp while_start

while_end:
	dec ch
	cmp ch, 0
	jl program_end
	
	
	add dh, 10
	jmp m_loop
	
program_end:
	ret
	
