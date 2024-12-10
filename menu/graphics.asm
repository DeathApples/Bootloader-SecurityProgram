%define SCREEN_WIDTH 0x140
%define OPT_HEIGHT 0x0d
%define OPT_GAP 0x03



draw_rectangle:
    push bp
    mov bp, sp

    mov ax, [bp + 0x04]
    mov bx, [bp + 0x06]
    mov dx, [bp + 0x08]
    sub dx, ax
    dec ax
    push dx
    push bx
    push ax
    call draw_vertical_line

    mov ax, [bp + 0x04]
    mov bx, [bp + 0x06]
    mov dx, [bp + 0x0a]
    sub dx, bx
    dec ax
    push dx
    push bx
    push ax
    call draw_horizontal_line

    mov ax, [bp + 0x04]
    mov bx, [bp + 0x0a]
    mov dx, [bp + 0x08]
    sub dx, ax
    dec bx
    dec ax
    push dx
    push bx
    push ax
    call draw_vertical_line

    mov ax, [bp + 0x08]
    mov bx, [bp + 0x06]
    mov dx, [bp + 0x0a]
    sub dx, bx
    dec ax
    dec ax
    push dx
    push bx
    push ax
    call draw_horizontal_line

    .return:
        pop bp
        ret 8


draw_selected_opt:
    push bp
    mov bp, sp

    mov ax, [bp + 4]
    mov dx, OPT_HEIGHT + OPT_GAP
    mul dx
    add ax, 0x1c
    mov bx, ax
    mov ax, [bp + 4]
    inc ax
    mov dx, OPT_HEIGHT + OPT_GAP
    mul dx
    add ax, 0x1c

    mov dx, [bp + 6]
    mov WORD [color], dx

    push 0x133
    push ax
    push 0x0b
    push bx
    call draw_rectangle

    .return:
        pop bp
        ret 4



draw_horizontal_line:
    push bp
    mov bp, sp

    mov ax, 0xA000
    mov bx, WORD [color]
    mov es, ax

    .next_line:
        cmp bh, 0x01
        jg .return

        mov ax, SCREEN_WIDTH
        mov dx, [bp + 4]
        add dl, bh
        adc dh, 0
        mul dx

        add ax, [bp + 6]
        mov di, ax
        xor cx, cx

    .draw_line:
        inc di
        inc cx
        mov [es:di], bl
        cmp cx, [bp + 8]
        jle .draw_line

        inc bh
        jmp .next_line

    .return:
        pop bp
        ret 6



draw_vertical_line:
    push bp
    mov bp, sp

    mov ax, 0xA000
    mov bx, WORD [color]
    mov es, ax
    xor cx, cx

    .next_line:
        cmp cx, [bp + 8]
        jg .return

        mov ax, SCREEN_WIDTH
        mov dx, [bp + 4]
        add dx, cx
        mul dx

        add ax, [bp + 6]
        mov di, ax
        xor bh, bh

    .draw_line:
        inc di
        inc bh
        mov [es:di], bl
        cmp bh, 0x01
        jle .draw_line

        inc cx
        jmp .next_line

    .return:
        pop bp
        ret 6



section .data
color dw 0x1c

