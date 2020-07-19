.code16
.global print_str
.global print_str2
.global disk_load
.global init_video

init_video:
    # Set video mode
    mov $0x0, %ah
    # 80x25, colour
    mov $0x03, %al
    int $0x10
    # Set the background colour
    mov $0xb, %ah
    mov $0, %bh
    # 2 = green
    mov $2, %bl
    int $0x10
    xor %bh,%bh
    xor %dx, %dx
    mov $03, %ah
    int $0x10
    ret

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

# Loads a sector from disk using bios interrupt 0x10
# (AH = 0x02).
#
# Arguments:
#   ES:BX - the address to load sectors into
#   CL - the sector to start reading from
#   DL - the number of sectors to load
#
disk_load:
    xor %si, %si
    # The whole register has to be moved here (because fs is a 16-bit register),
    # although we only care about the lower 8 bits
    mov %dx, %fs
.Ldisk_load_start:
    add $1, %si
    mov %si, %gs
    # The number of sectors to read
    mov %dl, %al
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
    # Check if the number of sectors we wanted to read equals the number
    # of sectors read
    mov %fs, %dx
    cmp %dl, %al
    jne .Ldisk_error
    ret
.Ldisk_error:
    mov %gs, %si
    # The load might fail, re-try up to 3 times
    cmp $4, %si
    jg disk_load
    mov $disk_err_msg, %si
    call print_str2
    hlt

disk_err_msg:     .asciz "disk error\n\r"
disk_err_msg_len: .word (. - disk_err_msg)
