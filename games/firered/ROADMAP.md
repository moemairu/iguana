# Pokémon FireRed — Decompilation Roadmap

**Source ROM**: `baserom.gba` (Pokémon FireRed Version, USA/Europe)
**Console**: Game Boy Advance (ARM7TDMI)
**Runtime layer**: `runtime/gba-native/`

---

## Phase 0 — Toolchain Setup ✅ DONE

- [x] Build matching GBA compiler from upstream GCC 2.95.3 (ARM + Thumb backends)
- [x] Install GNU ARM binutils (`arm-none-eabi-as`, `arm-none-eabi-ld`, `arm-none-eabi-objcopy`)
- [x] Document exact tool versions below
- [x] Build a trivial test program and confirm valid ARM/Thumb codegen

### Tool Versions

| Tool | Version | Notes |
|---|---|---|
| Matching compiler (Thumb) | GCC 2.95.3 (`agb-thumb-cc`) | Built from upstream GNU source, `tools/matching-cc/` |
| `arm-none-eabi-binutils` | 2.46.1 | System package (Arch Linux) |

### ROM Verification

| Property | Value |
|---|---|
| ROM | `baserom.gba` — Pokémon FireRed Version (USA, Europe) |
| Version | v1.0 |
| Game Code | BPRE |
| SHA1 | `41cb23d8dccc8ebd7c649cd8fbb58eeace6e2fdc` |

---

## Phase 1 — ROM Analysis & Project Skeleton ✅ DONE

- [x] Identify GBA ROM header and entry point
- [x] Disassemble `crt0` / startup code
- [x] Scaffold folder structure (`asm/`, `src/`, `data/`, `include/`)
- [x] Create initial `Makefile` with `make compare` target

---

## Phase 2 — 100% Assembly Baseline ✅ DONE

- [x] Full ROM chunked into 1 MB `.s` bank files via `.incbin` (`disasm.py`)
- [x] Makefile assembles to byte-identical ROM
- [x] `make compare` passes (SHA1 verified)

---

## Phase 3 — Incremental Matching Decompilation 🔄 IN PROGRESS

### Source File Inventory

| File | Size | Coverage | Method |
|---|---|---|---|
| `src/main.c` | 33 KB | 0x000–0x1028 (AgbMain + helpers) | Incremental C decompilation |
| `src/io.c` | 72 KB | 0x1028–0x2B80 | `.incbin` wrapper |
| `src/intr.c` | 189 KB | 0x2B80–0x7350 | `.incbin` wrapper |
| `src/gfx.c` | 163 KB | 0x7350–0xB178 | `.incbin` wrapper |
| `src/bank00_tail.c` | — | 0xB178–0xFFFFF | `.incbin` wrapper |
| `src/bank01.c` … `src/bank0f.c` | ~1 MB each | Banks 01–0F | `.incbin` wrapper |

### AgbMain Module — `src/main.c` Function Status

| Function | Address | Status | Notes |
|---|---|---|---|
| `AgbMain` (`sub_80004B0`) | `0x08000400` | ✅ C matched | Entry point / main game loop |
| `sub_80004C4` | `0x080004C4` | ✅ C matched | Init: clears struct, sets OAM flag, inits pointers |
| `sub_8000510` | `0x08000510` | ✅ C matched | Calls `sub_80F5118`, `sub_813B870`, `sub_81E3BA8` |

| `sub_8000544` | `0x08000544` | ✅ C matched | Sets `gUnk_030030F0.unk_04` and `unk_438` |
| `sub_8000558` | `0x08000558` | ✅ C matched | Writes `0x80` to `REG_SOUNDBIAS` (0x04000106) |
| `sub_8000564` | `0x08000564` | ⚠️ ASM wrapper | Logic clear; zero-pad alignment mismatch (`0x0000` vs `nop`) |
| `sub_80005C0` | `0x080005C0` | 🔗 External sym | Declared in `asm/syms.s`; initializes key-repeat struct |
| `sub_80005E8` | `0x080005E8` | ⚠️ ASM wrapper | Key input handler; `push{lr}` leaf quirk (see below) |
| `sub_80008D8` | `0x080008D8` | ✅ C matched | DMA stop: disables 3 DMA channels, calls reset helpers |
| `sub_8000BFC` | `0x08000BFC` | ⚠️ ASM wrapper | OAM clear loop (128 entries); `push{lr}` leaf quirk |

