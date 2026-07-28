# Build-Compare

Generic "assemble + diff against original ROM" helper. Each game's
`make compare` target delegates to this tool for the actual byte-level
comparison.

## Usage

```bash
# Compare a built ROM against the original
./compare.sh <built.gba> <baserom.gba>
```

Scripts in this directory are console-agnostic. They operate on raw
binary files and report byte offsets of any differences.
