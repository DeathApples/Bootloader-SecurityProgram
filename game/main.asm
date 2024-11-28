bits 16
org 0x500


_start:
    push message
    call print


.halt:
    hlt


%include "game/graphics.asm"


section .data
message db "Hello World!", 0

