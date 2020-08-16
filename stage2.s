    .code16
    .text
    .global _stage2
_stage2:
    mov $msg, %si
    call print_str2
test_a20:
    call check_a20
    test %ax, %ax
    jnz a20_message
    mov $msg_not_enabled, %si
    call print_str2
    jmp enable_protected_mode
a20_message:
    # The address of the message is in DS:SI
    mov $msg_enabled, %si
    call print_str2
enable_protected_mode:
    mov $prot_mode_msg, %si
    call print_str2
    lgdt gdt_descriptor
    cli
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0
    # XXX s/0x08/GDT_CODE_SEGMENT
    jmp $0x8,$prot_mode_entry
halt:
    hlt
    .include "utils/memory.s"
    .include "utils/print.s"
    .include "utils/prot_mode.s"
    .include "gdt.s"
msg:             .asciz "Starting stage 2...\n\r"
msg_enabled:     .asciz "A20 enabled\n\r"
msg_not_enabled: .asciz "A20 not enabled\n\r"
prot_mode_msg:   .asciz "Enabling protected mode...\n\r"
load_error:      .asciz "Failed to load kernel\n\r"
