org 0x100

; Инициализация видеорежима 80x25
mov ah, 00h
mov al, 03h
int 10h

; Initialize cursor position (row 4, column 40)
mov dh, 4
mov dl, 40
mov [num], byte '0'
call set_cursor

ploop:
    mov al, [num]                ; Load current number
    cmp byte [num], '9' + 1      ; Check if it exceeds '9'
    je exit                      ; If yes, exit

    ; Print the number in red
    mov ah, 09h                  ; BIOS function to print string
    mov bl, 0x02           ; Set text color to red
    mov cx, 1                    ; Number of characters to print
    int 10h                      ; Call BIOS interrupt to print

    ; Move cursor down one row
    inc dh                       ; Move cursor down one row
    inc byte [num]               ; Increment the number
    call set_cursor              ; Update cursor position

    jmp ploop                   ; Repeat the loop

exit:
    ; Move cursor to a new line after finishing
    mov dh, 5                    ; Set cursor to row 5 (or any desired row)
    mov dl, 20                   ; Set cursor to column 40
    call set_cursor              ; Update cursor position
    ret

set_cursor:
    mov ah, 02h                  ; Function to set cursor position
    int 10h                      ; Call BIOS interrupt
    ret

num db '0'                      ; Start with character '0'
