; tictac.asm
    org 0x0100

board:  equ 0x0300

start:
    mov bx,board        ; put address of game board in BX
    mov cx,9            ; count 9 squares
    mov al,'1'          ; setup AL to contain 0x31 (ASCII code for '1')

b09:
    ; initialize the board
    mov [bx],al         ; save it into the square (one byte)
    inc al              ; increase AL, this gives us the next digit
    inc bx              ; increase direction
    loop b09            ; decrement CX, jump if non-zero

b10:
    call show_board
    call find_line
    call get_movement   ; get movement
    mov byte [bx],'X'   ; put X into square
    ; call tie_check

    call show_board     ; show board
    call find_line
    call get_movement   ; get movement
    mov byte [bx],'0'   ; put 0 into square

    ; call tie_check
    jmp b10

get_movement:
    call read_keyboard
    cmp al,0x1b         ; Esc key pressed?
    je do_exit          ; yes, exit
    sub al,0x31         ; subtract code for ASCII digit 1
    jc get_movement     ; value under 0x31 (CF is set)?
    cmp al,0x09         ; comparison with 9
    jnc get_movement    ; CF is set if value is less than 0x09
    cbw                 ; expand AL to 16 bits using AH (= AX)
    mov bx,board        ; BX points to board
    add bx,ax           ; add the key entered (= board + AX)
    mov al,[bx]         ; get square content
    cmp al,0x40         ; comparison with 0x40 (no X or O at the position)
    jnc get_movement    ; is it greater than or equal to? wait for another key
    call show_crlf      ; line change
    ret                 ; return, now BX points to square

do_exit:
    int 0x20            ; exit to command line

show_board:
    mov bx,board
    call show_row
    call show_div
    mov bx,board+3
    call show_row
    call show_div
    mov bx,board+6
    jmp show_row

show_row:
    call show_square
    mov al,0xb3
    call display_letter
    call show_square
    mov al,0xb3
    call display_letter
    call show_square

show_crlf:
    mov al,0x0d
    call display_letter
    mov al,0x0a
    jmp display_letter

show_div:
    mov al,0xc4
    call display_letter
    mov al,0xc5
    call display_letter
    mov al,0xc4
    call display_letter
    mov al,0xc5
    call display_letter
    mov al,0xc4
    call display_letter
    jmp show_crlf

show_square:
    mov al,[bx]
    inc bx
    jmp display_letter

find_line:
    ; first horizontal row
    mov al,[board]      ; X.. ... ... (= index of board)
    cmp al,[board+1]    ; .X. ... ...
    jne b01
    cmp al,[board+2]    ; ..X ... ...
    je won

b01:
    ; leftmost vertical row
    cmp al,[board+3]    ; ... X.. ...
    jne b04
    cmp al,[board+6]    ; ... ... X..
    je won

b04:
    ; first diagonal
    cmp al,[board+4]    ; ... .X. ...
    jne b05
    cmp al,[board+8]    ; ... ... ..X
    je won

b05:
    ; second horizontal row
    mov al,[board+3]    ; ... X.. ...
    cmp al,[board+4]    ; ... .X. ...
    jne b02
    cmp al,[board+5]    ; ... ..X ...
    je won

b02:
    ; third horizontal row
    mov al,[board+6]    ; ... ... X..
    cmp al,[board+7]    ; ... ... .X.
    jne b03
    cmp al,[board+8]    ; ... ... ..X
    je won

b03:
    ; middle vertical row
    mov al,[board+1]    ; .X. ... ...
    cmp al,[board+4]    ; ... .X. ...
    jne b06
    cmp al,[board+7]    ; ... ... .X.
    je won

b06:
    ; rightmost vertical row
    mov al,[board+2]    ; ..X ... ...
    cmp al,[board+5]    ; ... ..X ...
    jne b07
    cmp al,[board+8]    ; ... ... ..X
    je won

b07:
    ; second diagonal
    cmp al,[board+4]    ; ... .X. ...
    jne b08
    cmp al,[board+6]    ; ... ... X..
    je won

b08:
    ret

; tie_check:
;     ; loop through the board and check if we have a tie
;     mov cx,0
;     mov bx,board        ; BX points to board
; tie_loop:    
;     add bx,cx           ; add the key entered (= board + AX)
;     mov al,[bx]         ; get square content
;     cmp al,0x40         ; comparison with 0x40 (no X or O at the position)
;     call display_number
;     jnc tie_exit        ; it's still a number - exit
;     inc cx
;     cmp cx,9
;     jne tie_loop
;     ; it's a tie
;     mov al,0x74         ; t
;     call display_letter
;     mov al,0x69         ; i
;     call display_letter
;     mov al,0x65         ; e
;     call display_letter
;     int 0x20            ; return to command line
; tie_exit:
;     ret
won:
    ; at this point AL contains the letter which made the line
    call display_letter
    mov al,0x20     ; space
    call display_letter
    mov al,0x77     ; w
    call display_letter
    mov al,0x69     ; i
    call display_letter
    mov al,0x6e     ; n
    call display_letter
    mov al,0x73     ; s
    call display_letter
    int 0x20       ; return to command line

; copy/paste
display_letter:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ah,0x0e         ; load AH with code for terminal output
    mov bx,0x000f       ; load BH page zero and BL color (graphic mode)
    int 0x10            ; call the BIOS for displaying one letter
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret                 ; returns to caller

read_keyboard:
    push bx
    push cx
    push dx
    push si
    push di
    mov ah,0x00         ; load AH with code for keyboard read
    int 0x16            ; call the BIOS for reading keyboard
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    ret                 ; return to caller

display_number:
    mov dx,0        ; makes DX = 0 (init DX to 0x00)
    mov cx,10       ; makes CX = 10
    div cx          ; divide AX by CX
                    ; double word in DX and AX
                    ; word in CX
                    ; AX = DX:AX / CX
                    ; result/quotient in AX
                    ; remainder in DX
    push dx         ; save DX (put on to stack)
    cmp ax,0        ; if AX is zero...
    je display_number_1 ; ...jump
    call display_number ; else calls itself
display_number_1:
    pop ax          ; get value from stack (the new AX)
    add al,'0'      ; convert remainder to ASCII digit
    call display_letter ; display on the screen
    ret