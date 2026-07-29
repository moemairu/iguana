/* gba.ld — GBA linker script for Pokémon FireRed matching build */

OUTPUT_ARCH(arm)

ENTRY(_start)

MEMORY
{
    rom   (rx)  : ORIGIN = 0x08000000, LENGTH = 17M
    ewram (rwx) : ORIGIN = 0x02000000, LENGTH = 256K
    iwram (rwx) : ORIGIN = 0x03000000, LENGTH = 32K
}

SECTIONS
{
    . = ORIGIN(rom);

    .text : {
        asm/rom_header.o(.text)
        asm/crt0.o(.text)
        src/main.o(.text)
        src/io.o(.text)
        src/intr.o(.text)
        src/gfx.o(.text)
        asm/bank_*.o(.text)
    } > rom

    /* Discard everything else silently */
    /DISCARD/ : { *(.ARM.attributes) *(.comment) *(.note*) }
}
