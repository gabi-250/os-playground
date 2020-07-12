    .code16
    .text
_stage2:
    # Move 0x0 into ES
    mov $0, %ax
    mov %ax, %es
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
    # Print the message
    mov msg_len, %cx
    # DH:DL = row:column
    xor %dx, %dx
    # The address of the message is in ES:BP
    mov $msg, %bp
    call print_str
    call check_a20
    cmp $1, %ax
    # DH:DL = row:column
    xor %dl, %dl
    mov $1, %dh
    je a20_message
    # The message length
    mov msg_not_enabled_len, %cx
    # The address of the message is in ES:BP
    mov $msg_not_enabled, %bp
    call print_str
a20_message:
    # The message length
    mov msg_enabled_len, %cx
    # The address of the message is in ES:BP
    mov $msg_enabled, %bp
    call print_str
    hlt
    .include "utils/memory.s"
msg:                 .ascii "Starting stage 2..."
msg_len:             .word (. - msg)
msg_enabled:         .ascii "A20 enabled"
msg_enabled_len:     .word (. - msg_enabled)
msg_not_enabled:     .ascii "A20 not enabled"
msg_not_enabled_len: .word (. - msg_not_enabled)
