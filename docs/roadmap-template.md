# Roadmap Template

Copy this file into `games/<name>/ROADMAP.md` when starting a new game.
Customize the phase details and "done when" criteria for that specific
title.

---

## Phase 0 — Toolchain Setup

Console-specific toolchain (compiler that reproduces the original
code-gen, e.g. `agbcc` for GBA/ARM, a matching Z80 assembler for Game
Boy-family titles, etc.), plus the shared tools already in `tools/`
(Ghidra, permuter, build-compare scripts). Document exact tool versions
in this file for reproducibility.

**Done when**: toolchain builds a trivial test program and produces
identical output to a known-good reference for that hardware.

---

## Phase 1 — ROM Analysis & Project Skeleton

Load the ROM into Ghidra with the correct processor/language setting,
identify entry point and header, and scaffold the game's folder
(`asm/`, `src/`, `data/`, `include/`, `Makefile`) inside `games/<name>/`.

**Done when**: skeleton exists, entry point (`crt0` equivalent) is
identified and disassembled from this ROM specifically.

---

## Phase 2 — 100% Assembly Baseline

Disassemble the entire ROM into `.s` files plus separated binary data,
cross-checked against runtime traces (emulator debugger) to correctly
separate code from data. Build a Makefile that reassembles everything
and produces a byte-identical ROM.

**Done when**: `make compare` in `games/<name>/` reports a byte-identical
match, built entirely from this project's own disassembly — 0% still
needs to be C-ified at this point, that's expected.

---

## Phase 3 — Incremental Matching Decompilation

Convert functions from `asm/` to C in `src/` one at a time, ordered from
most self-contained (runtime/math helpers, BIOS wrappers) to most
integrated (the game's core simulation logic, saved for last). Each
converted function must compile via the matching-aware toolchain and
produce byte-identical machine code; use permuter/decompiler-assist tools
from `tools/` when a function resists manual matching. Track progress in
`ROADMAP.md` by subsystem (e.g. "audio driver: 100%", "battle engine:
20%"), not as one all-or-nothing bar.

**Done when**: all code sections are matched C (`asm/nonmatchings/` is
empty), full-ROM `make compare` still passes.

---

## Phase 4 — Native Platform Port

Once matching is far enough along to support real gameplay, swap this
game's BIOS/hardware-register calls for the shared
`runtime/<family>-native/` layer (or build that layer now if this is the
first game on this hardware family), compile as a native ELF binary for
Linux (no ROM or emulator needed at runtime beyond the one-time asset
extraction), and verify gameplay end-to-end.

**Done when**: a native Linux binary for this game runs standalone and is
playable through a meaningful checkpoint (defined per-game in its
`ROADMAP.md` — doesn't have to be 100% game completion at this stage).

---

## Phase 5 — Windows Cross-Compile

Not started until Phase 4 is verified for that specific game. Retarget
build to MinGW-w64, adjust SDL2 linking, smoke-test on Windows or via
Wine.

**Done when**: a native Windows `.exe` runs and passes the same
checkpoint used for Phase 4 verification.
