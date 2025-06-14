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
