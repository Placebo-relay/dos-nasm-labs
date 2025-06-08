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

mov ah, 0x02    ; Call Console OUT_CHAR function 0x06 = IN+OUT char
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
```nasm
; chapter 2: print numbers 0-9 with spaces (SIMPLE CRINGE VERSION)
org 0x100

mov ah, 0x02    ; Call Console OUTPUT CHAR function

; Output number 0
mov dl, '0'     ; Load ASCII for '0' (decimal 48, hex 0x30)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 1
mov dl, '1'     ; Load ASCII for '1' (decimal 49, hex 0x31)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 2
mov dl, '2'     ; Load ASCII for '2' (decimal 50, hex 0x32)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 3
mov dl, '3'     ; Load ASCII for '3' (decimal 51, hex 0x33)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 4
mov dl, '4'     ; Load ASCII for '4' (decimal 52, hex 0x34)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 5
mov dl, '5'     ; Load ASCII for '5' (decimal 53, hex 0x35)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 6
mov dl, '6'     ; Load ASCII for '6' (decimal 54, hex 0x36)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 7
mov dl, '7'     ; Load ASCII for '7' (decimal 55, hex 0x37)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 8
mov dl, '8'     ; Load ASCII for '8' (decimal 56, hex 0x38)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Output number 9
mov dl, '9'     ; Load ASCII for '9' (decimal 57, hex 0x39)
int 0x21        ; Call DOS interrupt to print character
mov dl, ' '     ; Load space character (decimal 32, hex 0x20)
int 0x21        ; Call DOS interrupt to print space

; Print carriage return and line feed
mov dl, 0x0D    ; Carriage return (CR) (decimal 13, hex 0x0D)
int 0x21        ; Call DOS interrupt

mov dl, 0x0A    ; Line feed (LF) (decimal 10, hex 0x0A)
int 0x21        ; Call DOS interrupt

ret             ; Exit program
```
```
; chapter 2: print numbers 0-9 with spaces (LOOP VERSION)
org 0x100

mov ah, 0x02      ; Call Console IO function

; Output numbers 0 to 9
mov bl, 0         ; Initialize BL to 0 (starting number)

print_loop:
    ; Convert number in BL to ASCII
    add bl, '0'    ; Convert to ASCII by adding '0' (48)
    mov dl, bl     ; Move the ASCII character to DL
    int 0x21       ; Call DOS interrupt to print character

    ; Print space after each number
    mov dl, ' '    ; Load space character
    int 0x21       ; Call DOS interrupt to print space

    ; Prepare for next iteration
    sub bl, '0'    ; Convert back to integer
    inc bl         ; Increment number
    cmp bl, 10     ; Compare with 10
    jl print_loop  ; Loop if less than 10

; Print carriage return and line feed
mov dl, 0x0D      ; Carriage return (CR)
int 0x21          ; Call DOS interrupt

mov dl, 0x0A      ; Line feed (LF)
int 0x21          ; Call DOS interrupt

ret                ; Exit program
```
```
; chapter 2: print numbers 9-0 with spaces (LOOP VERSION)
org 0x100

mov ah, 0x02      ; Call Console IO function

; Output numbers 9 to 0
mov bl, 9         ; Initialize BL to 9 (starting number)

print_loop:
    ; Convert number in BL to ASCII
    add bl, '0'    ; Convert to ASCII by adding '0' (48)
    mov dl, bl     ; Move the ASCII character to DL
    int 0x21       ; Call DOS interrupt to print character

    ; Print space after each number
    mov dl, ' '    ; Load space character
    int 0x21       ; Call DOS interrupt to print space

    ; Prepare for next iteration
    sub bl, '0'    ; Convert back to integer
    dec bl         ; Decrement number
    cmp bl, 0     ; Compare with 0
    jge print_loop  ; Loop if greater than or equal to 0

; Print carriage return and line feed
mov dl, 0x0D      ; Carriage return (CR)
int 0x21          ; Call DOS interrupt

mov dl, 0x0A      ; Line feed (LF)
int 0x21          ; Call DOS interrupt

ret                ; Exit program
```
```
; Cheat program to print a string of numbers 0->9
org 0x100

section .data
myString db '0 1 2 3 4 5 6 7 8 9$' ; String with a dollar sign terminator

section .text
start:
    mov ah, 0x09           ; Set function to print string
    mov dx, myString       ; Load address of the string into DX
    int 0x21               ; Call DOS interrupt to print the string

    ; Print carriage return and line feed
    mov dl, 0x0D           ; Carriage return (CR)
    mov ah, 0x02           ; Set function to print character
    int 0x21               ; Call DOS interrupt to print CR

    mov dl, 0x0A           ; Line feed (LF)
    int 0x21               ; Call DOS interrupt to print LF

    ; Properly terminate the program
    mov ax, 0x4C00         ; Terminate program function (lol can't use ret)
    int 0x21               ; Call DOS interrupt to terminate
```
### **2.2 I/O Input & Validation**  
`N=?` — print **0...N** (one per line):  
- Example: 0, newline, 1, newline, 2, ...  
- File: `num.asm` (Check if N is within 0..9)  

