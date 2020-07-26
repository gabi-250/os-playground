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
        /* Calculate how many sectors there are in stage2.s (to know how many
         * sectors to read from disk when loading the stage 2 bootloader)
         */
        __stage2_sectors = ABSOLUTE((. - _boot) / 512);
        . = 0x400;
    }
}

OUTPUT_FORMAT(binary)
