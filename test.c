typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

struct Unk030030F0 {
    u32 unk_00;
    u32 unk_04;
    u8 filler_08[24];
    u32 unk_20;
    u32 unk_24;
    u16 prev_keys;     // 28
    u16 new_keys;      // 2A
    u16 held_keys;     // 2C
    u16 new_keys2;     // 2E
    u16 new_keys3;     // 30
    u16 timer;         // 32
    u8 filler_34[1028];
    u8 unk_438;
};

extern struct Unk030030F0 gUnknown_030030F0;
extern u16 gUnknown_030030E0;

struct Unk0300500C {
    u8 filler_00[19];
    u8 unk_13;
};

extern struct Unk0300500C gUnknown_0300500C;

void sub_80005E8(void) {
    u16 keyInput = *(volatile u16*)0x04000130;
    u16 keys = keyInput ^ 0x3FF;
    u16 new_keys = keys & ~gUnknown_030030F0.prev_keys;
    
    gUnknown_030030F0.new_keys = new_keys;
    gUnknown_030030F0.new_keys2 = new_keys;
    gUnknown_030030F0.new_keys3 = new_keys;

    if (new_keys != 0 || gUnknown_030030F0.held_keys != keys) {
        gUnknown_030030F0.timer = gUnknown_030030E0;
    } else {
        gUnknown_030030F0.timer--;
        if (gUnknown_030030F0.timer == 0) {
            gUnknown_030030F0.new_keys3 = keys;
            gUnknown_030030F0.timer = gUnknown_030030E0;
        }
    }

    gUnknown_030030F0.prev_keys = keys;
    gUnknown_030030F0.held_keys = keys;

    if (gUnknown_0300500C.unk_13 == 2) {
        if (gUnknown_030030F0.new_keys2 & 0x200) gUnknown_030030F0.new_keys2 |= 1;
        if (gUnknown_030030F0.held_keys & 0x200) gUnknown_030030F0.held_keys |= 1;
        if (gUnknown_030030F0.new_keys3 & 0x200) gUnknown_030030F0.new_keys3 |= 1;
    }
}