**C matched: 6 / 9 named functions (67%) — `make compare` 100% pass**

> **Known ABI Issue — `push{lr}` without BL**
> GCC 2.95.3 with `-mthumb-interwork` only emits `push {lr}` / `pop {r0}` / `bx r0`
> (instead of `bx lr`) when a function contains a `bl` call making it non-leaf.
> Three ROM functions (`sub_8000564`, `sub_80005E8`, `sub_8000BFC`) have this
> interworking prologue despite containing **no BL**. The most likely cause is an
> original helper call that was inlined or eliminated before the final link,
> leaving the prologue/epilogue behind. Until the exact original call site is
> recovered these functions remain as bit-exact `.short` asm wrappers.

### Key Struct — `struct Unk030030F0` (Key Input State, at `0x030030F0`)

```c
struct Unk030030F0 {
    u32 unk_00;          /* callback ptr (set by sub_8000544) */
    u32 unk_04;          /* callback ptr 2 */
    u8  filler_08[24];
    u32 unk_20;
    u32 unk_24;
    u16 unk_28;          /* prev held keys (raw, from last frame) */
    u16 unk_2A;          /* newly pressed keys this frame */
    u16 unk_2C;          /* currently held keys */
    u16 unk_2E;          /* new_keys2 (with L=R mirror if SGB) */
    u16 unk_30;          /* new_keys3 (autorepeat trigger) */
    u16 unk_32;          /* autorepeat countdown timer */
    u16 unk_34;          /* set when unk_2E & unk_36 */
    u16 unk_36;          /* special key mask */
    u8  filler_38[1024];
    u8  unk_438;         /* OAM update flag (set by sub_8000BFC) */
};
```

### IO & Display Regs — `src/io.c` Function Status

| Function | Address | Status | Notes |
|---|---|---|---|
| `sub_8001028` | `0x08001028` | ✅ C matched | Clears `EngineState->field_10`. Calls `sub_800106C` and `sub_80013F4`. |
| `sub_80019BC` | `0x080019BC` | ✅ C matched |
| `sub_80019D0` | `0x080019D0` | ✅ C matched |
| `sub_8001040` | `0x08001040` | ⚠️ ASM wrapper | Mapped, logic known. Register allocation differs (`r2` vs `r3`). |
| `sub_800105C` | `0x0800105C` | ⚠️ ASM wrapper | Mapped, logic known. Instruction order differs (`ldr` vs `movs`). |
| `sub_800106C` | `0x0800106C` | ⚠️ ASM wrapper | Mapped, logic known. ABI quirk: `push {lr}` without `bl`. |
| `sub_800108C` | `0x0800108C` | ⚠️ ASM wrapper | Mapped, logic known. Instruction order differs (`ldr` vs `lsls`). |


### External Symbols Defined in `asm/syms.s`

| Symbol | Address | Purpose |
|---|---|---|
| `gUnknown_030030F0` | `0x030030F0` | Key input state struct |
| `gUnknown_030030E0` | `0x030030E0` | Key autorepeat initial timer value |
| `gUnknown_0300352C` | `0x0300352C` | Key initial-press delay value |
| `gUnknown_0300500C` | `0x0300500C` | Ptr to game-state struct |
| `gUnknown_03005008` | `0x03005008` | Ptr to second data buffer |
| `gUnknown_02024588` | `0x02024588` | EWRAM data array (OAM shadow base) |
| `gUnknown_0202552C` | `0x0202552C` | EWRAM data array 2 |
| `gUnknown_03005E88` | `0x03005E88` | Byte flag |
| `gUnknown_030008C8` | `0x030008C8` | OAM busy flag |
| `gUnknown_030008C9` | `0x030008C9` | OAM secondary flag |
| `gUnknown_030000C8` | `0x030000C8` | OAM shadow buffer (128-entry array) |
| `gUnknown_030008D0` | `0x030008D0` | `EngineState` struct (Background states + flags) |
| `gUnknown_030008E8` | `0x030008E8` | Background metadata cache (4 entries) |

### Phase 3 Overall Progress

