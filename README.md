# 🖥️ Computer Architecture & Low-Level Programming

🔧 **Dos-box NASM code** for compiling into `.com` files in DOS-box via NASM

## License

* This project is licensed under the GNU General Public License (GPL) version 3.0. 

* This project includes DOS-BOX, which is of the GNU General Public License (GPL) version 2.0 or later.

* This project also includes NASM, which is licensed under the 2-clause BSD license. 

### Licenses

- **DOSBox**: GPL-2.0-or-later
- **NASM**: 2-clause BSD
---

## 📋 Tasks Overview

### **2.1 I/O: Print Your Name & Numbers**
```nasm
org 0x100

mov ah, 0x06    ; Call Console IO function
mov dl, 'A'     ; Character to output (ASCII 0x41)

int 0x21        ; Call DOS interrupt

ret      ; Exit program int 0x20  || ret = return to caller
```
```nasm
; chapter 2: print A + CRLF ~ used Listing 2.1
org 0x100

mov ah, 0x02    ; Call Console IO function io 0x06 vs o 0x02
mov dl, 'A'     ; Character to output (ASCII 0x41)
int 0x21        ; Call DOS interrupt

mov dl, 0x0D    ; Carriage return (CR)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF)
int 0x21        ; Call DOS interrupt

ret              ; Exit program
```

1. ✍️ Display **your name** on the screen.  
2. 🔢 Display numbers from **0 to 9** on the screen.

```nasm
; chapter 2: print A + CRLF ~ used Listing 2.1
; call ascii symbol -> 'I' = I, decimal 73 = I, hex 0x49 = I
org 0x100

mov ah, 0x02    ; Call Console IO function io 0x06 vs o 0x02

mov dl, 73      ; I 73 0x49
int 0x21        ; Call DOS interrupt

mov dl, 0x27    ; apostrophe 39 0x27
int 0x21        ; Call DOS interrupt

mov dl, 'm'     ; m 109 0x6D
int 0x21        ; Call DOS interrupt

mov dl, ' '     ; space 32 0x20
int 0x21        ; Call DOS interrupt

mov dl, 'R'     ; R 82 0x52
int 0x21        ; Call DOS interrupt

mov dl, 'o'     ; o 111 0x6F
int 0x21        ; Call DOS interrupt

mov dl, 0x6D    ; m 109 0x6D
int 0x21        ; Call DOS interrupt

mov dl, 97      ; a 97 0x61
int 0x21        ; Call DOS interrupt

mov dl, 'n'     ; n 110 0x6E
int 0x21        ; Call DOS interrupt

mov dl, 46      ; dot 46 0x2E
int 0x21        ; Call DOS interrupt

mov dl, 0x0D    ; Carriage return (CR)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF)
int 0x21        ; Call DOS interrupt

ret             ; Exit program
```

### **2.2 I/O Input & Validation**  
`N=?` — print **0...N** (one per line):  
- Example: 0, newline, 1, newline, 2, ...  
- File: `num.asm` (Check if N is within 0..9)  

1. 🔄 Display the numbers in **reverse order** on the screen.  
2. ❗ Add a program check to verify whether the number entered by the user is a **single-digit number**.  
3. ⭐ **Display a pyramid** of `*` symbols on the screen, with the number of tiers entered by the user.  
   - File: `starg.asm`  
4. 🚀 Try to implement a version of the program with **two-digit numbers**.

```nasm
; star pyramid v2
org 0x100

section .text
start:
    ; Print prompt
    mov ah, 0x09
    mov dx, prompt
    int 0x21

    ; Read user input (single digit 1-9)
    mov ah, 0x01
    int 0x21
    sub al, 0x30      ; Convert ASCII to number '0' 0x30
    mov [height], al ; Store height

    ; Print newline
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
    int 0x21

    ; Pyramid drawing logic
    mov cl, 1        ; Current line number (starts at 1)
    mov bl, [height] ; Total height

draw_line:
    ; Calculate spaces needed
    mov al, bl
    sub al, cl
    mov bh, al       ; Spaces count = height - current line

    ; Print leading spaces
    cmp bh, 0
    jz print_stars   ; Skip if no spaces needed
    mov ah, 0x02
    mov dl, ' '
print_spaces:
    int 0x21
    dec bh
    jnz print_spaces

print_stars:
    ; Calculate stars needed (2n-1)
    mov al, cl
    add al, cl
    dec al
    mov bh, al       ; Stars count = 2*current line - 1

    ; Print stars
    mov ah, 0x02
    mov dl, [symbol]
print_stars_loop:
    int 0x21
    dec bh
    jnz print_stars_loop

    ; Move to next line
    mov ah, 0x02
    mov dl, 0x0D
    int 0x21
    mov dl, 0x0A
    int 0x21

    ; Check if done
    inc cl
    cmp cl, [height]
    jbe draw_line

    ; Exit program
    mov ax, 0x4C00
    int 0x21

section .data
    prompt db 'Enter pyramid height (1-9): $'
    height db 0
    symbol db '*'
```

