ENTRY(_boot)
OUTPUT_FORMAT("binary")

SECTIONS
{
    . = 0x7c00;
    __boot_sect_start_addr = ABSOLUTE(.);
    .text :
    {
        stage1.o(.*)
        /* Set the location counter to 0x1fe = 510 */
        . = 0x1fe;
        /* The boot signature */
        SHORT(0xaa55)
        __stage2_start_addr = ABSOLUTE(.);
        __stage2_sector_start = (ABSOLUTE(.) - __boot_sect_start_addr) / 512  + 1;
        stage2.o(.*)
        . = 0x400;
        /* Calculate how many sectors there are in stage2.s (to know how many
         * sectors to read from disk when loading the stage 2 bootloader)
         */
        __stage2_sectors = (ABSOLUTE(.) - __boot_sect_start_addr) / 512;
        kernel.o(.*)
    }
}

OUTPUT_FORMAT(binary)
