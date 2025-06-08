; Simple Snake eating food CONCEPT
org 0x100

; Set graphics mode
mov ax, 0x13  ; 320x200, 256 colors
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