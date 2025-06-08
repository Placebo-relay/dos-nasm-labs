org 0x100

section .data
    prompt db 'How many monkeys left (1-9)? $'
    msg db ' little monkeys went to eat', 0x0D, 0x0A, '$'  ; $ termination
    msgEnd db 'And there were none$'
    newline db 0x0D, 0x0A, '$'

section .bss
    monkey_count resb 1

section .text
start:
    ; Print prompt
    mov dx, prompt
    mov ah, 9
    int 21h

    ; Read input
    mov ah, 01h
    int 21h
    sub al, '0'

    ; Validate input
    cmp al, 1
    jb invalid_input
    cmp al, 9
    ja invalid_input

    mov [monkey_count], al

    ; Print initial newline
    mov dx, newline
    mov ah, 09h
    int 21h

monkey_loop:
	
    mov al, [monkey_count]
    cmp al, 0
    je no_more_monkeys

    ; Print count
    call print_number

    ; Print message (now properly $ terminated)
    mov dx, msg
    mov ah, 09h
    int 21h

    dec byte [monkey_count]
    jmp monkey_loop

no_more_monkeys:
    ; Print ending message (with built-in newline)
    mov dx, msgEnd
    mov ah, 09h
    int 21h
	
	; Print newline
    mov dx, newline
    mov ah, 09h
    int 21h
	
    ; Exit
    mov ah, 4Ch
    int 21h

invalid_input:
    mov dx, newline
    mov ah, 09h
    int 21h
    jmp start

print_number:
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    ret