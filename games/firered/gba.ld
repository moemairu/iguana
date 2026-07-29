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
        src/bank00_tail.o(.text)
        src/bank01.o(.text)
        src/bank02.o(.text)
        src/bank03.o(.text)
        src/bank04.o(.text)
        src/bank05.o(.text)
        src/bank06.o(.text)
        src/bank07.o(.text)
        src/bank08.o(.text)
        src/bank09.o(.text)
        src/bank0a.o(.text)
        src/bank0b.o(.text)
        src/bank0c.o(.text)
        src/bank0d.o(.text)
        src/bank0e.o(.text)
        src/bank0f.o(.text)
        asm/bank_*.o(.text)
    } > rom

    /* Discard everything else silently */
    /DISCARD/ : { *(.ARM.attributes) *(.comment) *(.note*) }
}
