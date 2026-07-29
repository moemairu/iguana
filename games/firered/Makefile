# Makefile — Pokémon FireRed matching build
#
# Build pipeline:
#   asm/*.s → arm-none-eabi-as → *.o → arm-none-eabi-ld → firered.elf → objcopy → firered.gba
#
# Targets:
#   make          — build firered.gba
#   make compare  — verify byte-identical match against baserom.gba
#   make clean    — remove build artifacts

ROM_NAME     := firered
BASEROM      := baserom.gba
ROM_SHA1     := 41cb23d8dccc8ebd7c649cd8fbb58eeace6e2fdc

# Tools
AS       := arm-none-eabi-as
LD       := arm-none-eabi-ld
OBJCOPY  := arm-none-eabi-objcopy
SHA1SUM  := sha1sum
CC       := ../../tools/matching-cc/install/bin/agb-thumb-cc -B../../tools/matching-cc/build-thumb/gcc/

# Flags
ASFLAGS  := -mcpu=arm7tdmi -mthumb-interwork
CFLAGS   := -O2 -mthumb-interwork

# Source files (order matters for linking)
ASM_SRCS := asm/rom_header.s asm/crt0.s asm/syms.s $(sort $(wildcard asm/bank_*.s))
C_SRCS   := src/main.c src/io.c src/intr.c src/gfx.c src/bank00_tail.c

# Object files
ASM_OBJS := $(ASM_SRCS:.s=.o)
C_OBJS   := $(C_SRCS:.c=.o)
ALL_OBJS := asm/rom_header.o asm/crt0.o asm/syms.o src/main.o src/io.o src/intr.o src/gfx.o src/bank00_tail.o $(sort $(wildcard asm/bank_*.o))

# Build directory
BUILD    := build

# ─── Default target ──────────────────────────────────────────────────────
.PHONY: all compare clean

all: $(ROM_NAME).gba

# ─── Assemble ────────────────────────────────────────────────────────────
%.o: %.s $(BASEROM)
	$(AS) $(ASFLAGS) -o $@ $<

# ─── Compile C ───────────────────────────────────────────────────────────
%.s: %.c
	$(CC) $(CFLAGS) -S -o $@ $<

# ─── Link ────────────────────────────────────────────────────────────────
$(ROM_NAME).elf: $(ALL_OBJS) gba.ld syms.ld
	$(LD) -T gba.ld -Map firered.map -o $@ $(ALL_OBJS)

# ─── Extract raw ROM binary ─────────────────────────────────────────────
$(ROM_NAME).gba: $(ROM_NAME).elf
	$(OBJCOPY) -O binary $< $@

# ─── Compare against original ROM ───────────────────────────────────────
compare: $(ROM_NAME).gba
	@echo "$(ROM_SHA1)  $(ROM_NAME).gba" | $(SHA1SUM) -c -
	@echo "ROM matches! ✓"

# ─── Clean ───────────────────────────────────────────────────────────────
clean:
	rm -f $(ALL_OBJS) $(C_SRCS:.c=.s) $(ROM_NAME).elf $(ROM_NAME).gba
