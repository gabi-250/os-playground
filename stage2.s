    .code16
    .text
_kernel:
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
    # Move 0x0 into ES
    mov $0, %ax
    mov %ax, %es
    # Print the message:
    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl
    # The message length
    mov msg_len, %cx
    # DH:DL = row:column
    xor %dx, %dx
    # The address of the message is in ES:BP
    mov $msg, %bp
    int $0x10

    call check_a20
    cmp $1, %ax
    je a20_message

    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl

    # The message length
    mov msg_not_enabled_len, %cx
    # DH:DL = row:column
    xor %dx, %dx
    # The address of the message is in ES:BP
    mov $msg_not_enabled, %bp
    jmp print_message
a20_message:
    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl

    # The message length
    mov msg_enabled_len, %cx
    # DH:DL = row:column
    xor %dx, %dx
    # The address of the message is in ES:BP
    mov $msg_enabled, %bp
print_message:
    int $0x10
    hlt
    .include "utils/memory.s"
msg:     .ascii "Starting stage 2..."
msg_len: .word (. - msg)

msg_enabled:     .ascii "A20 enabled"
msg_enabled_len: .word (. - msg_enabled)

msg_not_enabled:     .ascii "A20 not enabled"
msg_not_enabled_len: .word (. - msg_not_enabled)
