; French Flag (Tricolore) for DOSBox
org 0x100

; Set graphics mode (320x200, 256 colors)
mov ax, 0x0013
int 0x10

; Draw flag - three equal vertical stripes
mov ah, 0x0C    ; BIOS draw pixel function
mov bh, 0       ; Page number
mov dx, 30      ; Starting Y position (top of flag)

; Flag dimensions
%define FLAG_WIDTH 180
%define FLAG_HEIGHT 120
%define STRIPE_WIDTH FLAG_WIDTH/3

draw_flag:
    mov cx, 70   ; Starting X position (left of flag)

    ; Blue stripe (left)
    mov al, 0x01  ; Blue color
    call draw_stripe

    ; White stripe (middle)
    mov al, 0x0F  ; White color
    call draw_stripe

    ; Red stripe (right)
    mov al, 0x04  ; Red color
    call draw_stripe

    ; Next row
    inc dx
    cmp dx, 30+FLAG_HEIGHT
    jb draw_flag

; Wait for keypress
mov ah, 0x00
int 0x16

; Return to text mode
mov ax, 0x0003
int 0x10

ret

; Draw one vertical stripe segment
; Input: AL = color, CX = X start, DX = Y position
draw_stripe:
    push cx
    mov si, STRIPE_WIDTH
    .stripe_loop:
        int 0x10    ; Draw pixel
        inc cx
        dec si
        jnz .stripe_loop
    pop cx
    add cx, STRIPE_WIDTH  ; Move to next stripe position
    ret