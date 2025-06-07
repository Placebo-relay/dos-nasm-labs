[org 0x0100]

jmp start

;---------------------------------------;

hrs:        dw 0                        ; split mode data
min:        dw 0                        ;
s:          dw 0                        ;
ms:         dw 0                        ;

lhrs:       dw 0                        ; lap mode data
lmin:       dw 0                        ;
ls:         dw 0                        ;
lms:        dw 0                        ;

oldkb:      dd 0                        ; old vector

sMode:      db 0                        ; split mode
lMode:      db 0                        ; lap mode

startTimer: db 0                        ; timer on/off
snapshot:   db 0                        ; capture time
lapTime:    db 0                        ; lapTime on/off

location:   db 6                        ; display data starting from line 6

      ; *** countdown timer code
      ; hardcoded values
      ; add own procedure if you want
      ; to take data from a user

chrs:       dw 0                        ; countdown timer data
cmin:       dw 3                        ;
csec:       dw 0                        ;
cms:        dw 0                        ;

cdt:        db 0                        ; countdown timer on/off

;---------------------------------------;

clrscr:
      pusha                             ;
      push es                           ;

      mov ax, 0xB800                    ; ax = B800
      mov es, ax                        ; es = B800
      xor di, di                        ; di = 0000
      mov ax, 0x720                     ; ax = 0720, ' ' + attrib 0x07
      mov cx, 2000                      ; cx = 2000

      cld                               ; clear DF, add di,2
      rep stosw                         ; es:di = ax

      pop es                            ;
      popa                              ;

      ret                               ;

;---------------------------------------;

printLayout:
      pusha                             ;
      push es                           ;

      mov ax, 0xB800                    ; ax = B800
      mov es, ax                        ; es = B800

      mov di, 174                       ; di = 0xAE

      mov byte[es:di+0], ' '            ; write to video mem
      mov byte[es:di+2], 'H'            ;
      mov byte[es:di+4], 'R'            ;
      mov byte[es:di+6], 'S'            ;

      mov byte[es:di+10], ':'           ;

      mov byte[es:di+14], 'M'           ;
      mov byte[es:di+16], 'I'           ;
      mov byte[es:di+18], 'N'           ;

      mov byte[es:di+22], ':'           ;

      mov byte[es:di+26], 'S'           ;
      mov byte[es:di+28], 'E'           ;
      mov byte[es:di+30], 'C'           ;

      mov byte[es:di+34], ':'           ;

      mov byte[es:di+38], 'M'           ;
      mov byte[es:di+40], 'L'           ;
      mov byte[es:di+42], 'S'           ;

      ; *** countdown timer code

      mov di, 260                       ;
      mov byte[es:di], 'C'              ;
      mov byte[es:di+2], 'O'            ;
      mov byte[es:di+4], 'U'            ;
      mov byte[es:di+6], 'N'            ;
      mov byte[es:di+8], 'T'            ;
      mov byte[es:di+10], 'D'           ;
      mov byte[es:di+12], 'O'           ;
      mov byte[es:di+14], 'W'           ;
      mov byte[es:di+16], 'N'           ;
      mov byte[es:di+18], ' '           ;
      mov byte[es:di+20], 'T'           ;
      mov byte[es:di+22], 'I'           ;
      mov byte[es:di+24], 'M'           ;
      mov byte[es:di+26], 'E'           ;
      mov byte[es:di+28], 'R'           ;

      pop es                            ;
      popa                              ;

      ret                               ;

;---------------------------------------;

kbisr:                                  ; new keyboard interrupt, stay resident
      push ax                           ;

      in  al, 0x60                      ; read from port 0x60, output buffer

      cmp al, 147                       ; 'r' key, reset timer , 0x93 - 0x80 = 0x13
      jz  reset                         ; reset timer

      ; *** countdown timer code

      cmp al, 174                       ; 'c' key, reset countdown timer, 0xAE - 0x80 = 0x2E
      jz countdown

      jnz modChanger                    ; change mode, split/lap

      ; *** countdown timer code

countdown:

;      cmp byte [cs:cdt], 2             ; cdt already reached zero?
;      jz cdt_reset

      cmp byte[cs:cdt], 1               ; is cdt activated?
      jz cdt_stop

      inc byte[cs:cdt]                  ; start cdt
      jmp EOI1                          ; end of interrupt 1

cdt_stop:
      dec byte [cs:cdt]                 ; stop cdt
      jmp EOI1                          ;

;cdt_reset:
;      dec byte [cs:cdt]
;      jmp EOI1

