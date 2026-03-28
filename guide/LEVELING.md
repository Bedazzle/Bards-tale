# Leveling & Progression — Technical Guide

## Experience Distribution

From `award_experience` ($7F79):

After combat, total XP is divided by the number of living party members.
Each hero gets an equal share. The routine also increments
`CHAR_WON_COMBATS` for each hero if the encounter type is 0x14.

```
xp_per_hero = total_xp / party_size
```

The division uses `calc_xp_thresholds` ($5C17) which loops through
a threshold table at $9815, counting how many boundaries the XP value
exceeds. This converts raw XP into a level tier.

## XP Per Class

From `calc_xp_for_level` ($76B9):

Each class has a different XP curve. The offset between classes is 13
positions in the XP table (index 0x49). Classes with higher offsets need
more XP per level.

**Wizards and multi-class characters** level the slowest because their
XP requirements are highest. Warriors level fastest.

## Level Up — The Review Board

You MUST visit the Review Board (`proc_reviewbord` at $E91D) to level up.
XP accumulates automatically, but the actual level increase only happens
at the Review Board via `do_advancement` ($E950).

The Review Board also handles:
- **Spell acquisition** (`do_spell_acquire` at $EA55) — learn new spell
  levels as you meet the requirements
- **Class change** (`do_class_change` at $EACE) — switch to a new class,
  keeping your current spells

## Stat Growth

Character stats are packed in `CHAR_PARAMS_HI` and `CHAR_PARAMS_LO`.
The low 5 bits of `CHAR_PARAMS_LO` are used for level-dependent
calculations throughout the code:

```asm
ld  a, (ix+CHAR_PARAMS_LO)
and 1Fh                      ; mask low 5 bits
sub 0Fh                      ; subtract 15
```

This appears in `calc_combat_initiative`, `calc_armor_class`, and
`calc_attack_damage` — it's a stat modifier that affects combat,
defense, and damage based on your base attributes.

## HP and SP Regeneration

From `regenerate_hp_sp` ($7DB8):

Each turn, the game checks every hero's current HP/SP against their max.
If current < max, it increments by 1. This is slow natural regen.

`regen_equipped_effects` ($7DF9) provides faster regen from items:
- Items with equip type 2: regenerate HP
- Items with equip type 1: regenerate SP
- Both check via `CHECK_EQUIPPED` and call the regen loop

## Max Values

- Max level: stored as 16-bit (`CHAR_MAXLEVEL_HI/LO`)
- Max HP: stored as 16-bit (`CHAR_HITS_HI/LO`) — max 65,535
- Max SP: stored as 16-bit (`CHAR_SPPT_MAX_HI/LO`) — max 65,535
- Max gold: 12-digit BCD — max 999,999,999,999
- Max XP: 12-digit BCD — max 999,999,999,999
- Max AC: capped at 21 in code (`cp 15h`)
- Max attacks per round: `CHAR_ATT_ROUND` (1 byte, max 255)

## Optimal Leveling Strategy (from the code)

1. **Monks scale hardest** — their AC and damage both grow with level,
   no gear needed. Every level makes them exponentially better.

2. **Multi-class for spells** — class change preserves spell levels.
   Start as one caster, level up, change class, repeat. End up with
   all 4 spell classes on one character.

3. **Combat wins matter** — `CHAR_WON_COMBATS` feeds into initiative
   calculation. More fights = faster turns. Grind early.

4. **Party size affects XP** — smaller parties get more XP per hero.
   A 3-person party levels nearly twice as fast as a 6-person party.
   But you need 6 for survivability. Balance accordingly.
