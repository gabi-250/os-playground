.code16
.text

# Checks the status of the A20 line.
#
# Returns:
#   AX - 1, if the A20 line is enabled, and 0 otherwise.
check_a20:
    pushf
    push %ds
    push %es
    push %di
    push %si
    cli
    # AX = 0x0
    xor %ax, %ax
    mov %ax, %es
    # AX = 0xFFFF
    not %ax
    mov %ax, %ds
    # Save the value at [ES:DI] (ES:DI = 0x0000:0x0500 = 0x000500)
    mov $0x0500, %di
    mov %es:(%di), %al
    push %ax
    # Save the value at DS:SI (DS:SI = 0xFFFF:0x0510 = 0x100500)
    mov $0x0510, %si
    mov %ds:(%si), %al
    push %ax
    # Store 2 different values
    movb $0x00, %es:(%di)
    movb $0xFF, %ds:(%si)
    # 0x100500 and 0x000500 are different addresses only if the A20 line is
    # enabled (if it's not enabled, 0x100500 wraps around to 0x000500).
    cmpb $0xFF, %es:(%di)
    # Restore the value that used to be at [DS:SI]
    pop %ax
    mov %al, %ds:(%si)
    # Restore the value that used to be at [ES:DI]
    pop %ax
    mov %al, %es:(%di)
    # Check if the two addreesses contain the same value.
    xor %ax, %ax
    je .La20_check_ret
    mov $1, %ax
.La20_check_ret:
    sti
    pop %si
    pop %di
    pop %es
    pop %ds
    popf
    ret

# Sets the A20 line.
set_a20:
mov     $0x2403, %ax
int     $0x15
jb      a20_failed
cmp     $0, %ah
jnz     a20_failed

mov     $0x2402, %ax
int     $0x15
jb      a20_failed
cmp     $0, %ah
jnz     a20_failed

cmp     $1, %al
jz      a20_activated

mov     $0x2401, %ax
int     $0x15
jb      a20_failed
cmp     $0, %ah
jnz     a20_failed

a20_activated:
    mov $1, %ax
    ret
a20_failed:
    mov $0, %ax
    ret

