__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_07_start\n\
bank_07_start:\n\
    .incbin \"baserom.gba\", 0x700000, 0x100000\n\
");
