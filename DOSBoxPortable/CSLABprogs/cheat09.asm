; Simple program to print a string of numbers 0->9
org 0x100

section .data
myString db '0 1 2 3 4 5 6 7 8 9$' ; String with a dollar sign terminator

section .text
start:
    mov ah, 0x09           ; Set function to print string
    mov dx, myString       ; Load address of the string into DX
    int 0x21               ; Call DOS interrupt to print the string

    ; Print carriage return and line feed
    mov dl, 0x0D           ; Carriage return (CR)
    mov ah, 0x02           ; Set function to print character
    int 0x21               ; Call DOS interrupt to print CR

    mov dl, 0x0A           ; Line feed (LF)
    int 0x21               ; Call DOS interrupt to print LF

    ; Properly terminate the program
    mov ax, 0x4C00         ; Terminate program function (lol can't use ret)
    int 0x21               ; Call DOS interrupt to terminate

