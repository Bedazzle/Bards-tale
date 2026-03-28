# Bard's Tale ZX Spectrum — Architecture

## Memory Map

```
$0000-$3FFF  ROM (ZX Spectrum OS)
$4000-$57FF  Screen bitmap (6144 bytes)
$5800-$5AFF  Screen attributes/colors (768 bytes)
$5B00-$5B02  JP INIT_GAME (entry point)
$5B03-$5B7C  Main game loop + key handling
$5B7D-$5FAA  Core routines (print, input, buffers)
$5FAB-$6022  Game variables block (120 bytes, IY-relative)
$6023-$8DB4  Game engine (combat, spells, items, rendering)
$8DB5-$8F0C  Spell name strings
$8F0D-$8F4D  Lookup tables (monster stats, item effects)
$8F4E-$9272  Monster data (names + stats)
$9273-$95BE  Spell/item tables (costs, types, ranges, etc.)
$95BF-$97DD  Item data table
$97DE-$9AB6  Display data + icons + beeper
$9AB7-$A585  Text data (letters, messages, words)
$A586-$BFE1  Compressed text + data
$BFE2-$C18B  Print routines (message rendering)
$C18C-$FA9A  Level data (city of Skara Brae) — SWAPPABLE
$FA9B-$FFFF  Buffers, font, stack, loader
```

The region `$C18C-$FA9A` is swappable — different dungeon levels load into
this space, replacing the city data. The core engine (`$5B00-$C18B`) stays
resident.

## RST 10h Dispatch System

The game uses Z80's `RST 10h` instruction as a universal function call
mechanism. Instead of `CALL address`, most routines are invoked via:

```asm
rst  10h
db   <function_id>    ; 0x00-0x61
db   <param1>         ; optional
db   <param2>         ; optional
```

The `RST 10h` handler at address `$0010` (in ROM, patched) reads the byte
after the RST instruction, looks it up in a dispatch table at
`tables/8C09-8CCC_procs_buffer.asm`, and jumps to the corresponding routine.

This is wrapped in macros (`code/macroses.asm`) for readability:

| Macro | ID | Actual routine |
|-------|-----|----------------|
| `FIND_HERO_BY_B` | 15h | Locates hero by index, sets IX |
| `GET_ATTR_BY_PARAM` | 17h | Reads character attribute by offset |
| `GET_GAME_VARIABLE` | 19h | Reads IY-relative game variable |
| `SELECT_TARGET` | 30h | Interactive combat target selection |
| `ROLL_DAMAGE` | 48h | Rolls damage dice |
| `RECALC_ALL_AC` | 4Ah | Recalculates all party AC values |
| `CHECK_ITEM_MASK` | 61h | Checks item effect against bitmask |

Parameters are encoded as inline bytes following the function ID. The
dispatch handler uses `get_param_to_A` to read them from the return
address on the stack.

## Character Struct (100 bytes at IX)

