    jmp near os_main
    db 0
    call os_print_string
    retf
    call os_print_newline
    retf
    call os_clear_screen
    retf
    call os_wait_for_key
    retf
    call os_input_string
    retf
    call os_string_compare
    retf

os_main:
    mov ax, 0x50
    mov ds, ax


    mov ax, 0x50
    mov es, ax
    mov bx, 0x400

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13


    call os_clear_screen
    mov si, welcome_text
    call os_print_string
    mov si, help_text
    call os_print_string

os_command_prompt:
    mov si, prompt_text
    call os_print_string

    mov di, command_buffer
    call os_input_string
    call os_print_newline

    cmp byte [command_buffer], 0
    je os_command_prompt

    mov si, command_table
.find_command:
    mov di, command_buffer
    call os_string_compare
    je .found_command
.fill_si:
    mov al, [si]
    inc si
    cmp al, 0
    jne .fill_si
    add si, 2
    cmp byte [si], 0
    je .unknown_command
    jmp .find_command
.found_command:
    call word [si]
    jmp os_command_prompt
.unknown_command:
    mov si, unknown_command_text
    call os_print_string
    mov si, command_buffer
    call os_print_string
    call os_print_newline
    jmp os_command_prompt

; ========================================================================

clear_command:
    call os_clear_screen
    ret

hello_command:
    mov ax, 0x110 ; 0x50 + 0x40 + 0x20 =  0x110
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 5
    mov dh, 0
    mov dl, 0x80
    int 0x13

    mov ax, 0x110
    mov ds, ax
    call 0x110:0

    mov ax, 0x50
    mov ds, ax
    ret

help_command:
    mov si, help_text
    call os_print_string
    ret

list_command:
    mov si, 0x400
.repeat:
    call os_print_string
    call os_print_newline
    inc si
    cmp byte [si], 0
    jne .repeat
    ret

read_command:
    mov si, 0x400
    call os_print_string
    call os_print_newline

    mov ax, 0x50 ; 0x50 + 0x40 + 0x20 =  0x110
    mov es, ax
    mov bx, 0x600

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, [si]
    mov dh, 0
    mov dl, 0x80
    int 0x13

    mov si, 0x600
    call os_print_string

    ret


; ========================================================================

os_print_string:
    mov ah, 0x0e
.repeat:
    mov al, [si]
    inc si
    cmp al, 0
    je .done
    int 0x10
    jmp .repeat
.done:
    ret

os_print_newline:
    mov ah, 0x0e
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret

os_clear_screen:
    mov ah, 0
    mov al, 3
    int 0x10
    ret

os_wait_for_key:
    mov ah, 0x10
    int 0x16
    ret

os_input_string:
    mov cx, 0
.repeat:
    call os_wait_for_key

    cmp al, 13
    je .done

    cmp al, 8
    je .backspace

    cmp cx, 32 - 1
    je .repeat

    cmp al, ' '
    jb .repeat
    cmp al, '~'
    ja .repeat

    mov ah, 0x0e
    int 0x10

    mov [di], al
    inc di
    inc cx
    jmp .repeat
.backspace:
    cmp cx, 0
    je .repeat

    mov ah, 0x0e
    mov al, 8
    int 10h
    mov al, 32
    int 10h
    mov al, 8
    int 10h

    dec di
    dec cx
    jmp .repeat
.done:
    mov byte [di], 0
    inc di
    ret

os_string_compare:
.repeat:
    mov al, [si]
    inc si
    mov bl, [di]
    inc di
    cmp al, bl
    jne .done
    cmp al, 0
    je .done
    jmp .repeat
.done:
    ret

    welcome_text db 'Welcome to PlaatOS...', 13, 10, 0
    prompt_text db '> ', 0
    command_buffer times 32 db 0
    command_table:
        db 'clear', 0
        dw clear_command
        db 'hello', 0
        dw hello_command
        db 'help', 0
        dw help_command
        db 'list', 0
        dw list_command
        db 'read', 0
        dw read_command
        db 0
    help_text db 'Commands: clear, hello, help, list, read', 13, 10, 0
    unknown_command_text db 'Unknown command: ', 0

    times 1024-($-$$) db 0
