# Global Rules — Iguana Monorepo

These rules apply to **every game folder** and **every phase of work**
in this repository. Read them before touching any `games/<name>/`
directory.

---

## 1. Original-ROM-Only Policy

Every game starts from **only the ROM file** the user provides. Never
clone or copy source from existing decompilation projects for that game
(e.g. `pret/pokefirered` for FireRed, or any equivalent for a future
title).

Acceptable to consult:
- Public RE documentation and hardware specs.
- Non-code reference data (species names, stats, etc.) used only to
  *verify* results.

Not acceptable:
- Copying decompiled C, assembly, or data layouts from another project.

## 2. No ROM Downloads

Never search for or download ROMs from the internet. The user supplies
their own legally-obtained dump per game, placed at
`games/<name>/baserom.<ext>` (gitignored).

## 3. Match Proof Required

Every claimed "match" must be proven by an automated byte-diff against
the original ROM (`make compare` or equivalent). Never assert a match
from visual inspection alone.

## 4. Reuse Shared Runtime Layers

Before starting a new game folder, check whether its source console
already has a `runtime/<family>-native/` layer in this repo. If yes,
reuse it instead of writing a new platform layer from scratch.

## 5. One Phase at a Time

Work one phase at a time per game (see `docs/roadmap-template.md`).
Don't skip ahead to native porting before the matching-decompilation
phases for that game are far enough along to support it.

## 6. Session Handoff

- At the start of a session, state which game and which phase you're
  continuing (e.g. "games/firered, Phase 3, runtime lib done, starting
  on the task system").
- Require a `make compare` run as proof at the end of every unit of
  work, not just a verbal "done."
- Keep `games/<name>/ROADMAP.md` updated at the end of every session —
  this is the persistent memory of progress across sessions.