| Subsystem | Status | Notes |
|---|---|---|
| CRT0 / startup | **100% matched** | Full GNU asm, byte-identical |
| AgbMain / Game Loop (`main.c`) | **67% matched** | 6/9 functions in C; 3 pending ABI quirk |
| IO / Display Registers (`io.c`) | **asm-extracted** | 0x1028–0x2B80 (~7 KB) |
| Interrupt / Task System (`intr.c`) | **asm-extracted** | 0x2B80–0x7350 (~18 KB) |
| Graphics Utilities (`gfx.c`) | **asm-extracted** | 0x7350–0xB178 (~16 KB) |
| Remaining bank_00 | **asm-extracted** | `src/bank00_tail.c` |
| Banks 01–0F | **asm-extracted** | `src/bank01.c` … `src/bank0f.c` |
| All other subsystems | not started | Will follow `src/main.c` completion |

**Done when**: all code sections are matched C, `make compare` passes.

---

## Phase 4 — Native Platform Port (Linux)

- [ ] Link against `runtime/gba-native/`
- [ ] Replace BIOS/hardware calls with runtime layer
- [ ] Compile as native ELF
- [ ] Playable through: _(define checkpoint)_

**Prerequisite**: Phase 3 complete for at minimum AgbMain + core game loop.

---

## Phase 5 — Windows Cross-Compile

- [ ] Retarget build to MinGW-w64
- [ ] Adjust SDL2 linking
- [ ] Smoke-test on Windows / Wine

---

## Session Log

| Date | Phase | Summary |
|---|---|---|
| 2026-07-29 | 0 | Initial project scaffold created. |
| 2026-07-29 | 0 | Built matching compiler from upstream GCC 2.95.3 (ARM + Thumb). Binutils 2.46.1 installed. Both compilers verified with test program. |
| 2026-07-29 | 1 | Completed initial ROM analysis. Created linker script, Makefile, extracted ROM header and crt0 as assembly. Monolithic ROM rebuilds to byte-identical match. |
| 2026-07-29 | 2 | Implemented `disasm.py` to chunk the 16 MiB ROM into manageable 1 MB `.s` bank files via `.incbin`. Replaced monolithic `rest.s`. `make compare` passes. |
| 2026-07-29 | 3 | Fully disassembled `crt0` (metadata, entry point, IntrMain dispatcher) into byte-matching GNU Assembly, replacing the `.incbin`. |
| 2026-07-29 | 3 | Established C compilation pipeline via `Makefile` using `agb-thumb-cc`. Extracted `AgbMain` bytes from `bank_00` into `src/main.c` via inline assembly. `make compare` passes. |
| 2026-07-29 | 3 | Decompiled `sub_80004B0` to matching C. Solved ARM/Thumb linker veneer bug by declaring unresolved functions in `asm/syms.s` as `.thumb_func`. |
| 2026-07-29 | 3 | Mass-extracted remaining `AgbMain` module functions (up to 0x1028) into `main.c` as matching assembly wrappers. Build continues to 100% byte-match. |
| 2026-07-29 | 3 | Multi-module extraction: created `src/io.c`, `src/intr.c`, `src/gfx.c`. Makefile updated. ~45 KB of code in named source files. `make compare` passes. |
| 2026-07-29 | 3 | Banks 01–0F extracted into individual `src/bank*.c` files. `make compare` 100% pass. |
| 2026-07-29 | 3 | Decompiled `sub_80004C4`, `sub_8000510`, `sub_8000544`, `sub_8000558`. Padding quirk in `sub_8000564` noted; skipped. `make compare` 100% match. |
| 2026-07-29 | 3 | Decompiled `sub_80008D8` (DMA stop + interrupt disable + reset). Investigated `sub_80005E8` (key handler) and `sub_8000BFC` (OAM clear) — both have `push{lr}` leaf ABI quirk. Completed full `struct Unk030030F0` layout (8 u16 key fields). All external symbols added to `asm/syms.s`. `make compare` 100% match. |
| 2026-07-29 | 3 | IO.C Phase 2 and 3: Mapped EngineState at 0x030008D0. Ported sub_8001028 to perfect C. Kept rest as ASM wrappers due to GCC 2.95.3 padding/literal pool shifting limitations. make compare passes. |
| 2026-07-29 | 3.5 | Solved GCC padding mismatch (46c0 vs 0000) using Makefile sed post-processor. Restored sub_80019BC and 19D0 to pure C. make compare passes. |
| 2026-07-29 | 4.0 | Created regenerate_intr.py. Extracted intr.c (0x2B80 - 0x7350) and integrated into build pipeline. Hit literal pool swap on sub_8002B80 so it remains an asm wrapper. Decompiled sub_8002B9C, BB0, BC4, BD8, and BEC into pure C successfully. Identified IntrNode linked list. |
