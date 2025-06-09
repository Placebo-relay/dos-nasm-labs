org 0x100

; Set video mode to 320x200 256-color
mov ah, 00h
mov al, 13h
int 10h

; Draw the square
call draw_square

; Wait for a key press
mov ah, 00h
int 16h

; Set video mode back to text mode
mov ah, 00h
mov al, 03h
int 10h

; Terminate the program
mov ax, 4C00h
int 21h

; Function to draw a square
draw_square:
    mov cx, 135   ; Starting X position
    mov dx, 125   ; Starting Y position
    
; Draw the top side of the square
draw_top_side:
    mov ah, 0Ch
    mov al, 0Ah  ; Color: green
    int 10h
	
	dec dx
    cmp dx, 75   
    jne draw_top_side

; Draw the right side of the square
draw_right_side:
    mov ah, 0Ch
    mov al, 0Ah  ; Color: green
    int 10h
	
	inc cx
    cmp cx, 185   
    jne draw_right_side      

; Draw the bottom side of the square
draw_bottom_side:
    mov ah, 0Ch
    mov al, 0Ah  ; Color: green
    int 10h
	
	inc dx
    cmp dx, 125   
    jne draw_bottom_side

; Draw the left side of the square
draw_left_side:
    mov ah, 0Ch
    mov al, 0Ah  ; Color: green
    int 10h
	
	dec cx
    cmp cx, 135   
    jne draw_left_side
	
	ret
