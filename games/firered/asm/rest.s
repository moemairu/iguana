@ rest.s — Remainder of ROM (0x3A4 onwards)
@
@ This is the bulk of the game code and data, included as raw
@ binary. As functions are decompiled or disassembled, their
@ ranges will be removed from this .incbin and replaced with
@ real source files.

    .text
    .thumb

    .incbin "baserom.gba", 0x3A4
