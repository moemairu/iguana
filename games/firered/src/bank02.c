__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_02_start\n\
bank_02_start:\n\
    .incbin \"baserom.gba\", 0x200000, 0x100000\n\
");
