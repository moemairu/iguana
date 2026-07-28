/* gba.ld — GBA linker script for Pokémon FireRed matching build */

ENTRY(_start)

MEMORY
{
    rom   (rx)  : ORIGIN = 0x08000000, LENGTH = 16M
    ewram (rwx) : ORIGIN = 0x02000000, LENGTH = 256K
    iwram (rwx) : ORIGIN = 0x03000000, LENGTH = 32K
}

SECTIONS
{
    . = ORIGIN(rom);

    .text : {
        asm/rom_header.o(.text)
        asm/crt0.o(.text)
        asm/rest.o(.text)
    } > rom

    /* Discard everything else silently */
    /DISCARD/ : { *(.ARM.attributes) *(.comment) *(.note*) }
}
