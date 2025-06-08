org 0x100

start:
    ; Set video mode to text 80x25
    mov ax, 0x0003
    int 0x10

    ; Hide cursor
    mov ah, 0x01
    mov cx, 0x2607
    int 0x10

main_loop:
    ; Get RTC time
    mov ah, 0x02      ; BIOS get RTC time function
    int 0x1A          ; BIOS RTC interrupt
    jc .error         ; If carry flag set, error occurred

    ; Convert BCD to ASCII and display
    call display_time

    ; Check for keypress (to exit)
    mov ah, 0x01
    int 0x16
    jnz exit_program  ; Exit if any key pressed

    ; Small delay to prevent flickering
    mov cx, 0x0001
    mov dx, 0x86A0
    mov ah, 0x86
    int 0x15

    ; Clear current time display area
    mov ax, 0x0600
    mov bh, 0x07      ; White on black
    mov cx, 0x0000    ; Top-left corner
    mov dx, 0x0007    ; Bottom-right corner (just enough for time display)
    int 0x10

    ; Set cursor position to top-left
    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10

    jmp main_loop

.error:
    ; Display error message
    mov ax, 0x1301
    mov bx, 0x000C    ; Red on black
    mov cx, 10        ; Message length
    mov bp, rtc_error
    int 0x10
    jmp exit_program

display_time:
    ; Display hours
    mov al, ch        ; Hours in BCD
    call bcd_to_ascii
    mov [time_str], ax

    ; Display separator
    mov byte [time_str+2], ':'

    ; Display minutes
    mov al, cl        ; Minutes in BCD
    call bcd_to_ascii
    mov [time_str+3], ax

    ; Display separator
    mov byte [time_str+5], ':'

    ; Display seconds
    mov al, dh        ; Seconds in BCD
    call bcd_to_ascii
    mov [time_str+6], ax

    ; Display time string
    mov ax, 0x1301    ; BIOS write string function
    mov bx, 0x000F    ; White on black
    mov cx, 8         ; String length (HH:MM:SS)
    mov bp, time_str
    int 0x10
    ret

bcd_to_ascii:
    ; Convert BCD in AL to ASCII in AX
    mov ah, al        ; Copy to AH
    shr al, 4         ; Get high nibble
    and ah, 0x0F      ; Get low nibble
    add ax, 0x3030    ; Convert to ASCII
    xchg al, ah       ; Swap for correct order
    ret

exit_program:
    ; Show cursor again
    mov ah, 0x01
    mov cx, 0x0607
    int 0x10

    ; Return to DOS
    mov ax, 0x4C00
    int 0x21

section .data
    time_str db '00:00:00', 0
    rtc_error db 'RTC Error!', 0