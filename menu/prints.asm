%define TEXT_COLOR 0x1c



print:
    push bp
    mov bp, sp
    
    mov bl, TEXT_COLOR
    mov si, [bp + 4]

.next_char:
    mov al, BYTE [si]
    or al, al
    je .return

    mov ah, 0x0e
    int 0x10

    inc si
    jmp .next_char

    .return:
        pop bp
        ret 2



print_at_line:
    push bp
    mov bp, sp

    mov ah, 0x02
    xor bx, bx
    mov dx, [bp + 6]
    int 0x10

    mov bx, [bp + 4]
    push bx
    call print

    pop bp
    ret 4



print_title:
    push bp
    mov bp, sp

    push 0x0106
    push title
    call print_at_line

    pop bp
    ret 4



print_hints:
    push bp
    mov bp, sp

    push 0x1402
    push hint1
    call print_at_line

    push 0x1602
    push hint2
    call print_at_line

    pop bp
    ret 4



print_invitation:
    push bp
    mov bp, sp

    push 0x0804
    push invite
    call print_at_line

    pop bp
    ret 4



print_options:
    push bp
    mov bp, sp

    mov dx, 0x0202
    mov cx, 0x04
    xor di, di

    .print_opt:
        add dh, 0x02
        push dx
        mov bx, options
        push WORD [bx + di]
        call print_at_line

        add di, 0x02
        loop .print_opt

        pop bp
        ret 4



section .data

invite db "Enter the password", 0

title db "Custom Bootloader ver. 1.0", 0
hint1 db "Use the ", 0x18, " and ", 0x19, " keys to select OS", 0
hint2 db "Press enter to boot the selected OS", 0

opt_msdos db "MS-DOS 6.22", 0
opt_freedos db "Free-DOS 1.3", 0
opt_win95 db "Windows 95", 0
opt_win98 db "Windows 98 SE", 0

options dw opt_msdos, opt_freedos, opt_win95, opt_win98

