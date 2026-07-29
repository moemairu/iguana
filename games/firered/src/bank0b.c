__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_0B_start\n\
bank_0B_start:\n\
    .incbin \"baserom.gba\", 0xB00000, 0x100000\n\
");
