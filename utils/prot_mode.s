.code32
.text
prot_mode_entry:
    mov $GDT_DATA_SEGMENT, %ax
    mov %ax, %ds
    mov %ax, %ss
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov $0x90000, %ebp
    mov %ebp, %esp
    jmp start_kernel
    hlt
start_kernel:
    mov $hello, %ebx
    call print_no_bios
    hlt
hello: .asciz "Hello from protected mode..."
