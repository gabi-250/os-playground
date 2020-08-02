    .code16
    .text
    .global _boot
# Memory layout:
# 0x9fc00
# .
# . [Free]
# .
# 0x9000 ------- stack begins
# 0x8000 ------- stack ends
# 0x7e00 ------- stage2
# 0x7c00 ------- stage1
# ...
_boot:
    cli
    xor %ax, %ax
    mov	%ax, %ds
    mov	%ax, %es
    mov $STACK_SEGMENT, %ax
    mov %ax, %ss
    call init_video
    # Load the second stage into ES:BX
    mov $0x7e00, %bx
    # Start reading from sector 2 (after the boot sector)
    mov $2, %cl
    # DI = the number of sectors to load
    mov $__stage2_sectors, %di
    call disk_load
    jmp $0,$0x7e00
    hlt
    .include "utils/bios.s"
.set STACK_SEGMENT, 0x9000
