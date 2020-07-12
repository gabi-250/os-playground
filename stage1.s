    .code16
    .text
    .global _boot
_boot:
    xor %ax, %ax
    mov %ax, %es
    # CX contains the current number of times we've tried to load the sector
    mov %ax, %cx
disk_load:
    add $1, %cx
    push %cx
    # ES:BX - the address to load sectors into
    mov $0x7e00, %bx
    # Read sectors into memory
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
    # If the carry flag is set, an error occurred
    jc disk_error
    # Check if the number of sectors we wanted to read equals the number
    # of sectors read
    cmp $1, %al
    jne disk_error
    jmp $0,$0x7e00
disk_error:
    pop %cx
    # The load might fail, re-try up to 2 times
    cmp $3, %cx
    jl disk_load
    cli
    xor %ax, %ax
    # Print at row 0x10, column 0x10
    mov $0x10, %dh
    mov $0x10, %dl
    # The address of the message is in ES:BP
    mov $disk_err_msg, %bp
    # The message length
    mov disk_err_msg_len, %cx
    call print_str
    hlt
    .include "utils/bios.s"
disk_err_msg:     .ascii "disk error"
disk_err_msg_len: .word (. - disk_err_msg)