reset:
      mov word [cs:hrs], 0              ;
      mov word [cs:min], 0              ;
      mov word [cs:s], 0                ;
      mov word [cs:ms], 0               ;

      ; reset the lap time

      mov word [cs:lhrs], 0             ;
      mov word [cs:lmin], 0             ;
      mov word [cs:ls], 0               ;
      mov word [cs:lms], 0              ;

      call clrscr                       ; clear screen

      mov byte [cs:location], 6         ; line 6 , show split/lap time on this line if spacebar is hit

      jmp EOI1                          ; end of interrupt 1

modChanger:                             ; switch between lap and split mode
      cmp al, 170                       ; left shift, 0xaa - 0x80 = 0x2a
      jnz checkLMode1                   ; activate lap mode
                                        ; activate split mode
      mov byte [cs:lMode], 0            ; lap mode = 0, deactivate lap mode

      cmp byte [cs:sMode], 1            ; if split mode = 1, already active?
      jz EOI1                           ; end of interrupt 1

      mov byte [cs:sMode], 1            ; else activate split mode = 1
      jmp EOI1                          ;

checkLMode1:                            ; lap mode
      cmp al, 182                       ; right shift, 0xb6 - 0x80 = 0x36
      jnz startTime                     ; start timer

      mov byte [cs:sMode], 0            ; split mode = 0

      cmp byte [cs:lMode], 1            ; if lap mode = 1, already active?
      jz  EOI1                          ; end of interrupt 1

      mov byte [cs:lMode], 1            ; lap mode = 1
      jmp EOI1

;---------------------------------------;

startTime:
      cmp al, 185                       ; space bar, 0xB9 - 0x80 = 0x39
      jnz oldKbHandler                  ; no, use old keyboard procedure
                                        ; yes, start the timer
      cmp byte [cs:startTimer], 1       ; is the timer activated?
      jz  check0                        ; yes
                                        ; no
      mov byte [cs:startTimer], 1       ; turn the timer on

check0:
      cmp byte [cs:sMode], 1            ; if split mode = 1
      jnz check1                        ; no
                                        ; yes
      mov byte [cs:snapshot], 1         ; snapshot = 1, total time from start
      jmp EOI1                          ; end of interrupt 1

check1:
      cmp byte [cs:lMode], 1            ; if lap mode = 1
      jnz EOI1

      mov byte [cs:lapTime], 1          ; lapTime = 1,  each lap time
      jmp EOI1

EOI1:
      mov al, 0x20                      ; send the signal to the 8259A controller
      out 0x20,al                       ; end of the interrupt

      pop ax                            ;
      iret                              ;

oldKbHandler:
      pop ax                            ;
      jmp far [cs:oldkb]                ; old keyboard handler code

;---------------------------------------;
;---------------------------------------;

printstr:
      push bp                           ;
      mov bp, sp                        ;

      pusha                             ;
      push es                           ;

      mov ax, 0xb800                    ; ax = b800
      mov es, ax                        ; es = b800

      mov di, [bp+4]                    ; di = 482, video mem offset
      mov ax, [bp+6]                    ; ax = hrs

      mov bx, 10                        ; bx = 000a
      mov cx, 0                         ; cx = 0000

nextdigit:
      mov dx, 0                         ; dx = 0000
      div bx                            ; dx:ax = 0000:hrs
      add dl, 0x30                      ; ascii digit
      push dx                           ;
      inc cx                            ; cx = 0001
      cmp ax, 0                         ;
      jnz nextdigit                     ;

      cmp cx, 1                         ;
      jnz nextpos

      mov byte [es:di], '0'             ; print '0' at curret position
      add di, 2                         ; next position

nextpos:
      pop dx
      mov dh, 0x07                      ; color
      mov [es:di], dx                   ;
      add di, 2                         ;
      loop nextpos                      ;

      pop es                            ;
      popa                              ;
      pop bp                            ;

      ret 4                             ;

;---------------------------------------;

printTime:
      push bp                           ;
      mov bp, sp                        ;

      pusha                             ;
      push es                           ;

      mov ax, 0xB800                    ; ax = b800
      mov es, ax                        ; es = b800

      mov di, [bp+4]                    ; di = 490

      ; print hours

      push word [bp+6]                  ; [bp+6] = hrs
      add di, 2                         ; di = 492
      push di                           ;
      call printstr                     ;

      ; print colon

      add di, 8                         ; di = 500
      mov byte [es:di], ':'             ;

      ; print minutes

      push word [bp+8]                  ; [bp+8] = mins
      add di, 4                         ; di = 504
      push di                           ;
      call printstr                     ;

      ; print colon

      add di, 8                         ; di = 512
      mov byte [es:di], ':'             ;

      ; print seconds

      push word [bp+10]                 ; [bp+10] = secs
      add di, 4                         ; di = 516
      push di                           ;
      call printstr                     ;

      ; print colon
      add di, 8                         ; di = 524
      mov byte [es:di], ':'             ;

      ; print miliseconds

      push word [bp+12]                 ; [bp+12] = milisecs
      add di, 4                         ; di = 528
      push di                           ;
      call printstr                     ;

      pop es                            ;

      popa                              ;
      pop bp                            ;
      ret 10                            ;

