bits 16
org 0x900


%define SELECTED_OPT_COLOR 0x2a


_start:
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

.keybord_handle:
    mov ah, 0
    int 0x16

    cmp ah, 0x48
    je .up_arrow_pressed

    cmp ah, 0x50
    jne .keybord_handle

.down_arrow_pressed:
    mov dx, WORD [selected_opt]
    cmp dx, 0x03
    jge .keybord_handle

    push 0x00
    push dx
    call draw_selected_opt

    mov dx, WORD [selected_opt]
    inc dx
    mov WORD [selected_opt], dx

    push SELECTED_OPT_COLOR
    push dx
    call draw_selected_opt
    
    jmp .keybord_handle

.up_arrow_pressed:
    mov dx, WORD [selected_opt]
    cmp dx, 0
    jle .keybord_handle

    push 0x00
    push dx
    call draw_selected_opt

    mov dx, WORD [selected_opt]
    dec dx
    mov WORD [selected_opt], dx

    push SELECTED_OPT_COLOR
    push dx
    call draw_selected_opt

    jmp .keybord_handle


%include "menu/graphics.asm"
%include "menu/prints.asm"


section .data
selected_opt dw 0

