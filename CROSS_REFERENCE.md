# Bard's Tale ZX Spectrum — Cross-Reference Map

## Spell Code → Effect Handler

Each spell is a 4-letter code typed by the player. The code maps to a spell
type, which dispatches to one of 8 handler routines.

### Conjurer Spells
| Level | Code | Spell | Handler |
|-------|------|-------|---------|
| 1 | MAFL | Mage Flame | light setup |
| 1 | ARFI | Arc Fire | `spell_breath_attack` |
| 1 | SOSH | Sorcerer Shield | `spell_stat_modifiers` |
| 1 | TRZP | Trap Zap | `spell_reveal_secret` |
| 2 | FRFO | Freeze Foes | `spell_stat_modifiers` |
| 2 | MACO | Magic Compass | compass setup |
| 2 | BASK | Battleskill | `spell_stat_modifiers` |
| 2 | WOHL | Word of Healing | `spell_heal_and_cure` |
| 3 | MAST | Mage Star | light setup |
| 3 | LERE | Lesser Revelation | `spell_reveal_secret` |
| 3 | LEVI | Levitation | levitation setup |
| 3 | WAST | Warstrike | `spell_breath_attack` |
| 4 | INWO | Incinerate | `spell_breath_attack` |
| 4 | FLRE | Flesh Restore | `spell_heal_and_cure` |
| 4 | POST | Poison Strike | `spell_breath_attack` |
| 5 | GRRE | Greater Revelation | `spell_reveal_secret` |
| 5 | WROV | Wrath of Valhalla | `spell_breath_attack` |
| 5 | SHSP | Shock Sphere | `spell_breath_attack` |
| 6 | INOG | In'ognito | `spell_stat_modifiers` |
| 6 | MALE | Major Levitation | levitation setup |
| 7 | FLAN | Flesh Anew | `spell_heal_and_cure` |
| 7 | APAR | Apport Arcane | teleport |

### Sorcerer Spells
| Level | Code | Spell | Handler |
|-------|------|-------|---------|
| 1 | MIJA | Mangar's Mind Jab | `spell_breath_attack` |
| 1 | PHBL | Phase Blur | `spell_stat_modifiers` |
| 1 | LOTR | Locate Traps | `spell_reveal_secret` |
| 1 | HYIM | Hypnotic Image | `spell_stat_modifiers` |
| 2 | DISB | Disbelieve | `spell_stat_modifiers` |
| 2 | TADU | Target Dummy | `spell_summon_monster` |
| 2 | MIFI | Mind Fist | `spell_breath_attack` |
| 2 | FEAR | Word of Fear | `spell_flee_effect` |
| 3 | WIWO | Wind Wolf | `spell_summon_monster` |
| 3 | VANI | Vanish | `spell_stat_modifiers` |
| 3 | SESI | Second Sight | eye setup |
| 3 | CURS | Curse | `spell_stat_modifiers` |
| 4 | CAEY | Cat Eyes | eye setup |
| 4 | WIWA | Wind Warrior | `spell_summon_monster` |
| 4 | INVI | Invisibility | `spell_stat_modifiers` |
| 5 | WIOG | Wind Ogre | `spell_summon_monster` |
| 5 | DIIL | Disrupt Illusion | `spell_stat_modifiers` |
| 5 | MIBL | Mind Blade | `spell_breath_attack` |
| 6 | WIDR | Wind Dragon | `spell_summon_monster` |
| 6 | MIWP | Mind Warp | `spell_breath_attack` |
| 7 | WIGI | Wind Giant | `spell_summon_monster` |
| 7 | SOSI | Sorcerer Sight | eye setup |

### Magician Spells
| Level | Code | Spell | Handler |
|-------|------|-------|---------|
| 1 | VOPL | Vorpal Plating | `spell_ac_modifier` |
| 1 | AIAR | Air Armor | `spell_stat_modifiers` |
| 1 | STLI | Star Light | light setup |
| 1 | SCSI | Scry Site | `spell_reveal_secret` |
| 2 | HOWA | Holy Water | `spell_breath_attack` |
| 2 | WIST | Wither Strike | `spell_breath_attack` |
| 2 | MAGA | Mage Gauntlets | `spell_attack_bonus` |
| 2 | AREN | Area Enchant | `spell_ac_modifier` |
| 3 | MYSH | Mystic Shield | shield setup |
| 3 | OGST | Ogre Strike | `spell_breath_attack` |
| 3 | MIMI | Mind Mist | `spell_breath_attack` |
| 3 | STFL | Star Flare | light setup |
| 4 | SPTO | Spell Thwart | `spell_stat_modifiers` |
| 4 | DRBR | Dragon Breath | `spell_breath_attack` |
| 4 | STSI | Star Sight | `spell_reveal_secret` |
| 5 | ANMA | Anti-Magic | `spell_stat_modifiers` |
| 5 | ANSW | Animate Sword | `spell_summon_monster` |
| 5 | STTO | Stone Touch | `spell_breath_attack` |
| 6 | PHDO | Phase Door | teleport |
| 6 | YMCA | YMCA | `spell_heal_and_cure` |
| 7 | REST | Restoration | `spell_heal_and_cure` |
| 7 | DEST | Destruction | `spell_breath_attack` |

