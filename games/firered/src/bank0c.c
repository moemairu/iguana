__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_0C_start\n\
bank_0C_start:\n\
    .incbin \"baserom.gba\", 0xC00000, 0x100000\n\
");
