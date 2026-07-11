# ZX-M8XXX headless execution-map harness (level code/data mapping)

Records which overlay addresses **execute** (code) vs are only **read** (data) while the
game runs, using ZX-M8XXX's auto memory mapper headless via Edge. See the skill reference
`reference/m8xxx-automap.md`.

## What it does (`automap.html`)
1. Loads the 48K ROM (`spectrum.loadRom('roms/48.rom')`) and waits for it — **required**,
   or the emulator has a blank `$0000-$3FFF` and everything NOP-sleds.
2. Boots the authentic tape `The Bard's Tale - Tape 1 - Side 1.tzx` via
   `zx.autoLoad({type:'tape', isTzx:true})`, then `cpu.pc=0x5B00` → the **Guild** screen.
3. Presses `E` → **Skara Brae 3D view** (the movement/render state).
4. Overlays `original/levels/level_02.bin` at `$C18C` (the game's location label flips to
   **"Cellars"** and it runs the level-2 handlers).
5. `zx.enableMap(true,{fast:true})`, drives I/J/K/L movement, reads `zx.mapBits()`; reports
   exec/read counts + coalesced exec ranges over `$C18C-$FB50`, and a screenshot.

## Run
```
cd C:\Backa\projects\ZX-M8XXX && python serve.py 8123 &
# stage (ABSOLUTE paths — cwd resets between shell calls):
cp "<tapes>/The Bard's Tale - Tape 1 - Side 1.tzx"  C:\Backa\projects\ZX-M8XXX\_bard_t1s1.tzx
cp original/levels/level_02.bin                     C:\Backa\projects\ZX-M8XXX\_level_02.bin
cp tools/m8xxx/automap.html                         C:\Backa\projects\ZX-M8XXX\_automap.html
msedge.exe --headless --disable-gpu --no-first-run --mute-audio \
  --user-data-dir=C:/tmp/edge_map --virtual-time-budget=240000 --dump-dom \
  "http://localhost:8123/_automap.html" > dom.html
awk '/RESULT_START/{f=1;next} /RESULT_END/{f=0} f' dom.html   # the JSON map
```

## Result (2026-07-10) — validates the disassembly
Saved to `levels/level_02/EXECMAP.json`. Executed = code, read-only = data:
- `$D1D8-$DC51` handlers: **687 bytes executed** → CODE (matches the carve; the exec ranges
  also recovered computed-dispatch code static flow-descent missed — fed back as seeds to
  `tools/level_disasm.py`, raising coverage 1666 → 1874 bytes, still byte-exact).
- `$E6A8-$F2E9`: **0 executed**, read-only → DATA (confirms it's graphics, not the "tail
  handlers" Ghidra mislabeled).
- maze `$F2EA-$F6B1`: **0 executed, 24 read** → DATA read during movement.

## Notes / traps (see skill reference for detail)
- **Merged `BARDTALE.TAP` fails M8XXX's parser** (custom short-header blocks) → use the `.tzx`.
- A **missing staged file** fetches the server 404 page → "Failed to parse" — verify staging.
- Prior "can't reconstruct a runnable snapshot from the `.mem` dump" conclusion was WRONG:
  the fix was loading the ROM + booting the real tape (the loader builds `$0000-$3FFF`).
- To exercise more handlers (chest/trap/encounter/stairs), extend the driven key sequence
  or drive into a real Cellars encounter; the map only ever covers what actually ran.
