org 0x100


mov bh, 10	; счетчик для цикла
loop while_start
	

ret





#Бесконечный цыкл
while_start:
	cmp bh, 0
	je while_end	; если ячейка bh == 0, переходит в while_end и заканчивает программу
	mov ah, 02h
	mov dl, bh
	add dl, '/'
	int 21h
	dec bh
	jmp while_start

while_end:
	ret