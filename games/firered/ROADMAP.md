# Pokémon FireRed — Decompilation Roadmap

**Source ROM**: `baserom.gba` (Pokémon FireRed Version, USA/Europe)
**Console**: Game Boy Advance (ARM7TDMI)
**Runtime layer**: `runtime/gba-native/`

---

## Phase 0 — Toolchain Setup ⬅️ CURRENT

- [ ] Install/build `agbcc` (matching GBA C compiler)
- [ ] Install GNU ARM binutils (`arm-none-eabi-as`, `arm-none-eabi-ld`, `arm-none-eabi-objcopy`)
- [ ] Verify Ghidra is available with ARM/Thumb processor support
- [ ] Document exact tool versions below
- [ ] Build a trivial test program and confirm identical codegen against a known reference

### Tool Versions

| Tool | Version | Notes |
|---|---|---|
| `agbcc` | TBD | |
| `arm-none-eabi-binutils` | TBD | |
| Ghidra | TBD | |

**Done when**: toolchain builds a trivial test program and produces
identical output to a known-good reference.

---

## Phase 1 — ROM Analysis & Project Skeleton

- [ ] Load `baserom.gba` into Ghidra (ARM Little Endian / v4T)
- [ ] Identify GBA ROM header and entry point
- [ ] Disassemble `crt0` / startup code
- [ ] Scaffold folder structure (`asm/`, `src/`, `data/`, `include/`)
- [ ] Create initial `Makefile`

**Done when**: skeleton exists, entry point is identified and
disassembled from this ROM.

---

## Phase 2 — 100% Assembly Baseline

- [ ] Full ROM disassembly into `.s` files
- [ ] Separate code from data sections
- [ ] Extract binary data (graphics, maps, text, tables) into `data/`
- [ ] Build Makefile that reassembles to byte-identical ROM
- [ ] `make compare` passes

**Done when**: `make compare` reports byte-identical match.

---

## Phase 3 — Incremental Matching Decompilation

Progress by subsystem:

| Subsystem | Status | Notes |
|---|---|---|
| CRT0 / startup | not started | |
| BIOS wrappers | not started | |
| Math / utility lib | not started | |
| DMA / memory | not started | |
| Graphics / PPU | not started | |
| Audio driver | not started | |
| Text engine | not started | |
| Menu / UI | not started | |
| Overworld | not started | |
| Battle engine | not started | |
| Script engine | not started | |
| Save system | not started | |

**Done when**: all code sections are matched C, `make compare` passes.

---

## Phase 4 — Native Platform Port (Linux)

- [ ] Link against `runtime/gba-native/`
- [ ] Replace BIOS/hardware calls with runtime layer
- [ ] Compile as native ELF
- [ ] Playable through: _(define checkpoint)_

**Done when**: native Linux binary runs standalone and is playable
through the defined checkpoint.

---

## Phase 5 — Windows Cross-Compile

- [ ] Retarget build to MinGW-w64
- [ ] Adjust SDL2 linking
- [ ] Smoke-test on Windows / Wine

**Done when**: native Windows `.exe` passes the same checkpoint.

---

## Session Log

| Date | Phase | Summary |
|---|---|---|
| 2026-07-29 | 0 | Initial project scaffold created. |
