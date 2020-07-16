.code16
.text
.global print_str
.global print_str2
.global disk_load

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

# Prints a string one character at a time with bios interrupt 0x10
# (AH = 0x0E).
#
# Arguments:
#   ES:BX - the address to load sectors into
#   CL - the sector to start reading from
#   DL - the number of sectors to load
disk_load:
    xor %si, %si
.Ldisk_load_start:
    add $1, %si
    push %si
    # The number of sectors to read
    mov %dl, %al
    push %dx
    # Read sectors into memory
    mov $2, %ah
    # Cylinder 0
    xor %ch, %ch
    # Head 0
    xor %dh, %dh
    # Boot from the 1st hard disk
    mov $0x80, %dl
    # BIOS interrupt for disk functions
    int $0x13
    # If the carry flag is set, an error occurred
    jc .Ldisk_error
    pop %dx
    # Check if the number of sectors we wanted to read equals the number
    # of sectors read
    cmp %dl, %al
    jne .Lprepare_disk_error
    ret
.Lprepare_disk_error:
    push %dx
    jmp .Ldisk_error
.Ldisk_error:
    pop %dx
    pop %si
    # The load might fail, re-try up to 2 times
    cmp $3, %si
    jg disk_load
    mov $disk_err_msg, %si
    call print_str2
    hlt

disk_err_msg:     .asciz "disk error"
disk_err_msg_len: .word (. - disk_err_msg)
