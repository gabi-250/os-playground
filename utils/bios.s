.code16
.text
.global print_str
.global print_str2

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

# Prints a string one character at a time with bios interrupt 0x10
# (AH = 0x0E).
#
# Arguments:
#   DS:SI - the address of the string string to print
print_str2:
    # The video page.
    xor %bh, %bh
    mov $0x0e, %ah
    # The colour: 0xE0 (E = yellow background, 0 = black text)
    mov $0x14, %bl
.Lprint_chars:
    lodsb
    or %al, %al
    jz .Lprint_str2_exit
    int $0x10
    jmp .Lprint_chars
.Lprint_str2_exit:
    ret