```
; Listing 2.2 +CRLF called prestar
; Программа запрашивает одноразрядное число с клавиатуры,
; а затем выводит на экран числа от 0 до введенного в столбик
; Added: CRLF in the end

org 0x100

mov ah, 0x01 ; Функция Keyboard Input
int 0x21 ; Вызываем операционную систему

sub al, 0x30 ; Вычитаем из результата ввода 30h, чтобы
; получить из ASCII-кода число

xor cx, cx ; Очищаем на всякий случай cx

mov cl, al ; Регистр cl используется для организации цикла,
; в нашем случае число итераций лежит в al
; после вызова DOS

inc cl ; Увеличиваем на 1, чтобы вывести числа,
; включая (!) введенное

mov ah, 0x06 ; Функция Console I/O
mov dl, 0x30 ; Код нуля

label: ; Метка начала цикла

push dx ; Сохраняем временно в стеке значение dx

mov dl, 0x0d ; Выводим на экран "возврат каретки"
int 0x21
mov dl, 0x0a ; Выводим на экран "перевод строки"
int 0x21

pop dx ; Возвращаем сохраненное значение dx

int 0x21 ; Выводим текущий символ
inc dl ; Инкрементируем dl, переходя к следующему символу

loop label ; Переходим к метке, если значение cl положительное,
; при этом происходит авто декремент регистра

mov dl, 0x0d ; added Выводим на экран "возврат каретки"
int 0x21
mov dl, 0x0a ; added Выводим на экран "перевод строки"
int 0x21

ret
```

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

```NASM
; 3.3.2
org 0x100

section .data
    prompt db 'How many monkeys left (1-9)? $'
    msg db ' little monkeys went to eat$'
    msgEnd db 'And there were none$'
    newline db 0x0D, 0x0A, '$'
    invalid_msg db 'Invalid input! Please enter 1-9.$'
    clear_screen db 0x1B, '[2J$'  ; ANSI clear screen sequence

section .bss
    monkey_count resb 1
    current_row resb 1

section .text
start:
    ; Clear screen using ANSI
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

    ; Set cursor position for prompt
    mov ah, 0x02
    mov bh, 0
    mov dh, 10       ; Row
    mov dl, 24       ; Column
    int 0x10

    ; Print prompt (light cyan)
    mov bl, 0x0B     ; Light cyan
    mov si, prompt
    mov cx, 28       ; Length of prompt
    call print_colored

    ; Read input
    mov ah, 0x01
    int 0x21
    sub al, '0'

    ; Validate input
    cmp al, 1
    jb invalid_input
    cmp al, 9
    ja invalid_input

    mov [monkey_count], al
    mov byte [current_row], 5  ; Start printing monkeys at row 5

    ; Clear screen again for output
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

monkey_loop:
    mov al, [monkey_count]
    cmp al, 0
    je no_more_monkeys

    ; Set cursor position for number
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Current row
    mov dl, 30             ; Fixed column for number
    int 0x10

    ; Print count (light red)
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x0C     ; Light red
    add al, '0'
    int 0x10
    sub al, '0'

    ; Set cursor position for message (same row, next column)
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Same row
    mov dl, 32             ; Column after number
    int 0x10

    ; Print message (light green)
    mov bl, 0x0A     ; Light green
    mov si, msg
    mov cx, 26       ; Length of msg
    call print_colored

    ; Move to next row
    inc byte [current_row]
    dec byte [monkey_count]
    jmp monkey_loop

no_more_monkeys:
    ; Set cursor position for ending message
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Next available row
    mov dl, 30             ; Centered column
    int 0x10

    ; Print ending message (yellow)
    mov bl, 0x0E     ; Yellow
    mov si, msgEnd
    mov cx, 17       ; Length of msgEnd
    call print_colored

    ; Wait for keypress before exiting
    mov ah, 0x00
    int 0x16
	
	; Set cursor position for message (same row, next column)
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Same row
	inc dh						; not same ~ +1
    mov dl, 0             ; Column after number
    int 0x10
	
    ; Exit
    mov ax, 0x4C00
    int 0x21

invalid_input:
    ; Set cursor position for error message
    mov ah, 0x02
    mov bh, 0
    mov dh, 12       ; Row
    mov dl, 22       ; Column
    int 0x10

    ; Print error message (light red)
    mov bl, 0x0C     ; Light red
    mov si, invalid_msg
    mov cx, 34       ; Length of invalid_msg
    call print_colored

    ; Wait 2 seconds
    mov cx, 0x001E
    mov dx, 0x8480
    mov ah, 0x86
    int 0x15

    jmp start

print_colored:
    ; BIOS function to print colored string
    ; Input: SI=string, CX=length, BL=color
    pusha
    mov ah, 0x09     ; Write character and attribute
    mov bh, 0        ; Page number
.print_char:
    lodsb            ; Load next character
    cmp al, '$'      ; Check for end of string
    je .done
    mov cx, 1        ; Print one character
    int 0x10
    
    ; Move cursor forward
    mov ah, 0x03     ; Get cursor position
    int 0x10
    inc dl           ; Next column
    mov ah, 0x02     ; Set cursor position
    int 0x10
    
    mov ah, 0x09     ; Restore function
    jmp .print_char
.done:
    popa
    ret
```
# 3.4 draw BIOS 0x00
1. Learn to draw a dot. Be creative and come up with a task: depict an uncomplicated image using dots, possibly an abstract one.
2. Draw two lines crossing each other in an "X" shape on the screen.
3. Draw a square in the center of the screen.
4. Display the flag on the screen.
5. Ask the user for the width of a line in pixels, then draw a line of the specified width.

