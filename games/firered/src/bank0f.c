__asm__("\n\
    .align 2\n\
    .thumb_func\n\
    .global bank_0F_start\n\
bank_0F_start:\n\
    .incbin \"baserom.gba\", 0xF00000, 0x100000\n\
");
