; 3.3.2
org 0x100

section .data
    prompt db 'How many monkeys left (1-9)? $'
    msg db ' little monkeys went to eat$'
    msgEnd db 'And there were none$'
    newline db 0x0D, 0x0A, '$'
    invalid_msg db 'Invalid input! Please enter 1-9.$'
    clear_screen db 0x1B, '[2J$'  ; ANSI clear screen sequence

section .bss
    monkey_count resb 1
    current_row resb 1

section .text
start:
    ; Clear screen using ANSI
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

    ; Set cursor position for prompt
    mov ah, 0x02
    mov bh, 0
    mov dh, 10       ; Row
    mov dl, 24       ; Column
    int 0x10

    ; Print prompt (light cyan)
    mov bl, 0x0B     ; Light cyan
    mov si, prompt
    mov cx, 28       ; Length of prompt
    call print_colored

    ; Read input
    mov ah, 0x01
    int 0x21
    sub al, '0'

    ; Validate input
    cmp al, 1
    jb invalid_input
    cmp al, 9
    ja invalid_input

    mov [monkey_count], al
    mov byte [current_row], 5  ; Start printing monkeys at row 5

    ; Clear screen again for output
    mov dx, clear_screen
    mov ah, 0x09
    int 0x21

monkey_loop:
    mov al, [monkey_count]
    cmp al, 0
    je no_more_monkeys

    ; Set cursor position for number
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Current row
    mov dl, 30             ; Fixed column for number
    int 0x10

    ; Print count (light red)
    mov ah, 0x0E
    mov bh, 0
    mov bl, 0x0C     ; Light red
    add al, '0'
    int 0x10
    sub al, '0'

    ; Set cursor position for message (same row, next column)
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Same row
    mov dl, 32             ; Column after number
    int 0x10

    ; Print message (light green)
    mov bl, 0x0A     ; Light green
    mov si, msg
    mov cx, 26       ; Length of msg
    call print_colored

    ; Move to next row
    inc byte [current_row]
    dec byte [monkey_count]
    jmp monkey_loop

no_more_monkeys:
    ; Set cursor position for ending message
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Next available row
    mov dl, 30             ; Centered column
    int 0x10

    ; Print ending message (yellow)
    mov bl, 0x0E     ; Yellow
    mov si, msgEnd
    mov cx, 17       ; Length of msgEnd
    call print_colored

    ; Wait for keypress before exiting
    mov ah, 0x00
    int 0x16
	
	; Set cursor position for message (same row, next column)
    mov ah, 0x02
    mov bh, 0
    mov dh, [current_row]  ; Same row
	inc dh						; not same ~ +1
    mov dl, 0             ; Column after number
    int 0x10
	
    ; Exit
    mov ax, 0x4C00
    int 0x21

invalid_input:
    ; Set cursor position for error message
    mov ah, 0x02
    mov bh, 0
    mov dh, 12       ; Row
    mov dl, 22       ; Column
    int 0x10

    ; Print error message (light red)
    mov bl, 0x0C     ; Light red
    mov si, invalid_msg
    mov cx, 34       ; Length of invalid_msg
    call print_colored

    ; Wait 2 seconds
    mov cx, 0x001E
    mov dx, 0x8480
    mov ah, 0x86
    int 0x15

    jmp start

print_colored:
    ; BIOS function to print colored string
    ; Input: SI=string, CX=length, BL=color
    pusha
    mov ah, 0x09     ; Write character and attribute
    mov bh, 0        ; Page number
.print_char:
    lodsb            ; Load next character
    cmp al, '$'      ; Check for end of string
    je .done
    mov cx, 1        ; Print one character
    int 0x10
    
    ; Move cursor forward
    mov ah, 0x03     ; Get cursor position
    int 0x10
    inc dl           ; Next column
    mov ah, 0x02     ; Set cursor position
    int 0x10
    
    mov ah, 0x09     ; Restore function
    jmp .print_char
.done:
    popa
    ret