__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_09_start\n\
bank_09_start:\n\
    .incbin \"baserom.gba\", 0x900000, 0x100000\n\
");
