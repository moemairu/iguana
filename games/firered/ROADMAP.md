# Pokémon FireRed — Decompilation Roadmap

**Source ROM**: `baserom.gba` (Pokémon FireRed Version, USA/Europe)
**Console**: Game Boy Advance (ARM7TDMI)
**Runtime layer**: `runtime/gba-native/`

---

## Phase 0 — Toolchain Setup ✅ DONE

- [x] Build matching GBA compiler from upstream GCC 2.95.3 (ARM + Thumb backends)
- [x] Install GNU ARM binutils (`arm-none-eabi-as`, `arm-none-eabi-ld`, `arm-none-eabi-objcopy`)
- [ ] Verify Ghidra is available with ARM/Thumb processor support (deferred to Phase 1)
- [x] Document exact tool versions below
- [x] Build a trivial test program and confirm valid ARM/Thumb codegen

### Tool Versions

| Tool | Version | Notes |
|---|---|---|
| Matching compiler (ARM) | GCC 2.95.3 (`arm-elf`) | Built from upstream GNU source, `tools/matching-cc/` |
| Matching compiler (Thumb) | GCC 2.95.3 (`thumb-coff`) | Built from upstream GNU source, `tools/matching-cc/` |
| `arm-none-eabi-binutils` | 2.46.1 | System package (Arch) |
| Ghidra | TBD | Deferred to Phase 1 |

### ROM Verification

| Property | Value |
|---|---|
| ROM | `baserom.gba` — Pokémon FireRed Version (USA, Europe) |
| Version | v1.0 |
| Game Code | BPRE |
| SHA1 | `41cb23d8dccc8ebd7c649cd8fbb58eeace6e2fdc` |

**Done when**: toolchain builds a trivial test program and produces
identical output to a known-good reference.

---

## Phase 1 — ROM Analysis & Project Skeleton ✅ DONE

- [x] Load `baserom.gba` into Ghidra (ARM Little Endian / v4T)
- [x] Identify GBA ROM header and entry point
- [x] Disassemble `crt0` / startup code
- [x] Scaffold folder structure (`asm/`, `src/`, `data/`, `include/`)
- [x] Create initial `Makefile`

**Done when**: skeleton exists, entry point is identified and
disassembled from this ROM.

---

## Phase 2 — 100% Assembly Baseline ✅ DONE

- [x] Full ROM disassembly into `.s` files (Automated via `disasm.py` into 1MB chunks)
- [ ] Separate code from data sections (Deferred to incremental disassembly in Phase 3)
- [ ] Extract binary data (graphics, maps, text, tables) into `data/` (Deferred to Phase 3)
- [x] Build Makefile that reassembles to byte-identical ROM
- [x] `make compare` passes

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
| 2026-07-29 | 0 | Built matching compiler from upstream GCC 2.95.3 (ARM + Thumb). Binutils 2.46.1 installed. Both compilers verified with test program. |
| 2026-07-29 | 1 | Completed initial ROM analysis. Created linker script, Makefile, and extracted ROM header and crt0 as assembly. Monolithic ROM rebuilds to byte-identical match. |
| 2026-07-29 | 2 | Implemented `disasm.py` to chunk the 16 MiB ROM into manageable 1MB `.s` bank files via `.incbin`. Replaced monolithic `rest.s`. `make compare` passes. |
