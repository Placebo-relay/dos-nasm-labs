; Listing 2.5 GetDate + added newline
org 0x100

mov ah, 0x2a ; Функция GetDate
int 0x21 ; Вызов операционной системы

push dx ; Запоминаем в стеке текущий месяц и день

mov ax, dx ; Переносим dx в аккумулятор для коррекции
xor ah, ah ; Очищаем ah, т.к. нам нужен только al
aam ; Коррекция

call PrintTwoDigits ; Выводим номер дня в двухразрядном формате

mov ah, 0x06 ; Функция ConsoleIO
mov dl, '-'
int 0x21

pop ax ; Забираем из стека текущий месяц (окажется в ah)
mov al, ah
xor ah, ah ; Переносим ah в al и очищаем первый
aam ; Коррекция

call PrintTwoDigits ; Выводим номер месяца в двухразрядном формате

mov ah, 0x06 ; Функция ConsoleIO
mov dl, '-'
int 0x21

mov ax, cx ; Число для перевода, см. интерфейс ConvertNumber
mov bx, 0x0a ; Основание системы счисления
call ConvertNumber ; Преобразуем число в десятичное, ASCII-вид

mov cx, 0x04 ; Количество разрядов (2025 ~ 4) в номере года знаем заранее
mov ah, 0x06 ; Функция ConsoleIO

output:
mov dl, [si] ; si ссылается на старший разряд в буфере
int 0x21 ; Вызов ОС
inc si ; Двигаемся по буферу

loop output ; Зацикливаемся, cx уменьшается автоматически

; Move to next line
mov ah, 0x09 ;
mov dx, newline ; Переход на новую строку
int 0x21 ;

ret

; PrintTwoDigits
; Вход:
; AH хранит старший разряд
; AL хранит младший разряд
; Выход:

PrintTwoDigits:
push ax ; Сохраняем затрагиваемые регистры
push dx

push ax ; Требуется для алгоритма

mov dl, ah ; Старший разряд
add dl, 0x30 ; Коррекция для вывода

mov ah, 0x06 ; Функция ConsoleIO
int 0x21

pop ax ; Вспоминаем значение ax
mov dl, al ; Теперь младший разряд
add dl, 0x30

mov ah, 0x06
int 0x21

pop dx ; Восстанавливаем значения регистров
pop ax

ret ; Возврат в основную программу

; ConvertNumber
; Вход:
; ax хранит число для преобразования
; bx хранит основание системы счисления
; для преобразования
; Выход:
; si содержит начало буфера с разрядами
; преобразованного числа в ASCII-кодах

ConvertNumber:
push ax ; Сохраняем затрагиваемые регистры
push bx
push dx
mov si, bufferend ; Встаем на конец буфера

.convert:
xor dx, dx ; Очищаем dx
div bx ; Делим ax на основание системы счисления,
; результат деления в ax, остаток - dl
add dl, '0' ; Преобразуем в ASCII-вид
cmp dl, '9' ; Проверяем, получилась ли десятичная цифра
jbe .store ; Да, переходим к сохранению
add dl, 'A' - '0' - 10 ; Нет, преобразуем к нужному виду

.store:
dec si ; Смещаемся по буферу назад
mov [si], dl ; Сохраняем полученное значение
and ax, ax ; Проверяем равенство нулю основного результата
jnz .convert ; Если не ноль, значит есть еще разряды для
; преобразования
.end:
pop dx ; Восстанавливаем значения регистров
pop bx
pop ax
ret

buffer: times 16 db 0 ; 16 нулевых позиций в памяти
bufferend: db 0 ; Конец буфера

newline:
db 0x0a, 0x0d, '$'