bits 16
org 0x7c00


%define GAME_OFFSET 0x500


_start:
    xor ax, ax
    mov ss, ax
    mov sp, 0x7c00

    mov bx, GAME_OFFSET
    mov ax, 0x204
    mov dx, 0x80
    mov cx, 0x3
    int 0x13

    jmp GAME_OFFSET


times 440-($-$$) db 0
