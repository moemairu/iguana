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

- [ ] **Phase 1: Initial Linker Setup & Extraction** (Complete)
- [ ] **Phase 2: Split Assembly** (Complete)
- [x] **Phase 3: Incremental Matching Decompilation** (In Progress)
  - AgbMain / Game Loop | **35%** | Decompiling asm wrappers to actual C code in `src/main.c`. `sub_8000510`, `sub_8000544`, `sub_8000558` perfectly matched.
  - Remaining bank_00 | **100%** | Extracted to `src/bank00_tail.c` using `.incbin`
  - Banks 01–0F | **100%** | Extracted to `src/bank*.c` using `.incbin` wrappers

Progress by subsystem:

| Subsystem | Status | Notes |
|---|---|---|
| CRT0 / startup | **100%** | Matched assembly (`asm/crt0.s`) |
| AgbMain / Game Loop | **35%** | Decompiling asm wrappers to actual C code in `src/main.c`. `sub_8000510`, `sub_8000544`, `sub_8000558` perfectly matched. |
| IO / Display Registers | **asm-extracted** | `src/io.c` — 0x1028–0x2B80 (7 KB) |
| Interrupt / Task System | **asm-extracted** | `src/intr.c` — 0x2B80–0x7350 (18 KB) |
| Graphics Utilities | **asm-extracted** | `src/gfx.c` — 0x7350–0xB178 (16 KB) |
| Remaining bank_00 | **100%** | Extracted to `src/bank00_tail.c` using `.incbin` |
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
| 2026-07-29 | 3 | Fully disassembled `crt0` (metadata, entry point, IntrMain dispatcher) into byte-matching GNU Assembly, replacing the `.incbin`. |
| 2026-07-29 | 3 | Established C compilation pipeline via `Makefile` using `agb-thumb-cc`. Extracted `AgbMain` bytes from `bank_00` into `src/main.c` via inline assembly. `make compare` passes. |
| 2026-07-29 | 3 | Decompiled `sub_80004B0` to matching C code in `src/main.c`. Solved ARM/Thumb linker veneer bug by declaring unresolved functions in `asm/syms.s` as `.thumb_func`. |
| 2026-07-29 | 3 | Mass-extracted remaining `AgbMain` module functions (up to `0x1028`) into `main.c` as matching assembly wrappers to preserve literal pools. Build continues to 100% byte-match. |
| 2026-07-29 | 3 | Multi-module extraction: created `src/io.c` (0x1028–0x2B80), `src/intr.c` (0x2B80–0x7350), `src/gfx.c` (0x7350–0xB178). Updated linker script, Makefile. Built automation script for chunk extraction. ~45 KB of code now in named source files. `make compare` passes. |
