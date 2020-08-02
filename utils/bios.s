.code16
.global print_str
.global print_str2
.global disk_load
.global init_video

init_video:
    pusha
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
    popa
    ret

# Prints a string using bios interrupt 0x10 (AH = 0x13).
#
# Arguments:
#   ES:BP - the address of the string string to print
#   CX - the length of the string
#   DH:DL - the row and column where to print the string
print_str:
    pusha
    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl
    int $0x10
    popa
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

# Prints a 16-bit value as a hex string.
#
# Arguments:
#   AX - the value to print
#   DH:DL - the row and column where to print the register
print_hex:
    pusha
    mov $hex_prefix, %bp
    mov hex_prefix_len, %cx
    call print_str
    add hex_prefix_len, %dl
print_high:
    mov %ah, %ch
    mov %ah, %bh
    # Stop when the value at the top of the stack is 1.
    push $0
    jmp .Lprint_byte
print_low:
    push $1
    mov %al, %ch
    mov %al, %bh
.Lprint_byte:
    shr $4, %bh
    call __print_hex
    add $1, %dl
    mov %ch, %bh
    shl $4, %bh
    shr $4, %bh
    call __print_hex
    add $1, %dl
    pop %si
    test %si, %si
    je print_low
    popa
    add $1, %dh
    ret

__print_hex:
    pusha
    cmp $10, %bh
    jl .Lprint_digit
.Lprint_alpha:
    add $'A' - 10, %bh
    jmp print_hex_digit
.Lprint_digit:
    add $'0', %bh
    jmp print_hex_digit
print_hex_digit:
    xor %bl, %bl
    # Output the character at HEX_OUT
    mov %bh, HEX_OUT
    mov $HEX_OUT, %bp
    mov $1, %cx
    call print_str
    popa
    ret

# Loads a sector from disk using bios interrupt 0x10
# (AH = 0x02).
#
# Arguments:
#   ES:BX - the address to load sectors into
#   CL - the sector to start reading from
#   DI - the number of sectors to load
disk_load:
    pusha
    xor %si, %si
.Ldisk_load_loop:
    # Increment the current try
    add $1, %si
    # The number of sectors to read
    mov %di, %ax
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
    # of sectors read (AL = actual sectors read count)
    xor %ah, %ah
    cmp %di, %ax
    jne .Ldisk_error
    popa
    ret
.Ldisk_error:
    # The load might fail, re-try up to 2 times
    cmp $3, %si
    jl .Ldisk_load_loop
    mov $disk_err_msg, %si
    call print_str2
    call print_regs
    hlt

print_regs:
    pusha
    # Don't clobber AX, CX, DX
    push %dx
    push %ax
    push %cx
    # Clear the screen
    call init_video
    xor %ah, %ah
    int $0x16
    mov $regs_msg, %bp
    mov regs_msg_len, %cx
    xor %dx, %dx
    call print_str
    pop %cx
    # Start printing from column 5
    mov $5, %dl
    # Pop AX from the stack
    pop %ax
    call print_hex
    mov %bx, %ax
    call print_hex
    mov %cx, %ax
    call print_hex
    # Pop DX into AX
    pop %ax
    call print_hex
    mov %si, %ax
    call print_hex
    mov %di, %ax
    call print_hex
    mov %bp, %ax
    call print_hex
    mov %cs, %ax
    call print_hex
    mov %ds, %ax
    call print_hex
    mov %ss, %ax
    call print_hex
    mov %es, %ax
    call print_hex
    # Read key press and then clear the screen
    xor %ah, %ah
    int $0x16
    call init_video
    popa
    ret

disk_err_msg:     .asciz "disk error\n\r"
disk_err_msg_len: .word (. - disk_err_msg)

regs_msg:
AX:               .ascii "AX = \n\r"
BX:               .ascii "BX = \n\r"
CX:               .ascii "CX = \n\r"
DX:               .ascii "DX = \n\r"
SI:               .ascii "SI = \n\r"
DI:               .ascii "DI = \n\r"
BP:               .ascii "BP = \n\r"
CS:               .ascii "CS = \n\r"
DS:               .ascii "DS = \n\r"
SS:               .ascii "SS = \n\r"
ES:               .asciz "ES = "
regs_msg_len:     .word (. - regs_msg)

hex_prefix:       .ascii "0x"
hex_prefix_len:   .word (. - hex_prefix)
HEX_OUT:          .ascii "x"
