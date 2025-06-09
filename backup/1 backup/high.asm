org 0x100

start:
    ; Get first number (0-9)
    mov ah, 09h
    mov dx, prompt1
    int 21h
    call get_number
    push ax                 ; Store first number
    
    ; Get second number (0-9)
    mov ah, 09h
    mov dx, newline
    int 21h
    mov dx, prompt2
    int 21h
    call get_number
    mov bx, ax              ; Store second number in BX
    
    ; Display result message
    mov ah, 09h
    mov dx, newline
    int 21h
    mov dx, result_msg
    int 21h
    
    ; Display equation (X+Y=)
    pop ax                  ; Get first number
    push ax                 ; Keep it stored
    push bx                 ; Store second number
    
    call show_digit         ; Show first number
    mov dl, '+'
    mov ah, 02h
    int 21h
    mov ax, bx
    call show_digit         ; Show second number
    mov dl, '='
    mov ah, 02h
    int 21h
    
    ; Calculate sum
    pop bx                  ; Get second number
    pop ax                  ; Get first number
    add al, bl              ; Add them
    
    ; Convert to digits
    mov ah, 0               ; Clear upper byte
    mov bl, 10
    div bl                  ; AL=tens, AH=units
    
    ; Display result
    cmp al, 0               ; Check if two-digit
    je show_units
    push ax                 ; Save digits
    mov dl, al              ; Show tens
    add dl, '0'
    mov ah, 02h
    int 21h
    pop ax
show_units:
    mov dl, ah              ; Show units
    add dl, '0'
    mov ah, 02h
    int 21h
    
    ; Newline at end
    mov ah, 09h
    mov dx, newline
    int 21h
    
    ; Exit to DOS
    mov ax, 4C00h
    int 21h

; Get valid number 0-9
; Returns: AL = number (0-9)
get_number:
    mov ah, 01h
    int 21h
    cmp al, '0'
    jb invalid
    cmp al, '9'
    ja invalid
    sub al, '0'
    ret
invalid:
    mov ah, 09h
    mov dx, invalid_msg
    int 21h
    jmp get_number

; Display single digit (0-9)
; Input: AL = number
show_digit:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    sub al, '0'             ; Restore binary value
    ret

; Data section
prompt1      db 'Enter first number (0-9): $'
prompt2      db 'Enter second number (0-9): $'
result_msg   db 'Result: $'
invalid_msg  db 0Dh,0Ah,'Invalid! Must be 0-9',0Dh,0Ah,'$'
newline      db 0Dh,0Ah,'$'