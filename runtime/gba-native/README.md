# GBA Native Runtime

SDL2/OpenGL-backed platform layer for any ARM7TDMI/GBA-sourced game.
Shared by all GBA games in the monorepo.

## Responsibilities

- BIOS call emulation (SWI handlers)
- Hardware register abstraction (PPU, DMA, timers, interrupts)
- PPU-to-SDL2 rendering pipeline
- Audio mixer (GBA sound channels → host audio)
- Input mapping (GBA buttons → keyboard/gamepad via SDL2)

## Status

**Not yet implemented.** Will be built during Phase 4 of the first GBA
game to reach that stage.
