bits 16
org 0xd00


%define BOOT_OFFSET 0x7c00
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

    mov ax, 0x03
    int 0x10

    call deactivate_all_partitions
    call activate_partition
    call prepare_boot_os

    mov sp, BOOT_OFFSET
    jmp BOOT_OFFSET


%include "menu/bootloader.asm"
%include "menu/keyboards.asm"
%include "menu/graphics.asm"
%include "menu/prints.asm"

