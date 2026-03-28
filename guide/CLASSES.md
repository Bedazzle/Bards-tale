# Character Classes — Technical Breakdown

All mechanics verified from assembly source code.

## Class Comparison

| Class | Initiative | AC Bonus | Special | Front Row? |
|-------|-----------|----------|---------|------------|
| Warrior | 1/4x | None | Best weapons | Yes |
| Paladin | 1x | Level/2 (cap 15) | Defense scaling | Yes |
| Hunter | 1x | None | Critical hits | Yes |
| Monk | 2x | Level (cap 21) | Unarmed scaling | Yes |
| Rogue | 1/2x | None | Hide, disarm traps | Yes |
| Bard | 1/2x | None | Songs | Yes |
| Sorcerer | 1/4x | None | Illusion spells | No (back) |
| Conjurer | 1/4x | None | Healing, buffs | No (back) |
| Magician | 1/4x | None | Damage, shields | No (back) |
| Wizard | 1/4x | None | Summons, resurrection | No (back) |

## Class-Specific Mechanics

### Warrior (CLASS_WARRIOR = 0)
- Lowest initiative (1/4x base)
- No special abilities
- Can equip all weapons and armor
- Pure melee damage dealer — position in slots 1-3

### Paladin (CLASS_PALADIN = 7)
- Full initiative (1x)
- **Hidden AC bonus:** half level, looked up from table 0x3D, capped at 15
- Gets tankier every level without new gear
- From `calc_defense_rating`: Paladin check at $6AFA

### Hunter (CLASS_HUNTER = 8)
- Full initiative (1x)
- **Critical hit:** each attack rolls `random < CHAR_HUNTER_CHANCE`
  - Success = `VAR_DAMAGE_TYPE` set to 7 (instant kill)
  - From `calc_attack_damage` at $7BDA
- At high levels with good HUNTER_CHANCE, one-shots bosses

### Monk (CLASS_MONK = 9)
- **Double initiative** (2x base) — always acts first
- **Unarmed AC:** scales with level, capped at 21
  - From `calc_armor_class`: `level/2`, max 21
  - Better than any armor at high levels
- **Unarmed damage:** scales with half level
  - From `calc_attack_damage` at $7B56: `level/2`, capped at 31
  - Looked up in damage table at index 0x6C
  - Outdamages weapons at ~level 30+
- Best class in the late game

### Rogue (CLASS_ROGUE = 5)
- Half initiative (1/2x)
- **Hide in shadows:** rolls `random < CHAR_ROGUE_HIDE`
  - From `handle_battle_actions` at $69A8
  - Success = avoid all damage that round
- **Disarm traps:** CHAR_ROGUE_DISARM
- **Detect traps:** CHAR_ROGUE_DETECT
- Unique combat option "(H)ide"

### Bard (CLASS_BARD = 6)
- Half initiative (1/2x)
- **Songs:** consumes CHAR_BARD_SONGS (finite per dungeon visit)
  - If songs run out: "lost his voice!" (from $8061)
  - Must have special weapon equipped (type 6) to access song option
  - From `battle_options`: checks `find_special_weapon` before showing "(B)ard Song"
- Song effects (from `process_bard_song`):
  1. Increase VAR_BASE_DAMAGE (party attack boost)
  2. Increase VAR_SONG_MODIFIER
  3. Heal party (calls regenerate routine)
  4. Buff enemy group defense stats
  5. Increase VAR_DAMAGE_PENALTY
  6. Increase VAR_DEFENSE_BONUS (party AC boost)

### Spellcasters (Sorcerer/Conjurer/Magician/Wizard)
- Lowest initiative (1/4x)
- Position in slots 4-6 (back row, can't melee)
- Spell points regenerate via `regenerate_hp_sp` and `regen_equipped_effects`
- Certain equipment halves spell costs (from `spend_spell_points` at $794D:
  `CHECK_EQUIPPED 4` — if equipped, `srl c` halves the cost)

## Class Change

Class change happens at the Review Board (`do_class_change` at $EACE).
Your stats are saved via `copy_char_params` and carried over. The game
backs up your params to `CHAR_BACKUP_PARAMS` during the transition.

Multi-classing preserves spell levels — a Sorcerer who becomes a Conjurer
keeps their Sorcerer spells. This is the path to having all spell classes.

## Party Composition Tips (from the code)

**Optimal front row:** Monk (initiative + damage) + Paladin (AC scaling) +
Hunter (critical hits)

**Back row:** One of each caster class gives access to all spells. A Bard
in position 4 can still sing without melee attacking.

**The Monk is broken:** Double initiative means they act before enemies can
hit. Level-scaling AC means they dodge most attacks. Level-scaling damage
means they outdamage weapons. The source code confirms — Monks are the
best class in the game by a wide margin.