```NASM
; Simple Snake eating food CONCEPT
org 0x100

; Set graphics mode
mov ax, 0x0013  ; 320x200, 256 colors
int 0x10

; Draw snake + food
mov ah, 0x0C    ; BIOS draw pixel function
mov bh, 0       ; Page number

; Food
mov al, 0x0C    ; Light red color
mov cx, 160     ; X position (center)
mov dx, 100     ; Y position
int 0x10

; Snake
mov al, 0x02    ; Green color
mov cx, 130     ; Start of snake (tail)
mov dx, 120     ; Y position
mov si, 20       ; Number of horizontal dots

draw_horizontal_part:
int 0x10
inc cx
dec si
jnz draw_horizontal_part

mov si, 20       ; Number of vertical dots

draw_vertical_part:
int 0x10
dec dx
dec si
jnz draw_vertical_part

mov si, 10       ; Number of horizontal dots

draw_horizontal_part2:
int 0x10
inc cx
dec si
jnz draw_horizontal_part2


; Wait for keypress
mov ah, 0x00
int 0x16

; Return to text mode
mov ax, 0x0003
int 0x10

ret
```

# 3.5 draw BIOS 0x00
1. Display on the screen 15 squares of different sizes and colors so that each smaller square is positioned at the center of a larger square.
```nasm
; Listing 3.5 rect.asm ADJACENT RECTS
; Программа отрисовывает в середине экрана
; квадраты, перебирая при этом 15 стандартных цветов

org 0x100

mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x13 ; Графический режим 320x200, 256 цветов
int 0x10 ; Вызов BIOS

mov cx, 10 ; Координата левого верхнего угла первого квадрата
mov dx, 80 ; Координата, определяющая позицию строки с квадратами
mov si, 15 ; Размер квадратов
mov al, 15 ; Цвет первого квадрата

plotting:

call PlotSquare ; Отрисовываем квадрат

add cx, 20 ; Передвигаемся по горизонтали
dec al ; Изменяем цвет, а также декрементируем счетчик

jnz plotting ; Переход, если не достигли нуля

nokey:
mov ah, 0x01 ; Функция чтения клавиатуры
int 0x16 ; Вызов BIOS
jz nokey ; Переходим, если ничего не прочитано, т.е. находимся здесь, пока не будет нажата клавиша

mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x03 ; Текстовый режим 80x25, 16 цветов
int 0x10 ; Вызов BIOS

ret

PlotSquare:

; Вход:
; cx хранит горизонтальную координату левого верхнего угла
; dx хранит вертикальную координату левого верхнего угла
; si хранит размер стороны квадрата
; al хранит цвет

push si ; Запоминаем значения регистров
push cx
push dx
push ax
push di

mov di, si ; В di будет храниться ширина
mov ah, 0x0c ; Функция BIOS отображения точки

.plot:
; Здесь в одном цикле отрисовываются все точки квадрата.
; Начальное значение счетчика si равно длине стороны,
; координаты точек записываются в пару регистров cx, dx.
; Для понимания порядка отрисовки точек сделайте рисунок на бумаге.

add cx, si
int 0x10 ; Вызов BIOS

add dx, di
int 0x10 ; Вызов BIOS

sub cx, si
sub dx, di
add dx, si
int 0x10 ; Вызов BIOS

add cx, di
int 0x10 ; Вызов BIOS

sub cx, di
sub dx, si

dec si ; Декрементируем счетчик
jnz .plot ; Переход, если не все точки отрисованы

int 0x10 ; Отрисовываем последнюю точку

pop di ; Восстанавливаем значения регистров
pop ax ; Внимание! Восстановление идет в порядке,
pop dx ; обратном тому, в котором регистры
pop cx ; были помещены в стек.
pop si

ret
```
```nasm
; nest.asm based on Listing 3.5 rect.asm
; Программа отрисовывает в середине экрана
; вложенные квадраты, перебирая при этом 15 стандартных цветов

org 0x100

mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x13 ; Графический режим 320x200, 256 цветов
int 0x10 ; Вызов BIOS

mov cx, 160 ; Центр по X (ширина экрана / 2)
mov dx, 100 ; Центр по Y (высота экрана / 2)
mov si, 150 ; Размер самого большого квадрата
mov al, 15 ; Цвет самого большого квадрата

plotting:

call PlotSquare ; Отрисовываем квадрат

; Уменьшаем размер квадрата для вложенного квадрата
sub si, 10 ; Уменьшаем размер квадрата
dec al ; Изменяем цвет, а также декрементируем счетчик

jnz plotting ; Переход, если не достигли нуля

nokey:
mov ah, 0x01 ; Функция чтения клавиатуры
int 0x16 ; Вызов BIOS
jz nokey ; Переходим, если ничего не прочитано, т.е. находимся здесь, пока не будет нажата клавиша

mov ah, 0x00 ; Функция BIOS выбора графического режима
mov al, 0x03 ; Текстовый режим 80x25, 16 цветов
int 0x10 ; Вызов BIOS

ret

PlotSquare:

; Вход:
; cx хранит горизонтальную координату центра квадрата
; dx хранит вертикальную координату центра квадрата
; si хранит размер стороны квадрата
; al хранит цвет

push si ; Запоминаем значения регистров
push cx
push dx
push ax
push di

mov di, si ; В di будет храниться ширина
mov ah, 0x0c ; Функция BIOS отображения точки

; Вычисляем координаты для отрисовки квадрата
mov bx, si ; Сохраняем размер квадрата в bx
shr bx, 1 ; Делим размер на 2 для центрирования
sub cx, bx ; Сдвигаем cx на размер квадрата влево
sub dx, bx ; Сдвигаем dx на размер квадрата вверх

.plot:
; Здесь в одном цикле отрисовываются все точки квадрата.
; Начальное значение счетчика si равно длине стороны,
; координаты точек записываются в пару регистров cx, dx.

add cx, si
int 0x10 ; Вызов BIOS

add dx, di
int 0x10 ; Вызов BIOS

sub cx, si
sub dx, di
add dx, si
int 0x10 ; Вызов BIOS

add cx, di
int 0x10 ; Вызов BIOS

sub cx, di
sub dx, si

dec si ; Декрементируем счетчик
jnz .plot ; Переход, если не все точки отрисованы

int 0x10 ; Отрисовываем последнюю точку

pop di ; Восстанавливаем значения регистров
pop ax ; Внимание! Восстановление идет в порядке,
pop dx ; обратном том, в котором регистры
pop cx ; были помещены в стек.
pop si

ret
```

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