;---------------------------------------;

stopWatch:
      pusha
      push es

      call printLayout                  ; print " HRS : MIN : SEC : MLS "
                                        ; print " COUNTDOWN TIMER"

      ; print starting data
      ; save on the stack

      push word [cs:ms]                 ; miliseconds
      push word [cs:s]                  ; seconds
      push word [cs:min]                ; minutes
      push word [cs:hrs]                ; hours

      push 494                          ; video mem offset, line 3
      call printTime                    ;

      ;cmp byte [cs:startTimer], 1
      ;jnz dEOI                         ; end of interrupt

      ;*** countdown timer code

      push word [cs:cms]                ; miliseconds
      push word [cs:csec]               ; seconds
      push word [cs:cmin]               ; minutes
      push word [cs:chrs]               ; hours

      push 578                          ; video mem offset, line 3
      call printTime                    ;

      cmp byte [cs:startTimer], 1       ; is the timer activated?
      jnz dEOI                          ; no, end of interrupt

cdtimer:
      pusha

      cmp byte [cs:cdt], 1              ; is cdt active?
      jnz cdt_deactivated               ;

      mov ax, [cs:cms]                  ;
      mov bx, [cs:csec]                 ;
      mov cx, [cs:cmin]                 ;
      mov dx, [cs:chrs]                 ;

      sub ax, 55                        ;
      cmp ax, 0                         ;
      jge cdt_secs                      ; if ms = [0 - 999]
                                        ; < 0, dec secs, adjust ms
      xor si,si                         ; check if cdt reached zero
      add si,dx                         ;
      add si,cx                         ;
      add si,bx                         ;

      cmp si,0                          ;
      jz cdt_zero                       ; countdown finished

      add ax, 1000                      ; adjust ms
      sub bx, 1                         ; dec secs

cdt_secs:
      mov [cs:cms], ax                  ; ms after calculation

      cmp bx, 0
      jge cdt_mins                      ; if sec = [0 - 59]
                                        ; < 0, dec mins, adjust secs
      add bx, 60                        ;
      sub cx, 1                         ;

cdt_mins:
      mov [cs:csec], bx                 ; secs after calculation

      cmp cx, 0                         ;
      jge cdt_hrs                       ; if mins = [0 - 59]
                                        ; < 0, dec hrs, adjust mins
      add cx, 60                        ;
      sub dx, 1                         ;

cdt_hrs:
      mov [cs:cmin], cx                 ; mins after calculations

      cmp dx, 0                         ;
      jge cdt_done                      ; if hrs = [0 - 23]
                                        ; < 0, adjust hrs
      add dx, 24                        ; x

cdt_done:
      mov [cs:chrs], dx                  ; hrs after calculation
      jmp cdt_deactivated

cdt_zero:
      mov byte [cs:cms], 0              ; all done, restart cdt
      mov byte [cs:csec], 0             ;
      mov byte [cs:cmin], 3             ;
      mov byte [cs:chrs], 0             ;
      mov byte [cs:cdt], 0              ; stop cdt
 

cdt_deactivated:
      popa

;---------------------------------------;

changeTime:
      add word [cs:ms], 55              ; add 55 miliseconds
      cmp word [cs:ms], 1000            ; if 1000 miliseconds
      jle modCheck                      ;

      mov word [cs:ms], 0               ; reset miliseconds
      inc word [cs:s]                   ; +1 second
      cmp word [cs:s], 60               ; if 60 seconds
      jnz modCheck                      ;

      mov word [cs:s], 0                ; reset seconds
      inc word [cs:min]                 ; +1 minute
      cmp word [cs:min], 60             ; if 60 minutes
      jnz modCheck                      ;

      mov word [cs:min], 0              ; reset minutes
      inc word[cs:hrs]                  ; +1 hour

      jmp modCheck                      ;

modCheck:
      cmp byte [cs:sMode], 1            ; split mode
      jz splitMode

      cmp byte [cs:lMode], 1            ; lap mode
      jz  lapMode

      jmp EOI

dEOI:
      jmp EOI

;---------------------------------------;
;---------------------------------------;

