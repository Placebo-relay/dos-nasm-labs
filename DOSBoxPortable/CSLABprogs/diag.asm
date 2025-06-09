; diagonal.asm
org 100h          ; COM file format

section .text
start:
    ; Set video mode to 0x13
    mov ax, 0x13
    int 0x10

    ; Draw a diagonal line
    mov cx, 0      ; Starting x coordinate
    mov dx, 0      ; Starting y coordinate

draw_line:
    ; Calculate the pixel position
    mov bx, cx     ; x coordinate
    mov si, dx     ; y coordinate
    mov di, 320    ; Width of the screen in bytes
    mul di         ; Multiply x by 320 (width)
    add ax, bx     ; Add x to the result
    add ax, si     ; Add y to the result

    ; Set pixel color (white)
    mov es, 0xA000 ; Set ES to the video segment
    mov [es:ax], 0x0F ; Set pixel color (white)

    ; Increment coordinates
    inc cx         ; Move to the right
    inc dx         ; Move down

    ; Check if we are still within screen bounds
    cmp cx, 320    ; Check if x < 320
    jl draw_line   ; If true, continue drawing

    ; Wait for a key press
    mov ah, 0
    int 0x16

    ; Set video mode back to text mode (0x03)
    mov ax, 0x03
    int 0x10

    ; Exit program
    ret
