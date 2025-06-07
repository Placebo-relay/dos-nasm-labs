org 0x100

mov ah, 01h
int 21h
mov dh, al

;делает отступ после введленого числа
mov ah, 02h
mov dl, 0ah
int 21h


mov bh, ':' ; Символ с которого начинается отсчет -= 1
loop while_start
	

ret





;Бесконечный цыкл
while_start:
	cmp bh, dh
	je while_end	; если ячейка bh == 0, переходит в while_end и заканчивает программу
	
	mov ah, 02h
	mov dl, bh
	dec dl
	int 21h
	
	
	dec bh
	jmp while_start

while_end:
	ret