; guess.asm
; guess a number between 0 and 7
    org 0x0100

    in al,(0x40)        ; read the time counter chip
    and al,0x07         ; mask bits so the value becomes 0-7
    add al,0x30         ; convert into ASCII digit
    mov cl,al           ; save AL into CL
    call display_letter ; (optional) this line gives the answer

game_loop:
    mov al,'?'          ; AL now is question-mark sign
    call display_letter ; display
    call read_keyboard  ; read keyboard
    cmp al,cl           ; AL equals CL?
    jne game_loop       ; no, jumps (jump if not equal)
    call display_letter ; display number
    mov al,' '
    call display_letter
    mov al,':'          ; display happy face
    call display_letter
    mov al,'-'
    call display_letter
    mov al,')'
    call display_letter

; copy/paste from library1.asm
    int 0x20            ; exit to command line.
;
; display letter contained in AL (ASCII code)
;
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

;
; read keyboard into AL (ASCII code)
;
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