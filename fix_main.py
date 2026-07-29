with open("src/main.c", "r") as f:
    text = f.read()

target1 = """struct Unk030030F0 {
    u32 unk_00;
    u8 filler_04[28];
    u32 unk_20;
    u32 unk_24;
    u16 unk_28;
    u8 filler_2A[4];
    u16 unk_2E;
};"""

repl1 = """struct Unk030030F0 {
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
};"""

target2 = """__asm__("\\n\\
    .align 2\\n\\
    .thumb_func\\n\\
    .global sub_8000510\\n\\
sub_8000510:\\n\\
    .short 0xB510\\n\\
    .short 0xF0F4\\n\\
    .short 0xFE01\\n\\
    .short 0x2800\\n\\
    .short 0xD10F\\n\\
    .short 0xF13B\\n\\
    .short 0xF9A9\\n\\
    .short 0x0600\\n\\
    .short 0x2800\\n\\
    .short 0xD10A\\n\\
    .short 0x4C06\\n\\
    .short 0x6820\\n\\
    .short 0x2800\\n\\
    .short 0xD001\\n\\
    .short 0xF1E3\\n\\
    .short 0xFB3C\\n\\
    .short 0x6860\\n\\
    .short 0x2800\\n\\
    .short 0xD001\\n\\
    .short 0xF1E3\\n\\
    .short 0xFB37\\n\\
    .short 0xBC10\\n\\
    .short 0xBC01\\n\\
    .short 0x4700\\n\\
    .short 0x30F0\\n\\
    .short 0x0300\\n\\
");"""

repl2 = """extern u32 sub_80F5118(void);
extern u32 sub_813B870(void);
extern void sub_81E3BA8(void);

void sub_8000510(void) {
    if (sub_80F5118() == 0) {
        if (sub_813B870() == 0) {
            if (gUnknown_030030F0.unk_00 != 0) {
                sub_81E3BA8();
            }
            if (gUnknown_030030F0.unk_04 != 0) {
                sub_81E3BA8();
            }
        }
    }
}"""

target3 = """__asm__("\\n\\
    .align 2\\n\\
    .thumb_func\\n\\
    .global sub_8000544\\n\\
sub_8000544:\\n\\
    .short 0x4903\\n\\
    .short 0x6048\\n\\
    .short 0x2087\\n\\
    .short 0x00C0\\n\\
    .short 0x1809\\n\\
    .short 0x2000\\n\\
    .short 0x7008\\n\\
    .short 0x4770\\n\\
    .short 0x30F0\\n\\
    .short 0x0300\\n\\
    .short 0x4901\\n\\
    .short 0x2080\\n\\
    .short 0x8008\\n\\
    .short 0x4770\\n\\
    .short 0x0106\\n\\
    .short 0x0400\\n\\"""

repl3 = """void sub_8000544(u32 a0) {
    gUnknown_030030F0.unk_04 = a0;
    gUnknown_030030F0.unk_438 = 0;
}

void sub_8000558(void) {
    *(volatile u16*)0x04000106 = 0x80;
}

__asm__("\\n\\
    .align 2\\n\\
    .thumb_func\\n\\
    .global sub_8000564\\n\\
sub_8000564:\\n\\"""

if target1 not in text: print("target1 not found")
if target2 not in text: print("target2 not found")
if target3 not in text: print("target3 not found")

text = text.replace(target1, repl1)
text = text.replace(target2, repl2)
text = text.replace(target3, repl3)

with open("src/main.c", "w") as f:
    f.write(text)
