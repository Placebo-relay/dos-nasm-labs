org 0x100

; Set video mode to 320x200 pixels with 256 colors
mov ah, 00h
mov al, 13h
int 10h

; Call the procedure to draw nested rectangles
call draw_nested_rectangles

; Wait for a key press
mov ah, 00h
int 16h

; Return to text mode (80x25)
mov ah, 00h
mov al, 03h
int 10h

ret

; Procedure to draw nested rectangles
draw_nested_rectangles:
    mov cx, 20          ; Starting X coordinate (20)
    mov dx, 20          ; Starting Y coordinate (20)

; Loop to draw rectangles in four directions
draw_rectangle_up:
    mov ah, 0Ch         ; Function to plot a pixel
    mov al, [rectangle_color] ; Set the color for the rectangle
    int 10h             ; Call BIOS interrupt to draw the pixel

    inc cx              ; Move right (increase X coordinate)
    inc byte [numS]     ; Increment the number of pixels drawn

    mov bl, [numS]      ; Load the current number of pixels drawn
    cmp bl, [rectangle_size] ; Compare with the size of the rectangle
    jne draw_rectangle_up ; If not reached, continue drawing upwards

    mov [numS], byte 0  ; Reset the number of pixels drawn
    jmp draw_rectangle_right ; Move to the next direction

draw_rectangle_right:
    mov ah, 0Ch
    mov al, [rectangle_color]
    int 10h

    inc dx              ; Move down (increase Y coordinate)
    inc byte [numS]

    mov bl, [numS]
    cmp bl, [rectangle_size]
    jne draw_rectangle_right

    mov [numS], byte 0
    jmp draw_rectangle_down ; Move to the next direction

draw_rectangle_down:
    mov ah, 0Ch
    mov al, [rectangle_color]
    int 10h

    dec cx              ; Move left (decrease X coordinate)
    inc byte [numS]

    mov bl, [numS]
    cmp bl, [rectangle_size]
    jne draw_rectangle_down

    mov [numS], byte 0
    jmp draw_rectangle_left ; Move to the next direction

draw_rectangle_left:
    mov ah, 0Ch
    mov al, [rectangle_color]
    int 10h

    dec dx              ; Move up (decrease Y coordinate)
    inc byte [numS]

    mov bl, [numS]
    cmp bl, [rectangle_size]
    jne draw_rectangle_left

    mov [numS], byte 0

    ; Decrease the size of the rectangle and adjust color
    sub [rectangle_size], byte 10
    dec byte [rectangle_color]
    add cx, 5          ; Adjust starting X coordinate for the next rectangle
    add dx, 5          ; Adjust starting Y coordinate for the next rectangle

    ; Check if the color has reached zero; if not, continue drawing
    mov bh, [rectangle_color]
    cmp bh, 0
    jg draw_rectangle_up ; If color > 0, continue drawing

    ret

; Data section
rectangle_size db 160      ; Initial size of the rectangles
numS db 0                  ; Number of pixels drawn in the current direction
rectangle_color db 15      ; Initial color of the rectangles (white)
