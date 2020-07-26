    .code32
    .text
# Prints a string character by character by writing to video memory.
#
# Arguments:
#   EBX - the address of the string string to print
print_no_bios:
    pusha
    mov video_memory, %edx
1:
    mov (%ebx), %al
    mov flags, %ah
    cmp $0, %al
    je 2f
    mov %ax, (%edx)
    add $1, %ebx
    add $2, %edx
    jmp 1b
2:
    popa
    ret
video_memory: .long 0xb8000
# 1 = blue background, f = white foreground
flags:        .byte 0x1f
