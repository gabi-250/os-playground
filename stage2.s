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
    # Move 0x1000 into ES
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
    # The row:
    mov $0x10, %dh
    # The column:
    mov $0x10, %dl
    # The address of the message is in ES:BP
    mov $msg, %bp
    int $0x10
    hlt
msg:     .ascii "Starting stage 2..."
msg_len: .word (. - msg)
