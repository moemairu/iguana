__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_05_start\n\
bank_05_start:\n\
    .incbin \"baserom.gba\", 0x500000, 0x100000\n\
");
