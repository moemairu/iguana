__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_08_start\n\
bank_08_start:\n\
    .incbin \"baserom.gba\", 0x800000, 0x100000\n\
");
