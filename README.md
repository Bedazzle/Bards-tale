# The Bard's Tale (ZX Spectrum) — Reverse Engineered Source

A reverse-engineered Z80 assembly source for **The Bard's Tale** (1988 ZX Spectrum port
by Electronic Arts). Originally disassembled 2020-2022, now compilable and runnable on
modern hardware.

The compiled binary is **byte-identical** to the original game — this is the real deal,
rebuilt from source.

## Running on macOS (Apple Silicon)

### Prerequisites

1. **SjASMPlus** (Z80 cross-assembler) — build from source:

```bash
git clone --recursive -j8 https://github.com/z00m128/sjasmplus.git /tmp/sjasmplus
cd /tmp/sjasmplus && make -j$(sysctl -n hw.ncpu)
sudo cp /tmp/sjasmplus/sjasmplus /usr/local/bin/
```

2. **Fuse for macOS** (ZX Spectrum emulator, native ARM64):

Download from https://fuse-for-macosx.sourceforge.io/ — drag to Applications.

### Build and Play

```bash
make            # compiles and verifies binary matches original
```

Then open Fuse and load `recompile/bt.tap` via **File > Open**.

### Controls

| Key | Action |
|-----|--------|
| I | Move forward |
| K | Kick door / move back |
| J | Turn left |
| L | Turn right |
| 1-6 | Select party member |
| Esc | Back / cancel |

#### In Combat

| Key | Action |
|-----|--------|
| A | Attack foes |
| P | Party attack (auto) |
| D | Defend |
| C | Cast spell (type 4-letter code, e.g. MAFL) |
| H | Hide in shadows (Rogue only) |
| B | Bard song (Bard only) |

#### Character Screen

| Key | Action |
|-----|--------|
| E | Equip item |
| T | Trade gold |
| D | Drop item |
| P | Pool gold |
| N | New order (rearrange party) |
| Esc | Exit to street |

### Spell Codes (Starter Spells)

| Code | Spell | Class | Effect |
|------|-------|-------|--------|
| MAFL | Mage Flame | Conjurer L1 | Light in dungeons |
| ARFI | Arc Fire | Conjurer L1 | Damage one group |
| FLAN | Flesh Anew | Conjurer L1 | Heal one character |
| TRZP | Trap Zap | Conjurer L1 | Disarm traps |
| SOSH | Sorcerer Shield | Sorcerer L1 | AC bonus |
| MAST | Mage Star | Sorcerer L2 | Better light |

Full manual (PDF): https://spectrumcomputing.co.uk/zxdb/sinclair/entries/0000418/BardsTaleThe(EN).pdf

## How to Play

1. Start at the **Adventurer's Guild** — create characters and add them to your party
2. Walk out into **Skara Brae** using I/J/K/L
3. Fight random encounters to earn XP and gold
4. Visit the **Review Board** to level up
5. Visit **Temples** to heal, **Shoppes** to buy gear
6. Brave the dungeons when you're ready

Front 3 party members can melee attack; back 3 are casters/support only.

## Project Structure

```
BT_main.asm          — Entry point, loader, memory layout
BT_game.asm          — Master include file for all game code
constants.asm        — Game constants (classes, races, statuses, etc.)
code/                — Disassembled game routines (~170 files)
data/                — Game data (monsters, messages, variables)
tables/              — Lookup tables (spells, items, actions)
gfx/                 — Graphics (icons, font)
levels/city/         — City of Skara Brae level data and code
original/            — Original memory dumps for verification
tools/               — Build tools (binary diff, tape library)
recompile/           — Build output (generated, not committed)
```

## Reverse Engineering Status

The disassembly is **structurally complete** — every byte from `$5B00` to `$FFFF` is
accounted for. Of the ~170 code routines:

- **~107 identified** — named and understood (e.g. `fight_or_run`, `process_spell`,
  `create_char`)
- **~85 unidentified** — labeled `___UNKNOWN`, code works but purpose not yet documented

See [ROADMAP.md](ROADMAP.md) for the plan to complete the reverse engineering.

## References

- [World of Spectrum — The Bard's Tale](https://worldofspectrum.org/archive/software/games/the-bards-tale-electronic-arts)
- [Spectrum Computing — The Bard's Tale](https://spectrumcomputing.co.uk/entry/418/ZX-Spectrum/The_Bards_Tale)
- [The Tipshop — The Bard's Tale](https://www.the-tipshop.co.uk/cgi-bin/info.pl?name=Bard%27s%20Tale%2c%20The)
- [Bard Tales Service Utility](https://worldofspectrum.org/archive/software/utilities/bard-tales-service-childrens-infatuated-computers)
- [SjASMPlus Assembler](https://github.com/z00m128/sjasmplus)
- [Fuse for macOS](https://fuse-for-macosx.sourceforge.io/)
