# asm

Notes and examples from the book "Programming Boot Sector Games" by Oscar Toledo G. (http://nanochess.org).

| File in /src |Comment|
| --- | --- |
| [first.asm](src/first.asm) | Hello world |
| [second.asm](src/second.asm) | keyboard input and display |
| [library1.asm](src/library1.asm), [library2.asm](src/library2.asm) | subroutines for reading and displaying strings |
| [add1.asm](src/add1.asm), [add2.asm](src/add2.asm) | add two integers |
| [sub1.asm](src/sub1.asm) | subtract two integers |
| [mul1.asm](src/mul1.asm) | multiply two integers |
| [div1.asm](src/div1.asm), [div2.asm](src/div2.asm) | divide two integers |
| [shift1.asm](src/shift1.asm) | shift number |
| [guess.asm](src/guess.asm) | guess a number |
| [logical1.asm](src/logical1.asm) | using operators |
| [m.bat](m.bat) | batch file to build given file (no suffix .asm) |

Source code from above can be found here as well: http://github.com/nanochess/book8088

## Example
```
; example.asm
    org 0x0100          ; memory position where the program starts
                        ; memory between 0x00 - 0xff is saved for
                        ; information from the command-line processor

start:
    nop                 ; do nothing

end:
    int 0x20            ; exit to command line.
```
## Variables
```
table:      equ 0x8000      ; define variable at
                            ; address 0x8000 (need to init)
table_size: equ 1000        ; define variable
```
### Initialize list
```
init:
    mov bx,table            ; BX = table address
    mov cx,table_size       ; assign variable table_size to CX
    mov al,0                ; init AL

; initialize table with zeros
p1:
    mov [bx],al             ; write AL into the address pointed by BX
    inc bx                  ; increase BX (pointer)
    loop p1                 ; decrease CX, jump if non-zero
```
## Comparison
CMP subtracts a byte/word from the specified source (number, register, memory location) with a byte/word from a specified destination (register, memory location). Only flags are updated: AF, OF, SF, ZF, PF, CF
Source and destination can't be memory locations at the same time.

## Conditional jumps
Used together with a prior comparison. A few examples of conditional jumps
| Opcode | Description | Condition for jump |
| --- | --- | --- |
| JE/JZ | jump if equal/jump if zero flag | ZF = 0 |
| JC | jump if carry | CF = 1 |
| JNC | jump if no carry | CF = 0 |
| JNE/JNZ | jump if not equal/jump if not zero | ZF = 0 |

## DIV
### divide unsigned word by a byte
```
divide_unsigned_word_by_a_byte:
    mov ah,0x01         ; set 0x01 in AH
    mov al,0x04         ; set 0x04 in AL
    mov cl,0x02         ; set 0x02 in CL
    div cl              ; divide 0x0104 by 0x02
```
#### divide byte by a byte
```
divide_byte_by_a_byte:
    mov ah,0x00         ; set 0x00 in AH
    mov al,0x04         ; set 0x04 in AL
    mov cl,0x02         ; set 0x02 in CL
    div cl              ; divide 0x0004 by 0x02
```
### divide unsigned double word by a word
```
divide_double_word_by_a_word:
    mov dx,0x0001       ; set 0x0001 in DX
    mov ax,0x0104       ; set 0x0104 in AX
    mov cx,0x0200       ; set 0x0200 in CX
    div cx              ; divide 0x10104 (65796) by 0x0200 (512)
```
#### divide word by a word
```
divide_word_by_a_word:
    mov dx,0x00         ; set 0x00 in DX
    mov ax,0x1304       ; set 0x1304 in AX
    mov cx,0x0200       ; set 0x0200 in CX
    div cx              ; divide 0x1304 (4868d) by 0x0200 (512d)
```
## Newline/carriage return
### Plain implementation
```
newline:
    mov ah,02h
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    ret
```
### Using helper function
```
newline:
    mov al,0x0d             ; print carriage return/linefeed
    call display_letter     ; see library2.asm
    mov al,0x0a
    call display_letter
```


