__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_06_start\n\
bank_06_start:\n\
    .incbin \"baserom.gba\", 0x600000, 0x100000\n\
");
