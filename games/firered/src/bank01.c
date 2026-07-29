__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_01_start\n\
bank_01_start:\n\
    .incbin \"baserom.gba\", 0x100000, 0x100000\n\
");
