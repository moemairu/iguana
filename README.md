# Iguana

Multi-game native decompilation port monorepo.

One repository housing multiple from-scratch console game decompilation
ports, each targeting native desktop execution (Linux first, Windows
later). Each game lives in its own folder under `games/`, sharing common
tooling and — where the target hardware matches — a shared native
runtime/platform layer.

## Repository Layout

```
repo-root/
├── AGENTS.md                 # global rules — read before touching any game folder
├── README.md
├── docs/
│   └── roadmap-template.md   # the phase pipeline every game follows
├── tools/                    # shared, console-agnostic RE utilities
│   ├── ghidra-scripts/
│   ├── permuter-wrapper/
│   └── build-compare/        # generic "assemble + diff against original ROM" helper
├── runtime/                  # shared native platform layers, one per source hardware family
│   ├── gba-native/           # SDL2/OpenGL-backed platform layer for GBA-sourced games
│   └── gb-native/            # placeholder for Game Boy-family ports
└── games/
    ├── firered/              # Pokémon FireRed (GBA)
    │   ├── ROADMAP.md
    │   ├── asm/
    │   ├── src/
    │   ├── data/
    │   ├── include/
    │   └── Makefile
    └── <next-game>/          # same skeleton, new source ROM
```

### Where things go

| Location | Contents |
|---|---|
| `tools/` | Anything that doesn't know or care which game it's analyzing (Ghidra automation, permuter wrapper, generic ROM/ELF diff scripts). |
| `runtime/<family>-native/` | Platform code shared by every game on the same source hardware (e.g. all GBA games share BIOS-call emulation, PPU-to-SDL2 rendering, audio mixer). |
| `games/<name>/` | Everything specific to one ROM — matching progress, extracted data, game-specific glue code. |

## Getting Started

1. Place your legally-obtained ROM at `games/<name>/baserom.<ext>`.
2. Read `AGENTS.md` for global rules.
3. Read `games/<name>/ROADMAP.md` for per-game phase progress.
4. See `docs/roadmap-template.md` for the generalized phase pipeline.

## Current Games

| Game | Console | Status |
|---|---|---|
| Pokémon FireRed | GBA | Phase 0 — Toolchain Setup |

## License

TBD
