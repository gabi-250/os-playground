.code16
.text
    mov $kernel_msg, %si
    call print_str2
    hlt
    jmp k_main
kernel_msg:             .asciz "Loading kernel...\n\r"
