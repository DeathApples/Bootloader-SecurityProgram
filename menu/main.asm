bits 16
org 0xd00



%define SELECTED_OPT_COLOR 0x2a


_start:
    mov ax, 0x13
    int 0x10

    call print_invitation

    push 0x123
    push 0x5d
    push 0x1a
    push 0x4c
    call draw_rectangle

    mov ah, 0x02
    mov bx, SELECTED_OPT_COLOR
    mov dx, 0x0a04
    int 0x10

    xor di, di
    mov es, di

    call authenticate

    mov ax, 0x13
    int 0x10

    call print_title

    push 0x138
    push 0x96
    push 0x06
    push 0x16
    call draw_rectangle

    call print_options
    call print_hints

    push SELECTED_OPT_COLOR
    push 0x00
    call draw_selected_opt

    call select_os
    hlt


%include "menu/keyboards.asm"
%include "menu/graphics.asm"
%include "menu/prints.asm"

