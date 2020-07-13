    .code16
    .text
_stage2:
    # Move 0x0 into ES
    mov $0, %ax
    mov %ax, %es
    mov %ax, %ds
    # Set video mode
    mov $0x0, %ah
    # 80x25
    mov $0x02, %al
    int $0x10
    # Set the background colour
    mov $0xb, %ah
    mov $0, %bh
    # 2 = green
    mov $2, %bl
    int $0x10
    # The address of the message is in DS:SI
    mov $msg, %si
    call print_str2
    call check_a20
    test %ax, %ax
    jnz a20_message
    # The address of the message is in DS:SI
    mov $msg_not_enabled, %si
    call print_str2
    jmp halt
a20_message:
    # The message length
    mov msg_enabled_len, %cx
    # The address of the message is in DS:SI
    mov $msg_enabled, %si
    call print_str2
halt:
    hlt
    .include "utils/memory.s"
msg:                 .asciz "Starting stage 2...\n\r"
msg_len:             .word (. - msg)
msg_enabled:         .asciz "A20 enabled\n\r"
msg_enabled_len:     .word (. - msg_enabled)
msg_not_enabled:     .asciz "A20 not enabled\n\r"
msg_not_enabled_len: .word (. - msg_not_enabled)