### Wizard Spells
| Level | Code | Spell | Handler |
|-------|------|-------|---------|
| 1 | SUDE | Summon Dead | `spell_summon_monster` |
| 1 | REDE | Resurrect Dead | `spell_heal_and_cure` |
| 2 | LESU | Lesser Summon | `spell_summon_monster` |
| 2 | DEBA | Death's Barrier | `spell_stat_modifiers` |
| 3 | SUPH | Summon Phantom | `spell_summon_monster` |
| 3 | DISP | Dispossess | `spell_stat_modifiers` |
| 4 | PRSU | Prime Summon | `spell_summon_monster` |
| 4 | ANDE | Animate Dead | `spell_summon_monster` |
| 5 | SPBI | Spectre Bind | `spell_summon_monster` |
| 5 | DMST | Death Strike | `spell_breath_attack` |
| 6 | SPSP | Summon Spirit | `spell_summon_monster` |
| 6 | BEDE | Beyond Death | `spell_heal_and_cure` |
| 7 | GRSU | Greater Summon | `spell_summon_monster` |

## City Location Dispatch

When the player enters a building, the city map tile value is looked up in
the location dispatch table:

| Location | Handler | File |
|----------|---------|------|
| Empty building | `proc_empty_building` | `ED0D-ED2C` |
| Adventurer's Guild | `proc_guild` | `E747-E7A8` |
| Tavern | `proc_tavern` | `EBD8-EBF5` |
| Shoppe | `proc_shoppe` | `E370-E3CD` |
| Temple | `proc_temple` | `E600-E746` |
| Review Board | `proc_reviewbord` | `E91D-E94F` |
| Guardian | `proc_guardian` | `E7A9-E855` |
| Iron Gate | `proc_iron_gate` | `EE0E-EE57` |
| Mad God | `proc_mad_god` | `EDBA-EE0D` |
| City Sewers | `proc_city_sewers` | `E87E-E8A7` |
| Roscoe's | `proc_roscoe` | `ED2D-EDB9` |
| Gate (closed) | `proc_gate_closed` | `EEB4-EED2` |

## Main Game Loop Call Graph

```
INIT_GAME ($6023)
  └─ game_cycle ($5B03)
       ├─ ZERO_BUFFERS
       ├─ RECALC_ALL_AC
       └─ loop_city_walk:
            ├─ get_pressed_key → press_hero_number
            │   ├─ 1-6 → print_hero_stats
            │   │         └─ Choose [E,T,D,P,N]:
            │   │             ├─ E → equip_item
            │   │             ├─ T → trade_gold
            │   │             ├─ D → drop_item
            │   │             ├─ P → shoppe_pool_gold
            │   │             └─ N → new_order
            │   └─ other → movement (I/J/K/L)
            │       └─ enter building → location dispatch
            ├─ random ambush check → combat_foes
            └─ random event check → city events
```

## Combat Call Graph

```
combat_foes ($6D47)
  ├─ generate_encounter → fill enemy groups
  ├─ enemy_group_advance → sort by speed
  ├─ calc_combat_initiative → determine turn order
  └─ COMBAT ROUND LOOP:
       ├─ FOR EACH HERO:
       │   ├─ battle_options → show A/P/D/C/H/B
       │   ├─ handle_battle_actions → execute choice
       │   │   ├─ Attack → calc_attack_damage
       │   │   │           → apply_damage_to_group
       │   │   ├─ Cast   → spell_casting
       │   │   │           → spend_spell_points
       │   │   │           → check_spell_valid
       │   │   │           → resolve_spell_effect
       │   │   ├─ Hide   → rogue stealth check
       │   │   └─ Song   → process_bard_song
       │   └─ show_damage → print results
       ├─ FOR EACH ENEMY GROUP:
       │   ├─ calc_enemy_attack → roll attack
       │   ├─ select_random_hero → pick target
       │   └─ apply_damage_to_hero → death/status
       ├─ party_disbelieve → illusion check
       ├─ process_poison → poison tick
       ├─ regen_equipped_effects → item regen
       ├─ tick_spell_duration → countdown
       └─ CHECK END CONDITIONS:
            ├─ all enemies dead → enemies_killed
            │   └─ award_experience → XP + gold
            ├─ party dead → oh_dear_game_over
            └─ flee success → exit combat
```
