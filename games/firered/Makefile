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

# Flags
ASFLAGS  := -mcpu=arm7tdmi -mthumb-interwork

# Source files (order matters for linking)
ASM_SRCS := asm/rom_header.s asm/crt0.s $(sort $(wildcard asm/bank_*.s))
ASM_OBJS := $(ASM_SRCS:.s=.o)

# Build directory
BUILD    := build

# ─── Default target ──────────────────────────────────────────────────────
.PHONY: all compare clean

all: $(ROM_NAME).gba

# ─── Assemble ────────────────────────────────────────────────────────────
%.o: %.s $(BASEROM)
	$(AS) $(ASFLAGS) -o $@ $<

# ─── Link ────────────────────────────────────────────────────────────────
$(ROM_NAME).elf: $(ASM_OBJS) gba.ld
	$(LD) -T gba.ld -o $@ $(ASM_OBJS)

# ─── Extract raw ROM binary ─────────────────────────────────────────────
$(ROM_NAME).gba: $(ROM_NAME).elf
	$(OBJCOPY) -O binary $< $@

# ─── Compare against original ROM ───────────────────────────────────────
compare: $(ROM_NAME).gba
	@echo "$(ROM_SHA1)  $(ROM_NAME).gba" | $(SHA1SUM) -c -
	@echo "ROM matches! ✓"

# ─── Clean ───────────────────────────────────────────────────────────────
clean:
	rm -f $(ASM_OBJS) $(ROM_NAME).elf $(ROM_NAME).gba
