org 0x100

; Set graphics mode
mov ah, 00h
mov al, 12h
int 10h

; Initialize mouse
mov ax, 0000h
int 33h

; Show mouse cursor
mov ax, 0001h
int 33h

; Set mouse event handler
mov ax, 000ch
mov cx, 0002h ; Event - left button press
mov dx, mouseHandler
int 33h

; Wait for the specified number of clicks
waitForClicks:
    mov al, [clickCount]
    cmp al, 2 ; the desired number of clicks
    jl waitForClicks

; Remove mouse event handler
mov ax, 0014h
mov cx, 0000h
int 33h

; Return to text mode
mov ah, 00h
mov al, 03h
int 10h

ret

mouseHandler:
    push ax
    mov al, 01h
    mov [mousePressed], al ; Set flag in memory
    pop ax
    inc byte [clickCount]   ; Increment click counter
    retf

mousePressed db 00h
clickCount db 0