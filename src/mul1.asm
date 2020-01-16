; mul1.asm
    org 0x0100

start:
    mov al,0x03     ; load register AL with 0x03
    mov cl,0x02     ; load register CL with 0x02
    mul cl          ; multiply AL by CL, result into AX

    add al,0x30     ; convert to ASCII digit

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
