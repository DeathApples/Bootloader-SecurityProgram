bits 16
org 0x500


%define MENU_OFFSET 0x900


_start:
    ; push message
    ; call print
    jmp MENU_OFFSET


.halt:
    hlt


%include "game/graphics.asm"


section .data
message db "Hello World!", 0

