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
extern void sub_8000544(u32);

extern void *gUnknown_0300500C;
extern void *gUnknown_03005008;
extern u8 gUnknown_03005E88;

extern u8 gUnknown_02024588[];
extern u8 gUnknown_0202552C[];

void sub_80004C4(void) {
    gUnknown_030030F0.unk_20 = 0;
    gUnknown_030030F0.unk_24 = 0;
    gUnknown_030030F0.unk_00 = 0;
    sub_8000544(0x080EC821);
    gUnknown_0300500C = gUnknown_02024588;
    gUnknown_03005008 = gUnknown_0202552C;
    *(u32*)(&gUnknown_02024588[3872]) = 0;
    gUnknown_03005E88 = 0;
}
