    .code16
    .text
    .global _boot
_boot:
    cli
    xor %ax, %ax
    mov	%ax, %ds
    mov	%ax, %es
    call init_video
    # Load the second stage into ES:BX
    mov $0x7e00, %bx
    # Start reading from sector 2 (after the boot sector)
    mov $2, %cl
    # DL = the number of sectors to load
    mov $__stage2_sectors, %dl
    call disk_load
    jmp $0,$0x7e00
    hlt
    .include "utils/bios.s"
