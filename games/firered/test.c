typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

struct Unk030030F0 {
    u32 unk_00;
    u32 unk_04;
    u8 filler_08[24];
    u32 unk_20;
    u32 unk_24;
    u16 unk_28;
    u8 filler_2A[4];
    u16 unk_2E;
    u8 filler_30[1032];
    u8 unk_438;
};

extern struct Unk030030F0 gUnknown_030030F0;

void sub_8000544(u32 a0) {
    gUnknown_030030F0.unk_04 = a0;
    gUnknown_030030F0.unk_438 = 0;
}

void sub_8000558(void) {
    *(volatile u16*)0x04000106 = 0x80;
}
