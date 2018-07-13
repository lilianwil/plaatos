    %include "plaatos.asm"

    mov si, hello_message
    call os_print_string

    call os_wait_for_key
    call os_clear_screen

    mov di, buffer
    call os_input_string
    call os_print_newline

    mov si, buffer
    call os_print_string
    call os_print_newline

    retf

    hello_message db 'Hello World!', 13, 10, 0
    buffer times 32 db 0

    times 512-($-$$) db 0
