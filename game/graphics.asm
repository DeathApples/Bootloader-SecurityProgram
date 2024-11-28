print:
    push bp
    mov bp, sp
    
    mov bx, [bp + 4]


.next_char:
    mov al, byte [bx]
    or al, al
    je .return

    mov ah, 0x0e
    int 0x10

    inc bx
    jmp .next_char


.return:
    pop bp
    ret 2

