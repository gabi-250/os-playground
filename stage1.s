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

# Real mode memory map:
#
#    0x00000000 - 0x000003FF - Real Mode Interrupt Vector Table (IVT)
#    0x00000400 - 0x000004FF - BIOS Data Area (BDA)
#    0x00000500 - 0x00007BFF - Conventional Memory (unused)
#    0x00007C00 - 0x00007DFF - Bootsector
#    0x00007E00 - 0x0007FFFF - Conventional Memory (unused)
#    0x00080000 - 0x0009FFFF - Extended BIOS Data Area (EBDA): partially used by the EBDA
#    0x000A0000 - 0x000BFFFF - Video RAM (VRAM) Memory
#    0x000B0000 - 0x000B7777 - Monochrome Video Memory
#    0x000B8000 - 0x000BFFFF - Color Video Memory
#    0x000C0000 - 0x000C7FFF - Video ROM BIOS
#    0x000C8000 - 0x000EFFFF - BIOS Shadow Area
#    0x000F0000 - 0x000FFFFF - System BIOS
_boot:
    cli
    xor %ax, %ax
    mov	%ax, %ds
    mov	%ax, %es
    mov $STACK_SEGMENT, %ax
    mov %ax, %ss

    call init_video
    # Load the second stage into ES:BX
    mov $__stage2_start_addr, %bx
    # Start reading from sector 2 (after the boot sector)
    mov $__stage2_sector_start, %cl
    # DI = the number of sectors to load
    mov $__stage2_sectors, %di
    call disk_load
    jmp $0,$__stage2_start_addr
    hlt
    .include "utils/bios.s"
.set STACK_SEGMENT, 0x9000
