__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_03_start\n\
bank_03_start:\n\
    .incbin \"baserom.gba\", 0x300000, 0x100000\n\
");
