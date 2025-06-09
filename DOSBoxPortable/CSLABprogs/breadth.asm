; Chap3 3.4.5 input = breadth of line UPDATE: 200~
org 0x100

section .data
    breadth db 0
    msg db 'Enter a number (0-200): $'
    err_msg db 0Dh, 0Ah, 'Invalid input! Please enter a number between 0 and 200.$', 0Dh, 0Ah, '$'

section .text

start:
    ; Print message to prompt user
    mov ah, 09h
    mov dx, msg
    int 21h

    ; Read input
    call read_input

    ; BIOS graph mode
    mov ah, 00h
    mov al, 13h
    int 10h

    ; Draw
    call draw

    ; Wait for a key press
    mov ah, 00h
    int 16h

    ; Return to text mode
    mov ah, 00h
    mov al, 03h
    int 10h

    ; End program
    mov ax, 4C00h
    int 21h

read_input:
    mov cx, 0          ; Counter for digits
    xor bx, bx         ; Clear bx to store the number

read_digit:
    mov ah, 01h        ; Function to read character
    int 21h            ; Read character
    cmp al, 13         ; Check for Enter key (carriage return)
    je finish_input    ; If Enter is pressed, finish input
    cmp al, '0'        ; Check if it's a valid digit
    jb invalid_input   ; If less than '0', jump to invalid input
    cmp al, '9'        ; Check if it's a valid digit
    ja invalid_input   ; If greater than '9', jump to invalid input
    
    ; Convert ASCII to integer and accumulate
    sub al, '0'
    mov ah, 0
    xchg ax, bx        ; Swap ax and bx
    mov dx, 10         ; Prepare to multiply by 10
    mul dx             ; Multiply bx by 10 (result in ax)
    add bx, ax         ; Add the new digit
    jc invalid_input   ; If carry, number is too big
    
    inc cx             ; Increment digit counter
    cmp cx, 3          ; Check if we have 3 digits
    jb read_digit      ; If less than 3, read another digit

finish_input:
    ; Validate range (0-255) ::200
    cmp bx, 200
    ja invalid_input
    
    ; Store the result in breadth
    mov [breadth], bl  ; Store the valid input
    ret

invalid_input:
    ; Print error message
    mov ah, 09h
    mov dx, err_msg
    int 21h
    jmp start          ; Restart input process

draw:
    mov cx, 0          ; X coordinate
    mov dx, 0          ; Y coordinate
    mov al, 04h        ; Color (red)

draw_loop:
    mov ah, 0Ch        ; Function to set pixel
    xor bh, bh         ; Page 0
    int 10h            ; Set pixel at (cx, dx)

    inc cx             ; Increment X coordinate
    cmp cx, 320        ; Check screen width
    jb draw_loop       ; Continue if not reached end
    
    mov cx, 0          ; Reset X coordinate
    inc dx             ; Move to next row
    cmp dl, [breadth]  ; Compare with breadth (unsigned)
    jb draw_loop       ; Continue if not reached breadth

    ret