# Items & Equipment — Technical Guide

## Inventory System

Each character has 8 item slots (2 bytes each: state + item ID).

Item states:
- `0` = empty slot
- `1` = equipped
- `2` = unequipped (in inventory but not worn)

### Equip Eligibility

When you pick up an item, `add_item_to_hero` ($7639) checks a class
eligibility table (`ITEM_EQUIP`). Each item has a bitmask — if your
class bit isn't set, the item goes in as state `2` (can't equip).

### Item Breakage

From `use_and_break_item` ($75A5):
- Items with value < 0x30 (48) have a **1 in 64** chance of breaking on use
- Items with value >= 0x30 **never break**
- Breakage is checked every time you use the item in combat
- Rare items are safe; common items are fragile

## Weapon Damage

Weapon damage is encoded in `WEAPON_DAMAGE` table. Each weapon has:
- **Damage dice:** how many sides (encoded as bit shifts)
- **Number of rolls:** from `CHAR_ATT_ROUND`
- **Bonus:** from `WEAPON_BONUS` table (flat addition per hit)

The damage formula per attack:
```
damage = (random(0-mask) + 1) * rolls + weapon_bonus
```

### Special Attack Types

From `ITEM_SPECATT` table, each item has a special attack nibble:

| Type | Effect |
|------|--------|
| 1 | Standard attack |
| 2 | Fire damage |
| 3 | Cold damage |
| 4 | Electrical damage |
| 5 | Mind attack |
| 6 | Bard instrument (enables songs) |
| 7 | Critical strike bonus |
| 8 | Drain |
| 9 | Poison |
| 10 | Stone |
| 0x11 | Special summon |

### Bard Instruments

The Bard's "(B)ard Song" option only appears if they have an item with
special attack type 6 equipped. From `battle_options` ($68AD):
```asm
call  loc_6D05     ; find_special_weapon (type 6)
jr    c, select_option   ; no instrument → skip song option
```
If you sell/drop your Bard's instrument, they lose the ability to sing
in combat until they get another one.

## Equipment That Halves Spell Cost

From `spend_spell_points` ($794D):
```asm
CHECK_EQUIPPED  4    ; check for equip type 4
jr c, decrease_spell_points
srl c                ; halve the cost!
```

Any item with equip type 4 halves ALL spell point costs. This is
one of the most powerful items in the game — prioritize finding one
for your spellcasters.

## Trading and Gold

- **Trade gold:** transfers gold between party members
- **Pool gold:** combines all party gold to one hero
- Gold is stored as 12-digit BCD — max 999,999,999,999 per character
- The BCD math routines (`increas_12_digits`, `decreas_12_digits`) handle
  addition and subtraction with proper decimal carry
