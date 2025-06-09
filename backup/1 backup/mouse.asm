org 0x100          ; Origin for .COM file

; Set graphics mode
mov ah, 0x00       ; BIOS function to set graphics mode
mov ax, 0x0012     ; Set to 320x200 graphics mode with 256 colors
int 10h            ; Call BIOS interrupt

; Initialize mouse
mov ax, 0x0000     ; Function to initialize mouse
int 0x33           ; Call mouse interrupt

; Show mouse cursor
mov ax, 0x0001     ; Function to show mouse cursor
int 0x33           ; Call mouse interrupt

; Set mouse event handler
mov ax, 0x000c     ; Set mouse event handler function
mov cx, 0x0001     ; Event - any mouse movement
mov dx, MouseHandler ; Address of the mouse handler
int 0x33           ; Call mouse interrupt

; Wait for a key press
nokey:
mov ah, 0x01       ; Function to read keyboard
int 0x16           ; Call BIOS interrupt
jz nokey            ; Loop until a key is pressed

; Remove mouse event handler
mov ax, 0x0014     ; Function to remove mouse event handler
mov cx, 0x0000     ; No specific handler to remove
int 0x33           ; Call mouse interrupt

; Set text mode
mov ah, 0x00       ; BIOS function to set graphics mode
mov al, 0x03       ; Set to text mode 80x25, 16 colors
int 0x10           ; Call BIOS interrupt

ret                 ; Return from main program

; Mouse event handler
MouseHandler:
mov ax, 0x0003     ; Function to get mouse status
int 0x33           ; Call mouse interrupt

test bx, 0x0001    ; Check if the button is pressed
jnz .change_color   ; If pressed, change color

.further:
mov ax, 0x0002     ; Function to hide mouse cursor
int 0x33           ; Call mouse interrupt

xor bx, bx         ; Clear bx, used for video memory page
mov al, [pointer_color] ; Get color value from memory
mov ah, 0x0c       ; Function to plot a pixel
int 0x10           ; Call BIOS interrupt

mov ax, 0x0001     ; Show mouse cursor
int 0x33           ; Call mouse interrupt

retf                ; Return from mouse event handler

.change_color:
push ax             ; Save ax register
mov al, [pointer_color] ; Get color value from memory
inc al              ; Increment color number by 1
mov [pointer_color], al ; Save new color value in memory
pop ax              ; Restore ax register

jmp .further        ; Jump back to further processing

pointer_color db 1 ; Variable to store current color
