.code16
.text

# Checks the status of the A20 line.
#
# Returns:
#   AX - 1, if the A20 line is enabled, and 0 otherwise.
print_message:
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
    int $0x10
    ret
