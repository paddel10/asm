; library2.asm
; display the value of AX as a decimal number.
; move the value of AX along the decimal place by
; dividing the value by 10. print the result and
; use the quotient as new value to divide by 10
display_number:
    mov dx,0        ; makes DX = 0 (init DX to 0x00)
    mov cx,10       ; makes CX = 10
    div cx          ; divide AX by CX
                    ; double word in DX and AX
                    ; word in CX
                    ; AX = DX:AX / CX
                    ; result/quotient in AX
                    ; remainder in DX
    push dx         ; store DX on stack
    cmp ax,0        ; if AX is zero...
    je display_number_1 ; ...jump
    call display_number ; else calls itself
display_number_1:
    pop ax          ; load AX with value from stack
    add al,'0'      ; convert remainder to ASCII digit
    call display_number ; display on the screen
    ret
newline:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h 
    ret