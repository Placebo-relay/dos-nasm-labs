org 0x100

main:
	mov ah, 01h
	int 21h
	sub al, '0'
	mov cl, 10
	mul cl
	add [stop_second], byte al
	
	mov ah, 01h
	int 21h
	sub al, '0'
	add [stop_second], byte al
	
	mov ah, 02h
	mov dl, 0ah
	int 21h
	
    nokey:
		dec byte [stop_second]
        mov cx, 1000    ;Задержка  
        call delay_ms     
        
        call s_info       
        

		mov al, [stop_second]
		cmp al, 0
        jne nokey          
  
ret


s_info:
    
    mov al, 0Bh
    out 70h, al
    in al, 71h
    and al, 0b11111011   
    out 71h, al

    
    mov al, 07h          ; День месяца
    call print_rtc
    
    mov al, '-'
    int 29h
    
    mov al, 08h          ; Месяц
    call print_rtc
    
    mov al, '-'
    int 29h
    
    mov al, 32h          ; Год (старший байт)
    call print_rtc
    mov al, 09h          ; Год (младший байт)
    call print_rtc
    
    mov al, ' '          ; Пробел
    int 29h
    
    mov al, 04h          ; Часы
    call print_rtc
    
    mov al, ':'
    int 29h
    
    mov al, 02h          ; Минуты
    call print_rtc
    
    mov al, ':'
    int 29h
    
    mov al, 00h          ; Секунды
    call print_rtc
    
	;отступ
	mov ah, 02h
	mov dl, 0ah
	int 21h
    ret


print_rtc:
    out 70h, al          
    in al, 71h           
    
    push ax
    shr al, 4            
    add al, '0'          
    int 29h              
    
    pop ax
    and al, 0Fh          
    add al, '0'          
    int 29h              
    
    ret

;Для задержки
delay_ms:
    pusha
    mov ax, cx
    mov dx, 1000
    mul dx               
    mov cx, dx           
    mov dx, ax           
    mov ah, 86h          
    int 15h              
    popa
    ret
	
stop_second db 0