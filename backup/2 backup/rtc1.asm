org 0x100

start:
    ; Initialize RTC to BCD format
    mov al, 0x0b ; Control register RTC
    out 0x70, al ; Select this register for reading, port 0x70

    in al, 0x71 ; Read the value of the register
    and al, 0b11111011 ; Clear the second bit to set BCD format
    out 0x71, al ; Send updated settings to RTC

main_loop:
    ; Clear the screen
    call clear_screen

    ; Fetch and display the current time
    call display_time

    ; Wait for approximately one second
    call delay_one_second

    ; Check for key press (non-blocking)
    call check_key_press
    jnz exit_program ; Exit if a key is pressed

    jmp main_loop ; Repeat the loop

display_time:
    ; Get current time from RTC
    mov al, 0x04 ; Current hour
    call print_rtc

    mov al, ':' ; Separator
    call print_char

    mov al, 0x02 ; Current minute
    call print_rtc

    mov al, ':' ; Separator
    call print_char

    mov al, 0x00 ; Current second
    call print_rtc

    ; Print a newline for better formatting
    mov al, 0x0D ; Carriage return
    call print_char
    mov al, 0x0A ; Line feed
    call print_char

    ret

print_rtc:
    out 0x70, al ; Request from RTC
    in al, 0x71 ; Get response

    push ax ; Save ax value before modification

    shr al, 4 ; Get the upper 4 bits of the response
    add al, '0' ; Adjust result for output
    call print_char ; Output the upper 4 bits

    pop ax

    and al, 0x0f ; Get the lower 4 bits
    add al, '0' ; Adjust result for output
    call print_char ; Output the lower 4 bits

    ret

print_char:
    ; Print character in AL
    mov ah, 0x0E ; BIOS teletype output
    int 0x10
    ret

clear_screen:
    ; Clear the screen (assuming 80x25 text mode)
    mov ax, 0x0600 ; Function to scroll the window up
    mov bh, 0x07   ; Attribute (light gray on black)
    mov cx, 0      ; Upper left corner (0,0)
    mov dx, 0x1840 ; Lower right corner (80x25)
    int 0x10      ; BIOS interrupt
    ret

delay_one_second:
    ; Simple delay loop for approximately one second
    mov cx, 0xFFFF
delay_loop:
    loop delay_loop
    ret

check_key_press:
    ; Check for key press (non-blocking)
    mov ah, 0x01 ; Function to check for key press
    int 0x16
    jz no_key ; If no key is pressed, jump to no_key
    mov al, 1  ; Set AL to indicate a key was pressed
    ret

no_key:
    xor al, al ; Set AL to 0 to indicate no key was pressed
    ret

exit_program:
    ; Exit the program
    mov ax, 0x4C00 ; Terminate program
    int 0x21
