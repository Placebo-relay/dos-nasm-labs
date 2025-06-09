org 0x100

main:
    ; Read first digit from user input
    mov ah, 01h     ; Function to read character from standard input
    int 21h         ; Call DOS interrupt
    sub al, '0'     ; Convert ASCII character to integer
    mov cl, 10      ; Set multiplier to 10
    mul cl          ; Multiply the first digit by 10
    add [stop], byte al ; Add the result to stop variable

    ; Read second digit from user input
    mov ah, 01h     ; Function to read character from standard input
    int 21h         ; Call DOS interrupt
    sub al, '0'     ; Convert ASCII character to integer
    add [stop], byte al ; Add the second digit to stop variable

    ; Print newline
    mov ah, 02h     ; Function to print character
    mov dl, 0ah     ; Newline character
    int 21h         ; Call DOS interrupt

    ; Loop until stop reaches zero
nokey:
    dec byte [stop] ; Decrement the stop variable
    mov cx, 1000    ; Set delay duration
    call delay_ms    ; Call delay function

    call s_info      ; Call function to display system time

    ; Check if stop is zero
    mov al, [stop]   ; Load stop variable into AL
    cmp al, 0        ; Compare AL with zero
    jne nokey        ; If not zero, repeat the loop

    ret              ; Return from main

; Function to display current system time
s_info:
    mov al, 0Bh      ; Select RTC register for time
    out 70h, al      ; Write to RTC index port
    in al, 71h       ; Read from RTC data port
    and al, 0b11111011 ; Clear the update flag
    out 71h, al      ; Write back to RTC data port

    ; Display day of the month
    mov al, 07h      ; Day of the month
    call print_rtc   ; Call function to print RTC value

    ; Print separator
    mov al, '-'      ; Dash character
    int 29h          ; Print character

    ; Display month
    mov al, 08h      ; Month
    call print_rtc   ; Call function to print RTC value

    ; Print separator
    mov al, '-'      ; Dash character
    int 29h          ; Print character

    ; Display year
    mov al, 32h      ; Year (high byte)
    call print_rtc   ; Call function to print RTC value
    mov al, 09h      ; Year (low byte)
    call print_rtc   ; Call function to print RTC value

    ; Print space
    mov al, ' '      ; Space character
    int 29h          ; Print character

    ; Display time
    mov al, 04h      ; Hours
    call print_rtc   ; Call function to print RTC value

    ; Print separator
    mov al, ':'      ; Colon character
    int 29h          ; Print character

    mov al, 02h      ; Minutes
    call print_rtc   ; Call function to print RTC value

    ; Print separator
    mov al, ':'      ; Colon character
    int 29h          ; Print character

    mov al, 00h      ; Seconds
    call print_rtc   ; Call function to print RTC value

    ; Print newline
    mov ah, 02h      ; Function to print character
    mov dl, 0ah      ; Newline character
    int 21h          ; Call DOS interrupt
    ret               ; Return from s_info

; Function to print RTC value
print_rtc:
    out 70h, al      ; Select RTC register
    in al, 71h       ; Read from RTC data port

    push ax          ; Save AX register
    shr al, 4        ; Shift right to get high nibble
    add al, '0'      ; Convert to ASCII
    int 29h          ; Print character

    pop ax           ; Restore AX register
    and al, 0Fh      ; Mask to get low nibble
    add al, '0'      ; Convert to ASCII
    int 29h          ; Print character

    ret               ; Return from print_rtc

; Function to create a delay in milliseconds
delay_ms:
    pusha            ; Save all general-purpose registers
    mov ax, cx       ; Move delay count to AX
    mov dx, 1000     ; Set multiplier for


delay_ms:
    pusha
    mov ax, cx
    mov dx, 1000
    mul dx               
    mov cx, dx           
    mov dx, ax           
    mov ah, 86h          
    int 15h              
    popa
    ret
	
stop db 0