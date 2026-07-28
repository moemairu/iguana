# Pokémon FireRed — Matching Decompilation Build
#
# Stub Makefile. Will be fleshed out during Phase 1–2.
#
# Usage:
#   make              — build ROM from source
#   make compare      — build and byte-diff against baserom.gba
#   make clean        — remove build artifacts

ROMNAME := pokefirered
BASEROM := baserom.gba

# Tools (paths will be set during Phase 0)
AS      := arm-none-eabi-as
LD      := arm-none-eabi-ld
OBJCOPY := arm-none-eabi-objcopy
CC      := # agbcc path TBD
COMPARE := ../../tools/build-compare/compare.sh

.PHONY: all compare clean

all:
	@echo "Build not yet configured — complete Phase 1 first."

compare: all
	@echo "Comparing built ROM against $(BASEROM)..."
	@if [ ! -f $(BASEROM) ]; then \
		echo "ERROR: $(BASEROM) not found. Place your ROM at games/firered/$(BASEROM)"; \
		exit 1; \
	fi
	@echo "Build not yet configured — compare will work after Phase 2."

clean:
	@echo "Nothing to clean yet."
