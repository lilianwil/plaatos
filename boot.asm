    mov ax, 0x50
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 2
    mov ch, 0
    mov cl, 3
    mov dh, 0
    mov dl, 0x80
    int 0x13

    jmp 0x50:0

    times 510-($-$$) db 0
    dw 0xaa55
