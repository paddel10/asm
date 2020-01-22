; add1.asm
    org 0x0100

start:
    mov al,0x0f         ; load register AL with 0x04
    add al,0x0f         ; add 0x03 to register AL

    call display_number

; copy/paste from library1.asm
    int 0x20		    ; Exit to command line.

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