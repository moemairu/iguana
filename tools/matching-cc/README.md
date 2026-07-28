# Matching Compiler (GBA)

Custom-built GCC 2.95.3 cross-compilers for GBA matching decompilation,
built entirely from upstream GNU sources — no dependency on any existing
decompilation project's tooling.

## What This Is

The GBA SDK shipped with a compiler based on GCC 2.95 (Cygnus GNUPro).
To produce byte-identical output during matching decompilation, we need
compilers that reproduce the same code generation. This directory builds
two compilers from the **upstream GCC 2.95.3 source** (GNU FTP archive,
GPL-licensed):

| Compiler | Target | Generates | Usage |
|---|---|---|---|
| `agb-arm-cc` | `arm-elf` | 32-bit ARM instructions | ARM-mode functions |
| `agb-thumb-cc` | `thumb-coff` | 16-bit Thumb instructions | Most game code |

## Building

### Prerequisites

- `arm-none-eabi-binutils` (assembler, linker)
- `gcc` (host compiler, any modern version)
- `make`, `curl`, `tar`
- `libtool` or `automake` (for modern `config.guess`/`config.sub`)

On Arch/CachyOS:
```bash
sudo pacman -S arm-none-eabi-binutils base-devel
```

### Build

```bash
./build-toolchain.sh
```

The script is idempotent — re-running skips completed steps. Takes ~2 min
on a modern machine.

### Output

```
install/bin/agb-arm-cc      # ARM-mode compiler (xgcc wrapper)
install/bin/agb-thumb-cc    # Thumb-mode compiler (xgcc wrapper)
install/bin/arm-elf-cc1     # ARM cc1 backend
install/bin/thumb-coff-cc1  # Thumb cc1 backend
```

## Testing

```bash
echo 'int add(int a, int b) { return a + b; }' > test.c

# Thumb mode (most GBA game code)
install/bin/agb-thumb-cc -Bbuild-thumb/gcc/ -O2 -S test.c -o test_thumb.s

# ARM mode (performance-critical code)
install/bin/agb-arm-cc -Bbuild/gcc/ -O2 -mthumb-interwork -S test.c -o test_arm.s
```

## Patches Applied

Two patches are needed to build GCC 2.95.3 on modern systems:

1. **`001-fix-arm-prog-mode-lvalue.patch`**: Modern GCC rejects
   cast-as-lvalue (`arm_prog_mode = ...`). Fix: assign to the
   underlying variable `arm_prgmode`.

2. **`002-config-sub-preserve-thumb-target.patch`**: Modern
   `config.sub` maps `thumb` → `arm`, breaking GCC 2.95.3's separate
   Thumb backend (`thumb.c`/`thumb.md`). Fix: preserve `thumb` as a
   distinct CPU name.

Additionally, `config.guess` and `config.sub` are replaced with modern
versions (from `libtool`) so the build system recognizes x86_64 hosts.

## Source

- **GCC 2.95.3**: https://ftp.gnu.org/gnu/gcc/gcc-2.95.3/
- **License**: GPL (see `gcc-2.95.3/COPYING`)

## What's NOT here

This is a vanilla GCC 2.95.3 build. The original GBA SDK compiler had
additional Cygnus/ARM patches for improved Thumb code generation,
specific optimization behaviors, etc. During Phase 3, if we encounter
functions that don't match with this compiler, we may need to add
targeted patches to reproduce specific codegen quirks.
