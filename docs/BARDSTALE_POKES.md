# The Bard's Tale (ZX Spectrum) — POKEs & cheats reference

Useful runtime POKEs for the ZX Spectrum *The Bard's Tale*, derived from this byte-exact
disassembly. Each entry gives the exact address, the original byte, the new byte, and **why**
it works (with a pointer to the source), so it can be trusted and maintained.

**Which build these addresses target.** The game code loads at **`$5B00`** (the disassembly's
`BT_main.asm` → `org $5B00`, verified byte-identical to the original `game_5B00-FFFF.mem`).
Addresses below are absolute in that loaded image. If you apply pokes from a BASIC loader before
`RANDOMIZE USR`, use the same layout; from a snapshot/emulator, poke the running memory directly.

**How the pokes were found.** Each is traced to a specific instruction in the disassembly and,
where noted, confirmed dynamically in the ZX-M8XXX emulator (`tools/m8xxx/combat_trace.html`).

---

## Encounters

### Force a city encounter on every step ("always fight")
| Address | Original | Poke | Effect |
|---|---|---|---|
| `$5B19` | `$3F` | `$00` | first city-ambush dice mask → always 0 |
| `$5B1E` | `$3F` | `$00` | second city-ambush dice mask → always 0 |

**Why.** `game_cycle` (`code/5B03-5B3D__game_cycle.asm`) rolls the random-encounter dice while you
walk Skara Brae:

```
GET_RND_BY_PARAM $3F        ; $5B17: rst 10h / db $60 / db $3F   (operand at $5B19)
jr nz,no_city_ambush
GET_RND_BY_PARAM $3F        ; $5B1C: rst 10h / db $60 / db $3F   (operand at $5B1E)
jr nz,no_city_ambush
city_ambush:  ... call combat_foes
```

`GET_RND_BY_PARAM n` returns `RND & n`. An ambush needs **both** rolls to be 0 — normally `$3F & RND`
(1-in-64) twice = **1-in-4096** per step. Poking both masks to `$00` makes `RND & 0 = 0` every time,
so **every step triggers a real encounter**. (Confirmed in-emulator: immediate "Thieves" encounter,
2 enemy groups, `generate_encounter` builds real monsters.)

> **Gotcha for tool authors:** do *not* also force `VAR_AMBUSH_FLAG` (`GAME_VARIABLES+$5A`, i.e.
> `$6005`) — its sense is inverted. A genuine city ambush leaves it **0**, and `generate_encounter`
> does `GET VAR_AMBUSH_FLAG / jr nz,.clear_loop`, so a **non-zero** flag *skips* enemy generation and
> yields an empty (instant-win) combat. The two dice pokes above are all you need.

### Disable random city monsters ("no monsters")

| Address | Original | Poke | Effect |
|---|---|---|---|
| `$5B1A` | `$20` (`jr nz`) | `$18` (`jr`) | first ambush branch always skips → never fight |

**Why.** The `jr nz,no_city_ambush` after the first dice roll sits at `$5B1A` (opcode `$20`, offset
`$0F` at `$5B1B`). Changing it to `$18` (unconditional `jr`) makes it *always* jump to
`no_city_ambush`, so the `city_ambush` path is never reached. This is the runtime equivalent of the
author's build-time `DEFINE NOCITYMONSTERS` in `BT_main.asm`.

---

## Build-time cheats (compile switches, for reference)

`BT_main.asm` carries commented-out `DEFINE`s the author used while developing. These are **assembly
switches**, not runtime pokes — uncomment and rebuild (`_compile_bt.bat`) to bake them in. Listed here
so the corresponding logic can be found for anyone wanting the runtime-poke equivalent:

| DEFINE | Effect |
|---|---|
| `KILLERS` | party hits hard / enemies die fast |
| `MAXEXPIRIENCE` | max experience |
| `MAXGOLD` | max gold |
| `MAXLEVEL` | max character level |
| `MAXSPLEVEL` | max spell level |
| `MAXSPPOINTS` | max spell points |
| `NOCITYMONSTERS` | disable random city ambushes (see above) |

---

## Handy in-game variable addresses (GAME_VARIABLES = `$5FAB`)

These are live game state (IY-relative in code, `iy = $5FAB`), useful for pokes/inspection. Full list
in `constants.asm` (`VAR_*` offsets). A few high-value ones:

| Address | Var | Meaning |
|---|---|---|
| `$5FAB` | `VAR_PARTY_SIZE` (+$00) | number of party members |
| `$5FAC` | `VAR_COORD_SO_NO` (+$01) | south/north position |
| `$5FAD` | `VAR_COORD_WE_EA` (+$02) | west/east position |
| `$5FAE` | `VAR_FACE_DIRECTION` (+$03) | facing (0=N,1=E,2=S,3=W) |
| `$5FB2` | `VAR_DUNGEON_LEVEL` (+$07) | current dungeon level |
| `$FB98` | `COMBAT_ACTIVE_FLAG` | non-zero while a fight is in progress |

Hero records: `HEROES = $5C83`, **101 (`$65`) bytes** per record, name at offset 0; `CHAR_*` field
offsets in `constants.asm`. The built-in default party (Brian the Fist, El Cid, Samson, Markus,
Merlin, Omar) lives at `BRIAN`..`OMAR` in `data/5C83-5FAA__heroes.asm`.

---

## Adding a poke to this file

Only add **verified** entries. For each: give the address + original/new byte, quote the exact source
instruction (file + label) it changes, and state the effect. If you confirmed it dynamically, say so
and how. When in doubt, describe what you know and mark it unverified rather than guessing.
