ENTRY(_boot)
SECTIONS
{
    . = 0x7c00;
    .text :
    {
        stage1.o(.*)
        /* Set the location counter to 0x1fe = 510 */
        . = 0x1fe;
        /* The boot signature */
        SHORT(0xaa55)
        stage2.o(.*)
        . = 0x400;
    }
}
