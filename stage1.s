    .code16
    .text
    .global _boot
_boot:
    xor %ax, %ax
    mov %ax, %es
    mov %ax, %ds
    cli
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
    # Load the second stage into ES:BX
    mov $0x7e00, %bx
    # Start reading from sector 2 (after the boot sector)
    mov $2, %cl
    # DL = the number of sectors to load
    mov $1, %dl
    call disk_load
    jmp $0,$0x7e00
    hlt
    .include "utils/bios.s"
