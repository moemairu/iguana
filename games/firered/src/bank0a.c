__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_0A_start\n\
bank_0A_start:\n\
    .incbin \"baserom.gba\", 0xA00000, 0x100000\n\
");
