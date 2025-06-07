org 0x100


mov bh, 0	; стартовое значение для цикла
loop while_start
	

ret





;Бесконечный цыкл
while_start:
	cmp bh, 10
	je while_end	; если ячейка bh == 0, переходит в while_end и заканчивает программу
	
	mov ah, 02h
	mov dl, bh
	add dl, '0'
	int 21h
	
	
	inc bh
	jmp while_start

while_end:
	ret