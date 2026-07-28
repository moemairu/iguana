@ rom_header.s — GBA ROM header (0x000–0x0FF)
@
@ The header contains the entry branch, Nintendo logo, game title,
@ game code (BPRE), and other fixed fields.
@
@ Included as raw binary to guarantee exact byte layout.
@ See: https://problemkaputt.de/gbatek.htm#gbacartridgeheader

    .text
    .global _start
_start:
    .incbin "baserom.gba", 0x0, 0x100