```
Offset  Name              Size  Description
------  ----              ----  -----------
$00-$0F CHAR_NAME         16    Character name (null-terminated)
$10     CHAR_PARAMS_HI    1     Packed parameters (high)
$11     CHAR_PARAMS_LO    1     Packed parameters (low, bits 0-4 used)
$12     CHAR_SPEED        1     Speed stat (affects initiative + defense)
$13     CHAR_SAVED_STATS  1     Saved stats (used during possession)
$14-$1F CHAR_EXP          12    Experience (12-digit BCD)
$15     CHAR_ATTACK_SPEC  1     Attack specification (damage dice encoding)
$16     CHAR_DEFENSE_SPEC 1     Defense specification
$17     CHAR_SPECIAL_FLAG 1     Special combat flag
$20-$21 CHAR_MAXLEVEL     2     Maximum level (hi/lo)
$22-$23 CHAR_LEVEL        2     Current level (hi/lo)
$24-$2F CHAR_GOLD         12    Gold (12-digit BCD)
$30-$31 CHAR_HITS         2     Max hit points (hi/lo)
$32-$33 CHAR_COND         2     Current hit points (hi/lo)
$34-$35 CHAR_SPPT_MAX     2     Max spell points (hi/lo)
$36-$37 CHAR_SPPT         2     Current spell points (hi/lo)
$38     CHAR_CLASS        1     Class (0=Warrior..9=Monk, 0Ah=Party)
$39     CHAR_RACE         1     Race (0=Human..6=Gnome)
$3C-$3D CHAR_WON_COMBATS  2     Combats won (hi/lo)
$3E     CHAR_STATUS       1     Status (0=OK, 1=Poisoned..7=Nuts)
$3F     CHAR_NATURAL_AC   1     Computed armor class (0-21)
$40     CHAR_SORC_LEVEL   1     Sorcerer spell level
$41     CHAR_CONJ_LEVEL   1     Conjurer spell level
$42     CHAR_MAGI_LEVEL   1     Magician spell level
$44     CHAR_ROGUE_DISARM 1     Rogue: disarm trap chance
$45     CHAR_ROGUE_DETECT 1     Rogue: detect trap chance
$46     CHAR_ROGUE_HIDE   1     Rogue: hide in shadows chance
$48     CHAR_HUNTER_CHANCE 1    Hunter: critical hit chance
$49     CHAR_BARD_SONGS   1     Bard: remaining songs
$4D     CHAR_NEG_FLAG     1     Negative/special flag
$4E     CHAR_FORMER_HEALTH 1    Former health (for ally tracking)
$4F     CHAR_ATT_ROUND    1     Attacks per round
$50-$5F CHAR_INVENTORY    16    8 item slots (2 bytes each: state + ID)
$60     CHAR_BACKUP_PARAMS 1    Backup params (class change)
$63     CHAR_SWAP_STATS   1     Swap stats (possession)
$64     CHAR_POS_IN_PARTY 1     Position in party (0-5)
```

## Enemy Struct

```
Offset  Name              Description
------  ----              -----------
$00     ENEMY_ALIVE       Non-zero if enemy group exists
$10     ENEMY_ACTIVE_FLAG Active in current combat round
$11     ENEMY_COMBAT_DATA Start of combat stat block
$15     ENEMY_SPEED       Speed (for initiative calculation)
$16     ENEMY_ATTACK_SPEC Attack specification
$17     ENEMY_SPECIAL_FLAG Special abilities flag
$31     ENEMY_HITS        Hit points
$33     ENEMY_COND        Current condition/HP
$38     ENEMY_CLASS       Class type
```

## Combat Flow

```
encounter detected (random or scripted)
    |
    v
generate_encounter → populate enemy groups (up to 4)
    |
    v
calc_combat_initiative → determine turn order per class
    |
    v
battle_options → for each hero: Attack/Defend/Cast/Hide/Song
    |
    v
fight_or_run → can party flee? (speed comparison)
    |
    v
resolve actions:
    hero attacks → calc_attack_damage → apply_damage_to_group
    hero casts   → check_spell_valid → resolve_spell_effect
    enemy attacks → calc_enemy_attack → apply_damage_to_hero
    |
    v
post_combat_cleanup → remove dead, award_experience
```

## Spell System

Spells are identified by 4-letter codes typed by the player (e.g. MAFL, ARFI).
The code is looked up in `tables/8DB5-8F0C_spell_names.asm`, which gives an
index into the spell cost, type, and effect tables.

Spell effects are dispatched through the address table system — each spell
type maps to a handler routine:
- Type 0: `spell_breath_attack` (area damage)
- Type 1: `spell_heal_and_cure`
- Type 2: `spell_stat_modifiers`
- Type 3: `spell_summon_monster`
- Type 4: `spell_ac_modifier`
- Type 5: `spell_reveal_secret`
- Type 6: `spell_flee_effect`

Active spells have a duration tracked by `VAR_SPELL_DURATION` (16-bit counter),
decremented each turn by `tick_spell_duration`. State is stored in the spell
state tables (`SPELL_LIGHT_STATE`, `SPELL_SHIELD_STATE`, etc.).

## 3D Rendering

The city/dungeon view is rendered by three routines:
1. `render_3d_view` — calculates view coordinates from player position and
   facing direction, maps to city grid
2. `display_walls_creatures` — iterates through 8 depth layers, decoding
   wall/creature presence at each distance
3. `render_sprite_3d` — RLE-decodes sprite data and draws to screen buffer

View offsets are stored in `VAR_VIEW_Y_OFFSET` and `VAR_VIEW_X_OFFSET`,
updated on each movement/turn by the movement handler.
