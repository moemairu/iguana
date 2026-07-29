__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_04_start\n\
bank_04_start:\n\
    .incbin \"baserom.gba\", 0x400000, 0x100000\n\
");
