.code16
.text
.global print_str

# Prints a string using bios interrupt 0x10 (AH = 0x13).
#
# Arguments:
#   ES:BP - the address of the string string to print
#   CX - the length of the string
#   DH:DL - the row and column where to print the string
print_str:
    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl
    int $0x10
    ret
