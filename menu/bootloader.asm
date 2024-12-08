%define BOOT_OFFSET 0x7c00



deactivate_all_partitions:
    push bp
    mov bp, sp

    xor di, di

.deactivate_part:
    mov BYTE [di + BOOT_OFFSET + 0x01be], 0x00
    mov BYTE [di + BOOT_OFFSET + 0x01be + 0x04], 0xff
    add di, 0x10

    cmp di, 0x30
    jle .deactivate_part

.return:
    pop bp
    ret



activate_partition:
    push bp
    mov bp, sp

    mov cl, 0x04

    mov ax, WORD [selected_opt]
    cmp ax, 0x00
    je .activate_part

    mov cl, 0x06

.activate_part:
    mov bx, 0x10
    mul bx

    mov di, ax

    mov BYTE [di + BOOT_OFFSET + 0x01be], 0x80
    mov BYTE [di + BOOT_OFFSET + 0x01be + 0x04], cl

    xor ax, ax
    mov es, ax

    mov bx, BOOT_OFFSET

    mov ax, 0x301
    mov dx, 0x80
    mov cx, 0x01
    int 0x13

.return:
    pop bp
    ret



prepare_boot_os:
    push bp
    mov bp, sp

    mov ax, WORD [selected_opt]
    mov bx, 0x10
    mul bx

    mov si, ax
    mov bx, BOOT_OFFSET

    mov ax, 0x201
    mov dx, WORD [si + BOOT_OFFSET + 0x01be]
    mov cx, WORD [si + BOOT_OFFSET + 0x01be + 0x02]
    int 0x13

.return:
    pop bp
    ret

