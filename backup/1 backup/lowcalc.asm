org 100h

; ----- Main Program -----

; Get first number with validation
get_first_number:
    mov ah, 09h             ; Print string function
    mov dx, first_msg       ; "Input first number (0-4): "
    int 21h

    mov ah, 01h             ; Read character function
    int 21h
    
    ; Validate input
    cmp al, '0'
    jl invalid_first        ; Below '0'
    cmp al, '4'
    jg invalid_first        ; Above '4'
    
    ; Valid input - process
    sub al, '0'             ; Convert ASCII to numeric
    mov [first_num], al
    jmp get_second_number
    
invalid_first:
    ; Show error and try again
    mov ah, 09h
    mov dx, invalid_input_msg
    int 21h
    jmp get_first_number

; New line
mov ah, 02h
mov dl, 0Ah
int 21h

; Get second number with validation    
get_second_number:
    mov ah, 09h             ; Print string function
    mov dx, second_msg      ; "Input second number (0-4): "
    int 21h

    mov ah, 01h             ; Read character function
    int 21h
    
    ; Validate input
    cmp al, '0'
    jl invalid_second       ; Below '0'
    cmp al, '4'
    jg invalid_second       ; Above '4'
    
    ; Valid input - process
    sub al, '0'             ; Convert ASCII to numeric
    mov [second_num], al
    jmp show_result
    
invalid_second:
    ; Show error and try again
    mov ah, 09h
    mov dx, invalid_input_msg
    int 21h
    jmp get_second_number

; Calculate and show result    
show_result:
    ; New line
    mov ah, 02h
    mov dl, 0Ah
    int 21h

    ; Display result message
    mov ah, 09h
    mov dx, result_msg      ; "The result is: "
    int 21h

    ; Calculate sum
    mov al, [first_num]
    add al, [second_num]
    mov [result], al

    ; Display the equation (e.g., "2+3=5")
    mov ah, 02h             ; Print character function

    ; Display first number
    mov dl, [first_num]
    add dl, '0'
    int 21h

    ; Display '+' sign
    mov dl, '+'
    int 21h

    ; Display second number
    mov dl, [second_num]
    add dl, '0'
    int 21h

    ; Display '=' sign
    mov dl, '='
    int 21h

    ; Display result
    mov dl, [result]
    add dl, '0'
    int 21h
	
	; Newline
    mov ah, 9
    mov dx, newline
    int 21h
	
    ; Exit program
    mov ax, 4C00h
    int 21h

; ----- Data Section -----
first_msg         db 'Input first number (0-4): $'
second_msg        db 0Dh, 0Ah, 'Input second number (0-4): $'
result_msg        db 'The result is: $'
invalid_input_msg db 0Dh, 0Ah, 'Invalid! Must be 0-4', 0Dh, 0Ah, '$'
newline db 0Dh, 0Ah, '$'

first_num  db 0
second_num db 0
result     db 0