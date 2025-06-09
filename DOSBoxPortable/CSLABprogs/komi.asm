; Komi Flag for DOSBox (ru: w, b, r, komi: b, g, w)
org 0x100

; Set graphics mode (320x200, 256 colors)
mov ax, 0x13
int 0x10

; Draw flag - three equal horizontal stripes
mov ah, 0x0C    ; BIOS draw pixel function
mov bh, 0       ; Page number

; Flag dimensions ~~~init dx 40 then add, dx, STR_H
%define FLAG_WIDTH 180
%define FLAG_HEIGHT 120
%define STRIPE_HEIGHT FLAG_HEIGHT/3

; Blue stripe (top komi, ru middle)
mov al, 0x01    ; Blue color
mov dx, 40
call draw_horizontal_stripe

; Green stripe (mid komi)
mov al, 0x02    ; Red color
add dx, STRIPE_HEIGHT
call draw_horizontal_stripe

; White stripe (btm komi, top ru)
mov al, 0x0F    ; White color
add dx, STRIPE_HEIGHT
call draw_horizontal_stripe

; Wait for keypress
mov ah, 0x00
int 0x16

; Return to text mode
mov ax, 0x0003
int 0x10

ret

; Draw one horizontal stripe
; Input: AL = color, DX = Y position
draw_horizontal_stripe:
    pusha
    mov cx, 70       ; Starting X position
    mov di, STRIPE_HEIGHT
    
.row_loop:
    push cx
    mov si, FLAG_WIDTH
    
.pixel_loop:
    int 0x10         ; Draw pixel
    inc cx
    dec si
    jnz .pixel_loop
    
    pop cx
    inc dx
    dec di
    jnz .row_loop
    popa
    ret