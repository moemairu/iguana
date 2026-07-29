__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_0E_start\n\
bank_0E_start:\n\
    .incbin \"baserom.gba\", 0xE00000, 0x100000\n\
");
