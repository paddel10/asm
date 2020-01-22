; div2.asm
    org 0x0100

divide_unsigned_word_by_a_byte:
    mov ah,0x01         ; set 0x01 in AH
    mov al,0x04         ; set 0x04 in AL
    mov cl,0x02         ; set 0x02 in CL
    div cl              ; divide 0x0104 by 2
    call display_number
    call newline

divide_byte_by_a_byte:
    mov ah,0x00         ; set 0x00 in AH
    mov al,0x04         ; set 0x04 in AL
    mov cl,0x02         ; set 0x02 in CL
    div cl              ; divide 0x0004 by 2
    call display_number
    call newline

divide_double_word_by_a_word:
    mov dx,0x0001       ; set 0x0001 in DX
    mov ax,0x0104       ; set 0x0104 in AX
    mov cx,0x0200       ; set 0x0200 in CX
    div cx              ; divide 0x10104 (65796d) by 0x0200 (512d)
    call display_number
    call newline

divide_word_by_a_word:
    mov dx,0x00         ; set 0x00 in DX
    mov ax,0x1304       ; set 0x1304 in AX
    mov cx,0x0200       ; set 0x0200 in CX
    div cx              ; divide 0x1304 (4868d) by 0x0200 (512d)
    call display_number
    call newline

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

; copy/paste from library2.asm
; display the value of AX as a decimal number
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
newline:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h 
    ret