```NASM
[org 0x0100]
jmp start

;---------------------------------------;
; Countdown timer variables
chrs:       dw 0                        ; countdown hours
cmin:       dw 0                        ; countdown minutes
csec:       dw 0                        ; countdown seconds (will be set by user)
cms:        dw 0                        ; countdown milliseconds
cdt:        db 0                        ; countdown timer on/off flag
oldkb:      dd 0                        ; old keyboard interrupt vector
input_buf:  times 6 db 0                ; buffer for user input
prompt:     db 'Enter seconds (1-3599): $' ; input prompt

;---------------------------------------;

clrscr:
    pusha
    push es
    mov ax, 0xB800
    mov es, ax
    xor di, di
    mov ax, 0x0720      ; space with attribute 07
    mov cx, 2000
    cld
    rep stosw
    pop es
    popa
    ret

;---------------------------------------;

printLayout:
    pusha
    push es
    mov ax, 0xB800
    mov es, ax
    
    ; Print "COUNTDOWN TIMER" title
    mov di, 260
    mov byte[es:di], 'C'
    mov byte[es:di+2], 'O'
    mov byte[es:di+4], 'U'
    mov byte[es:di+6], 'N'
    mov byte[es:di+8], 'T'
    mov byte[es:di+10], 'D'
    mov byte[es:di+12], 'O'
    mov byte[es:di+14], 'W'
    mov byte[es:di+16], 'N'
    mov byte[es:di+18], ' '
    mov byte[es:di+20], 'T'
    mov byte[es:di+22], 'I'
    mov byte[es:di+24], 'M'
    mov byte[es:di+26], 'E'
    mov byte[es:di+28], 'R'
	mov byte[es:di+30], ' '
	mov byte[es:di+32], '3'
	mov byte[es:di+34], '.'
	mov byte[es:di+36], '8'
	mov byte[es:di+38], '.'
	mov byte[es:di+40], '2'
    
    ; Print time labels
    mov di, 420
    mov byte[es:di], 'H'
    mov byte[es:di+2], 'R'
    mov byte[es:di+4], 'S'
    mov byte[es:di+8], ':'
    mov byte[es:di+12], 'M'
    mov byte[es:di+14], 'I'
    mov byte[es:di+16], 'N'
    mov byte[es:di+20], ':'
    mov byte[es:di+24], 'S'
    mov byte[es:di+26], 'E'
    mov byte[es:di+28], 'C'
    mov byte[es:di+32], ':'
    mov byte[es:di+36], 'M'
    mov byte[es:di+38], 'L'
    mov byte[es:di+40], 'S'
    
    pop es
    popa
    ret

;---------------------------------------;

printstr:
    push bp
    mov bp, sp
    pusha
    push es
    
    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]      ; video mem offset
    mov ax, [bp+6]      ; number to print
    
    mov bx, 10
    mov cx, 0
    
nextdigit:
    mov dx, 0
    div bx
    add dl, 0x30        ; convert to ASCII
    push dx
    inc cx
    cmp ax, 0
    jnz nextdigit
    
    cmp cx, 1
    jnz nextpos
    mov byte [es:di], '0'
    add di, 2
    
nextpos:
    pop dx
    mov dh, 0x07        ; attribute
    mov [es:di], dx
    add di, 2
    loop nextpos
    
    pop es
    popa
    pop bp
    ret 4

;---------------------------------------;

printTime:
    push bp
    mov bp, sp
    pusha
    push es
    
    mov ax, 0xB800
    mov es, ax
    mov di, [bp+4]      ; video mem offset
    
    ; print hours
    push word [bp+6]    ; hours
    add di, 2
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print minutes
    push word [bp+8]    ; minutes
    add di, 4
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print seconds
    push word [bp+10]   ; seconds
    add di, 4
    push di
    call printstr
    
    ; print colon
    add di, 8
    mov byte [es:di], ':'
    
    ; print milliseconds
    push word [bp+12]   ; milliseconds
    add di, 4
    push di
    call printstr
    
    pop es
    popa
    pop bp
    ret 10

;---------------------------------------;


kbisr:
    push ax
    in al, 0x60         ; read keyboard scan code

    ; Check for 'C' key (scan code 0x2E when released)
    cmp al, 174        ; 0xAE - 0x80 = 0x2E 0x9C 174
    jne oldKbHandler
    
    ; Don't allow starting if timer is already at 0
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz EOI1             ; if all zero, don't allow starting
    
    ; Toggle countdown timer
    cmp byte [cs:cdt], 1
    je cdt_stop
    
    ; Start countdown
    mov byte [cs:cdt], 1
    jmp EOI1
	   

cdt_stop:
    ; Stop countdown
    mov byte [cs:cdt], 0
    
EOI1:
    mov al, 0x20
    out 0x20, al        ; send EOI to PIC
    pop ax
    iret
    
oldKbHandler:
    pop ax
    jmp far [cs:oldkb]  ; jump to original ISR

;---------------------------------------;

countdownTimer:
    pusha
    push es
    
    call printLayout
    
    ; Print current countdown time
    push word [cs:cms]
    push word [cs:csec]
    push word [cs:cmin]
    push word [cs:chrs]
    push 738           ; video mem offset for display !!!738=perfect
    call printTime
    
    ; Only update if countdown is active
    cmp byte [cs:cdt], 1
    jne timerEOI
    
    ; Check if we've already reached zero
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz timerStopped     ; if all zero, stop the timer
    
    ; Decrement milliseconds
    mov ax, [cs:cms]
    sub ax, 55
    cmp ax, 0
    jge update_ms
    
    ; Adjust if milliseconds went negative
    add ax, 1000
    dec word [cs:csec]
    
update_ms:
    mov [cs:cms], ax
    
    ; Check if seconds need adjustment
    cmp word [cs:csec], 0
    jge check_minutes
    
    ; Adjust seconds
    add word [cs:csec], 60
    dec word [cs:cmin]
    
check_minutes:
    cmp word [cs:cmin], 0
    jge check_hours
    
    ; Adjust minutes
    add word [cs:cmin], 60
    dec word [cs:chrs]
    
check_hours:
    cmp word [cs:chrs], 0
    jge timerEOI
    
    ; This should never happen as we check for zero above
    mov word [cs:chrs], 0
    
    ; Check if countdown reached zero
    mov ax, [cs:chrs]
    or ax, [cs:cmin]
    or ax, [cs:csec]
    or ax, [cs:cms]
    jz timerEOI
    
timerStopped:
    ; Countdown finished - stop timer
    mov byte [cs:cdt], 0
    
    ; Ensure all values are zero
    mov word [cs:chrs], 0
    mov word [cs:cmin], 0
    mov word [cs:csec], 0
    mov word [cs:cms], 0
    
timerEOI:
    mov al, 0x20
    out 0x20, al        ; send EOI to PIC
    pop es
    popa
	
    iret

;---------------------------------------;

get_input:
    ; Display prompt
    mov ah, 09h
    mov dx, prompt
    int 21h
    
    ; Read user input
    mov ah, 0ah
    mov dx, input_buf
    mov byte [input_buf], 5      ; max 5 characters to read
    int 21h
    
    ; Convert ASCII to number
    mov si, input_buf + 2        ; point to first digit
    xor ax, ax                   ; clear ax for result
    mov cx, 10                   ; multiplier
    
convert_loop:
    mov bl, [si]
    cmp bl, 0dh                  ; check for carriage return
    je convert_done
    sub bl, '0'                  ; convert ASCII to digit
    mul cx                       ; ax = ax * 10
    add ax, bx                   ; add new digit
    inc si
    jmp convert_loop
    
convert_done:
    ; Validate input (1-3599 seconds)
    cmp ax, 1
    jl invalid_input
    cmp ax, 3599
    jg invalid_input
    
    ; Store seconds
    mov [cs:csec], ax
    
    ; Convert seconds to hours:minutes:seconds
    xor dx, dx
    mov bx, 60
    div bx                      ; ax = minutes, dx = seconds
    mov [cs:csec], dx
    
    xor dx, dx
    div bx                      ; ax = hours, dx = minutes
    mov [cs:cmin], dx
    mov [cs:chrs], ax
    
    ret
    
invalid_input:
    ; Clear input buffer
    mov byte [input_buf+2], 0
    
    ; Print error message
    mov ah, 09h
    mov dx, invalid_msg
    int 21h
    
    ; Wait for key press
    mov ah, 0
    int 16h
    
    ; Try again
    call clrscr
    jmp get_input

invalid_msg db 0dh, 0ah, 'Invalid input! Must be 1-3599 seconds.', 0dh, 0ah, '$'

;---------------------------------------;

start:
    ; Initialize screen
    call clrscr
    
    ; Get user input for countdown time
    call get_input
    
    ; Clear screen again after input
    call clrscr
    
    ; Save old keyboard interrupt vector
    xor ax, ax
    mov es, ax
    mov ax, [es:9*4]
    mov [oldkb], ax
    mov ax, [es:9*4+2]
    mov [oldkb+2], ax
    
    ; Initialize countdown timer values (already set by get_input)
    mov word [cs:cms], 0
    mov byte [cs:cdt], 0     ; initially stopped
    
    ; Install new interrupt handlers
    cli
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    mov word [es:8*4], countdownTimer
    mov [es:8*4+2], cs
    sti
    
    ; Terminate and stay resident
    mov dx, start + 15
    mov cl, 4
    shr dx, cl
    mov ax, 0x3100
    int 0x21
```