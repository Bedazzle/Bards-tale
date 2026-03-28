# Magic System — Technical Guide

## Spell Point Costs

From `tables/93B0-93FE_spell_costs.asm`. Cost = SP deducted per cast.
**If you have an item with equip type 4, all costs are halved.**

### Conjurer (levels 1-7)
| L1 | L2 | L3 | L4 | L5 | L6 | L7 |
|----|----|----|----|----|----|-----|
| MAFL:2, ARFI:3, SOSH:3, TRZP:2 | FRFO:3, MACO:3, BASK:4, WOHL:4 | MAST:5, LERE:5, LEVI:4, WAST:5 | INWO:6, FLRE:6, POST:6 | GRRE:7, WROV:7, SHSP:7 | INOG:9, MALE:8 | FLAN:12, APAR:15 |

### Sorcerer
| L1 | L2 | L3 | L4 | L5 | L6 | L7 |
|----|----|----|----|----|----|-----|
| MIJA:3, PHBL:2, LOTR:2, HYIM:3 | DISB:4, TADU:4, MIFI:4, FEAR:4 | WIWO:5, VANI:6, SESI:6, CURS:5 | CAEY:7, WIWA:6, INVI:7 | WIOG:7, DIIL:8, MIBL:8 | WIDR:10, MIWP:9 | WIGI:12, SOSI:11 |

### Magician
| L1 | L2 | L3 | L4 | L5 | L6 | L7 |
|----|----|----|----|----|----|-----|
| VOPL:3, AIAR:3, STLI:2, SCSI:2 | HOWA:4, WIST:5, MAGA:5, AREN:5 | MYSH:6, OGST:6, MIMI:7, STFL:6 | SPTO:8, DRBR:7, STSI:7 | ANMA:8, ANSW:8, STTO:8 | PHDO:9, YMCA:10 | REST:12, DEST:14 |

### Wizard
| L1 | L2 | L3 | L4 | L5 | L6 | L7 |
|----|----|----|----|----|----|-----|
| SUDE:6, REDE:4 | LESU:8, DEBA:8 | SUPH:10, DISP:10 | PRSU:12, ANDE:11 | SPBI:14, DMST:13 | SPSP:15, BEDE:18 | GRSU:22 |

Wizard spells are the most expensive. GRSU (Greater Summoning) at 22 SP
is the costliest spell in the game.

## Light Spells — Duration & Range

From `tables/94D3-94DE_light_durations.asm` and `tables/94C7-94D2_range_values.asm`:

| Spell/Item | Duration (steps) | Range (tiles) |
|------------|-----------------|---------------|
| MAFL (Mage Flame) | 40 | 3 |
| LERE (Lesser Revelation) | 60 | 4 |
| GRRE (Greater Revelation) | 80 | 5 |
| CAEY (Cat Eyes) | 255 | 5 |
| STLI (Steelight) | 30 | 3 |
| STSI (Stonelight) | 60 | 5 |
| Torch | 28 | 2 |
| Lamp | 36 | 2 |

**CAEY (Cat Eyes) is the best light spell** — 255 duration effectively
means it lasts the entire dungeon run, with range 5.

## Reveal Spells — Duration

| Spell | Reveal Duration (steps) |
|-------|------------------------|
| LERE | 60 |
| GRRE | 80 |
| STSI | 60 |

MAFL, STLI, CAEY, Torch, and Lamp provide NO reveal capability.

## Summoned Creatures

From `tables/9556-9573_summon_creatures.asm`:

| Spell | Creature | Monster ID |
|-------|----------|------------|
| INWO (Instant Wolf) | Wolf | 16 |
| INOG (Instant Ogre) | Ogre | 29 |
| WIWA (Wind Warrior) | Mercenary | 15 |
| WIDR (Wind Dragon) | Red Dragon | 101 |
| WIGI (Wind Giant) | Storm Giant | 121 |
| SUDE (Summon Dead) | Skeleton or Zombie | 10 or 20 |
| LESU (Lesser Summon) | Lesser Demon | 78 |
| SUPH (Summon Phantom) | Ghoul or Wraith | 51 or 60 |
| PRSU (Prime Summon) | Demon | 95 |
| SPSP (Spell Sprite) | Lich or Spectre | 124 or 107 |
| GRSU (Greater Summon) | Greater Demon or Demon Lord | 111 or 126 |

**Wind Dragon and Wind Giant** are the strongest summons. **GRSU** can
summon a Demon Lord — arguably the most powerful ally in the game.

## Spell Duration System

Active spells have a 16-bit duration counter (`VAR_SPELL_DURATION`).
Each game turn, `tick_spell_duration` decrements it. At zero,
`process_special_event` fires to clean up the effect.

Spell state is tracked in dedicated tables:
- `SPELL_LIGHT_STATE` — light effects
- `SPELL_SHIELD_STATE` — Mystic Shield
- `SPELL_COMPASS_STATE` — Magic Compass
- `SPELL_CARPET_STATE` — Levitation
- `SPELL_EYE_STATE` — Scrying/Cat Eyes
- `SPELL_REVEAL_STATE` — Revelation
- `SPELL_SECRET_STATE` — Secret door reveal

## Anti-Magic Warning

`apply_anti_magic` clears ALL active spell effects. One anti-magic hit
from an enemy undoes every buff, every light spell, every shield. Rebuff
immediately after or you'll be fighting blind in the dark.
