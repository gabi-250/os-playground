.code32
.text
prot_mode_entry:
    mov $GDT_DATA_SEGMENT, %ax
    mov %ax, %ds
    mov %ax, %ss
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $0x9000, %ebp
    mov %ebp, %esp
start_kernel:
    mov $hello, %ebx
    call print_no_bios
    call k_main
    hlt
hello: .asciz "Hello from protected mode..."
