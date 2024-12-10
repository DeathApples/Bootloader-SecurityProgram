%define PASSWORD_OFFSET 0xae0



authenticate:
    push bp
    mov bp, sp

    mov ah, 0x02
    mov bx, SELECTED_OPT_COLOR
    mov dx, 0x0a04
    int 0x10

    xor di, di
    mov es, di

    .input_password_handle:
        mov ah, 0x10
        int 0x16

        cmp ah, 0x0e
        je .remove_last_chr

        cmp ah, 0x1c
        je .check_password

        cmp di, 0x20
        jge .input_password_handle

        cmp al, 0x20
        jl .input_password_handle

        cmp al, 0x7f
        jg .input_password_handle

        mov BYTE [password_input + di], al
        inc di

        mov ax, 0x0e2a
        int 0x10

        jmp .input_password_handle

    .remove_last_chr:
        cmp di, 0x00
        jle .input_password_handle

        mov ah, 0x02
        mov dl, 0x03
        add dx, di
        int 0x10
        
        mov ax, 0x0e20
        int 0x10

        mov ah, 0x02
        mov dl, 0x03
        add dx, di
        int 0x10

        dec di
        jmp .input_password_handle

    .check_password:
        mov BYTE [password_input + di], 0x00
        mov cx, di
        inc cx
        push di
        mov di, password_input
        mov si, PASSWORD_OFFSET
        repe cmpsb

        je .return

        pop di
        jmp .input_password_handle

    .return:
        pop di
        pop bp
        ret



select_os:
    push bp
    mov bp, sp

    .select_os_handle:
        mov ah, 0x00
        int 0x16

        cmp ah, 0x48
        je .up_arrow_pressed

        cmp ah, 0x50
        je .down_arrow_pressed

        cmp ah, 0x1c
        je .return

        jmp .select_os_handle

    .up_arrow_pressed:
        mov dx, WORD [selected_opt]
        cmp dx, 0x00
        jle .select_os_handle

        push 0x00
        push dx
        call draw_selected_opt

        mov dx, WORD [selected_opt]
        dec dx
        mov WORD [selected_opt], dx

        push SELECTED_OPT_COLOR
        push dx
        call draw_selected_opt

        jmp .select_os_handle

    .down_arrow_pressed:
        mov dx, WORD [selected_opt]
        cmp dx, 0x03
        jge .select_os_handle

        push 0x00
        push dx
        call draw_selected_opt

        mov dx, WORD [selected_opt]
        inc dx
        mov WORD [selected_opt], dx

        push SELECTED_OPT_COLOR
        push dx
        call draw_selected_opt
        
        jmp .select_os_handle

    .return:
        pop bp
        ret



section .data

selected_opt dw 0
password_input db 32 dup(0)

