    .code16
    .text
    .global _boot
_boot:
    # DH - number of sectors to load
    mov $1, %dh
    # DL - drive number
    mov $0, %dh
    # ES:BX - the address to load sectors into
    mov $0, %bx
    mov %bx, %es
    mov $0x7e00, %bx
disk_load:
    push %dx
    # Read sector(s) into memory
    mov $2, %ah
    # The number of sectors to read
    mov $1, %al
    # Cylinder 0
    xor %ch, %ch
    # Head 0
    xor %dh, %dh
    # Start reading from sector 2 (after the boot sector)
    mov $2, %cl
    # BIOS interrupt for disk functions
    int $0x13
    # if the carry flag is set, an error occurred
    jc disk_error
    pop %dx
    # Check if the number of sectors we wanted to read equals the number
    # of sectors read
    cmp $1, %al
    jne disk_error
    jmp $0,$0x7e00
disk_error:
    cli
    # Move 0 into ES
    xor %ax, %ax
    mov %ax, %es
    mov $0x13, %ah
    mov $0x01, %al
    # The video page.
    xor %bh, %bh
    # The colour: 0x14 (1 = blue background, 4 = red text)
    mov $0x14, %bl
    # The message length
    mov disk_err_msg_len, %cx
    # The row:
    mov $0x10, %dh
    # The column:
    mov $0x10, %dl
    # The address of the message is in ES:BP
    mov $disk_err_msg, %bp
    int $0x10
    hlt
disk_err_msg:     .ascii "disk error"
disk_err_msg_len: .word (. - disk_err_msg)