splitMode:
      cmp byte [cs:snapshot], 1         ; is snapshot on?
      jnz eEOI                          ;

      mov byte [cs:snapshot], 0         ; deactivate snapshot

      push word [cs:ms]                 ; save on the stack
      push word [cs:s]                  ;
      push word [cs:min]                ;
      push word [cs:hrs]                ;

      ; position calculation

      mov al, 80                        ; calculate new cursor position
      mul byte [cs:location]            ;
      shl ax, 1                         ;
      add ax, 4                         ;

      mov si,0xb800                     ;
      mov es,si                         ;

      mov si, ax                        ; split mode id location
      mov byte [es:si], 'S'             ; split mode id
      add ax,10                         ;

      add byte [cs:location], 2         ; new line number

      push ax                           ;
      call printTime                    ;

eEOI:
      jmp EOI

;eEOI:  jmp EOI
;---------------------------------------;
;---------------------------------------;

lapMode:
      cmp byte [cs:lapTime], 1          ; is lap time activated?
      jnz xEOI                          ; no, end of interrupt
                                        ; yes
      mov byte [cs:lapTime], 0          ; deactivate lap time

      mov ax, [cs:ms]                   ; move current values to regs
      mov bx, [cs:s]                    ;
      mov cx, [cs:min]                  ;
      mov dx, [cs:hrs]                  ;
                                        ; Test:
                                        ; 03:04:04:500 - lap 1 - same as split mode
                                        ; 06:13:00:200 - lap 2 - 03:09:55:700
                                        ;
l1:
      sub ax, [cs:lms]                  ; 500-0=500 | 200-500=-300
      cmp ax, 0                         ;
      jge l2

      add ax, 1000                      ;           | -300+1000=700 |
      dec bx                            ;           | 0-1=-1 |
      cmp bx,0                          ;
      jb secs_59                        ;

secs_59:
      mov bx,59                         ; seconds, top of the range [0-59]

l2:
      mov [cs:lms],ax                   ; 500   | 700

      sub bx, [cs:ls]                   ; 4-0=4 | 59-4=55 |
      cmp bx, 0                         ;
      jge l3                            ;

      add bx, 60                        ;
      dec cx                            ;
      cmp cx,0                          ;
      jb mins_59                        ;

mins_59:
      mov cx,59                         ;

l3:
      mov [cs:ls],bx                    ; 4 | 55 |
      jmp l4

xEOI:
      jmp EOI

l4:
      sub cx, [cs:lmin]                 ; 4-0=4 | 13-4=9 |
      cmp cx, 0                         ;
      jge l5

      add cx, 60
      dec dx
      cmp dx,0
      jb hours_59

hours_59:
      mov dx,59                         ; hours, top of the range [0-59]
l5:
      mov [cs:lmin],cx                  ; 4 | 9 |

      sub dx, [cs:lhrs]                 ; 3-0=3 | 6-3=3|
      mov [cs:lhrs],dx                  ; 3 | 3 |

      push word [cs:lms]                ; value after each lap
      push word [cs:ls]
      push word [cs:lmin]
      push word [cs:lhrs]

      ; position calculation

      mov al, 80                        ; calculate new cursor position
      mul byte [cs:location]            ;
      shl ax, 1                         ;
      add ax, 4                         ;

      mov si,0xb800                     ;
      mov es,si                         ;

      mov si, ax                        ; lap mode id location
      mov byte [es:si], 'L'             ; lap mode id
      add ax,10                         ;

      add byte [cs:location], 2         ; new line number

      push ax                           ;
      call printTime                    ;

      jmp EOI

EOI:                                    ; EOI - End of Interrupt
      mov al, 0x20                      ;
      out 0x20, al                      ;

return:
      pop es                            ;
      popa                              ;

      iret                              ;

;---------------------------------------;

start:
      mov ax, 0                         ; ax = 0000
      mov es, ax                        ; es = 0000

      mov ax, [es:9*4]                  ; int 09h, keyboard int offset
      mov [oldkb],ax                    ; ds:[oldkb] = xxxx
      mov ax, [es:9*4+2]                ; int 09h, keyboard int segment
      mov [oldkb+2], ax                 ; ds:[oldkb+2] = xxxx

      call clrscr                       ; clear screen

      cli                               ; clear IF

      mov word [es:9*4], kbisr          ; new int 09h procedure, offset
      mov [es:9*4+2], cs                ; and segment

      ; no save ? old off:seg
      mov word [es:8*4], stopWatch      ; new int 08h (timer), offset
      mov [es:8*4+2], cs                ; and segment, executed every 55 ms, 18.2 times per sec

      sti                               ; set IF

      mov dx, start                     ; dx = allocate memory,size(in bytes) = start offset
                                        ; dx = number of 16 bytes paragraphs
      add dx, 16                        ; include PSP (256 bytes = 16 paragraphs x 16 bytes)
      mov cl, 4                         ;
      shr dx, cl                        ; dx = (total bytes / 16 bytes) = paragraphs number

      mov ax, 0x3100                    ; terminate and stay resident
      int 21h                           ; DOS int