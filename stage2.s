    .code16
    .text
_stage2:
    # The address of the message is in DS:SI
    mov $msg, %si
    call print_str2
    call check_a20
    test %ax, %ax
    jnz a20_message
    # The address of the message is in DS:SI
    mov $msg_not_enabled, %si
    call print_str2
#    jmp halt
    jmp load_kernel
a20_message:
    # The address of the message is in DS:SI
    mov $msg_enabled, %si
    call print_str2
load_kernel:
    # Load the second stage into ES:BX
    mov $0x1000, %bx
    # Start reading from sector 3
    mov $3, %cl
    # DL = the number of sectors to load
    mov $5, %dl
    call disk_load
    #jmp $0,$1000
    mov $load_error, %si
    call print_str2
halt:
    hlt
    .include "utils/memory.s"
msg:             .asciz "Starting stage 2...\n\r"
msg_enabled:     .asciz "A20 enabled\n\r"
msg_not_enabled: .asciz "A20 not enabled\n\r"
load_error:      .asciz "Failed to load kernel\n\r"