---

### **2.3 Basic Calculator**  
`calc.asm` (with validation)  
- **Check** if input numbers are **no more than 4**.

---

### **2.4 Advanced Calculator with Two-Digit Numbers**  
`calc2.asm`  
- **Enhance validation checks** for two-digit inputs.

---

# 2.5 Get Date (0x2a)
1. mov ah, 0x2a
```nasm
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
```
# 3.1 BIOS I/O ~ BIOS 0x00
1. Display your name on the screen.  
2. Display numbers from 0 to 9 on the screen.
# 3.2 color BIOS attributes ~ BIOS 0x00
1. Modify the program so that characters are displayed on the screen with different attributes (colors) per line. Each line should contain one specific color of the symbol.  
The number of lines should be 16, corresponding to the number of possible colors.
# 3.3 string BIOS 0x13
1. Prompt the user for a number from 1 to 10.  
Display on the screen a line like "Х негритят отправились обедать", decreasing the counter in each subsequent line.  
The last line should be: "И никого не стало".
# 3.4 draw BIOS 0x00
1. Learn to draw a dot. Be creative and come up with a task: depict an uncomplicated image using dots, possibly an abstract one.
2. Draw two lines crossing each other in an "X" shape on the screen.
3. Draw a square in the center of the screen.
4. Display the flag on the screen.
5. Ask the user for the width of a line in pixels, then draw a line of the specified width.
# 3.5 draw BIOS 0x00
1. Display on the screen 15 squares of different sizes and colors so that each smaller square is positioned at the center of a larger square.
# 3.6 mouse BIOS 0x00 0x33 0x10
1. Develop a program that will terminate only after the second mouse click, not after the first.
# 3.7 draw via mouse BIOS 0x00 0x33 0x10
1. draw w mouse
# 3.8 RTC (RealTime Clock) 0x0B port 0x70
```nasm
; Listing 3.8
org 0x100

mov al, 0x0b ;0x0B-управляющий регистр RTC
out 0x70, al ;Выбираем этот регистр для чтения, порт 0x70

in al, 0x71 ;Читаем значение регистра
and al, 0b11111011 ;Обнуляем второй бит полученного значения, т.е.
;задаем BCD-формат для вывода даты и времени

out 0x71, al ;Отправляем RTC обновленные настройки

;Далее следует серия запросов к RTC с выводом
;полученных данных на экран.

mov al, 0x07 ;Номер текущего дня
call print_rtc

mov al, '-' ;Символ-разделитель
int 0x29 ;Используем быстрый вывод на экран

mov al, 0x08 ;Номер текущего месяца
call print_rtc

mov al, '-' ;Символ-разделитель
int 0x29 ;Используем быстрый вывод на экран

mov al, 0x32 ;Две старшие цифры года
call print_rtc

mov al, 0x09 ;Две младшие цифры года
call print_rtc

mov al, '' ;Символ-разделитель
int 0x29 ;Используем быстрый вывод на экран

mov al, 0x04 ;Текущий час
call print_rtc

mov al, ':' ;Символ-разделитель
int 0x29 ;Используем быстрый вывод на экран

mov al, 0x02 ;Текущая минута
call print_rtc

mov al, ':' ;Символ-разделитель
int 0x29 ;Используем быстрый вывод на экран

mov al, 0x00 ;Текущая секунда
call print_rtc

ret

print_rtc:

out 0x70, al ;Делаем запрос к RTC
in al, 0x71 ;Получаем ответ

push ax ;Запоминаем значение ax перед модификацией

shr al, 4 ;Выделяем старшие 4 бита ответа
add al, '0' ;Коррекция результата перед выводом
int 0x29 ;Используем быстрый вывод на экран

pop ax

and al, 0x0f ;Выделяем младшие 4 бита
add al, '0' ;Коррекция результата перед выводом
int 0x29 ;Используем быстрый вывод на экран

ret

```
1. Develop a program that continuously displays the current time on the screen.
2. Develop a timer program. The user inputs the number of seconds via the keyboard, and the program should terminate after that amount of time.

