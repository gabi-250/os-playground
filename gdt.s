.code16

gdt:
null_descriptor:
    .long 0x0
    .long 0x0
code_descriptor:
    # Base = 0x0 and limit = 0xfffff
    # Limit
    .word 0xffff
    # Base (bits 0-15)
    .word 0x0
    # Base (bits 16-23)
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    # Base (bits 24-31)
    .byte 0x0
data_descriptor:
    # Base = 0x0 and limit = 0xfffff (overlaps with the code descriptor)
    # Limit
    .word 0xffff
    # Base (bits 0-15)
    .word 0x0
    # Base (bits 16-23)
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    # Base (bits 24-31)
    .byte 0x0
gdt_descriptor:
gdt_size:       .word (. - gdt - 1)
gdt_start:      .long gdt

.set GDT_CODE_SEGMENT, (code_descriptor - gdt)
.set GDT_DATA_SEGMENT, (data_descriptor - gdt)
