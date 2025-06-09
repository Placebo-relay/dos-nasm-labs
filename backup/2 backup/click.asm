org 0x100
mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x12 ; Режим 640x480
int 0x10 ; Вызов BIOS

mov ax, 0x0000 ; Функция инициализации мыши
int 0x33 ; Вызов прерывания

mov ax, 0x0001 ; Показать курсор мыши
int 0x33 ; Вызов прерывания

mov ax, 0x000c ; Установка обработчика событий мыши
mov cx, 0x0002 ; Событие - нажатие левой кнопки
mov dx, MouseHandler ; Адрес обработчика
int 0x33 ; Вызов прерывания

nopress:
mov al, [was_pressed]
cmp al, 0x01 ; Проверяем состояние флага в памяти
jnz nopress

mov ax, 0x0014 ; Удаление обработчика событий мыши
mov cx, 0x0000 ;
int 0x33 ; Вызов прерывания

mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x03 ; Текстовый режим 80x25, 16 цветов
int 0x10 ; Вызов BIOS

ret

MouseHandler:
push ax
mov al, 0x01
mov [was_pressed], al ; Устанавливаем флаг в памяти
pop ax
retf ; Выходим из обработчика события

was_pressed db 0x00
