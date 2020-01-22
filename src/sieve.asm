; sieve.asm
; sieve of eratosthenes.
; smallest unmarked number is always a prime.
; increment and check if integer is a
; prime number. mark number in a list
    org 0x0100

table:      equ 0x8000      ; define variable at
                            ; address 0x8000 (need to init)
table_size  equ 1000        ; define variable

init:
    mov bx,table            ; BX = table address
    mov cx,table_size       ; assign variable table_size to CX
    mov al,0                ; init AL

; initialize table with zeros
p1:
    mov [bx],al             ; write AL into the address pointed by BX
    inc bx                  ; increase BX (pointer)
    loop p1                 ; decrease CX, jump if non-zero

start:
    mov ax,2                ; start at number 2

p2:
    mov bx,table            ; reassign BX = table address
    add bx,ax               ; BX = BX + AX
    cmp byte [bx],0         ; is it prime (already marked)?
                            ; byte (8) not word (16) comparison
    jne p3                  ; jump to p3 if it's not 0
    push ax                 ; prepare value to print
    call display_number
    ;mov al,0x2c             ; comma
    mov al,0x0d             ; print carriage return/linefeed
    call display_letter
    mov al,0x0a
    call display_letter
    pop ax

    mov bx,table            ; reassign BX = table address
    add bx,ax               ; BX = BX + AX

p4:
    add bx,ax               ; BX = BX + AX
    cmp bx,table+table_size ; check if BX does not exceed size of table
    jnc p3                  ; jump-if-not-carry (left operand of cmp is
                            ; greater or equal to the operand value on 
                            ; the right)
    mov byte[bx],1          ; write 1
    jmp p4

p3:
    inc ax                  ; increment
    cmp ax,table_size       ; check if AX is within the table_size limit
    jne p2                  ; go back if not 0

; copy/paste
    int 0x20            ; exit to command line.

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