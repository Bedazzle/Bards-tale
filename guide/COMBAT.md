# Combat System — Technical Guide

All numbers derived directly from the Z80 assembly source code.

## Turn Order (Initiative)

Initiative is calculated per-combatant in `calc_combat_initiative` ($6746):

```
base = (won_combats_hi >> 1) + random(0-31)
```

Then class modifiers apply:

| Class | Modifier |
|-------|----------|
| Warrior, Sorcerer, Wizard, Conjurer, Magician | base >> 2 (divide by 4) |
| Rogue, Bard | base >> 1 (divide by 2) |
| Paladin, Hunter | base (no change) |
| Monk | base << 1 (multiply by 2) |

**Monks act first.** At equal combat experience, a Monk has 8x the initiative
of a Warrior. Paladins and Hunters get 4x Warriors.

Enemy initiative uses a similar formula from `ENEMY_SPEED`.

## Damage Calculation

### Hero Attack (`calc_attack_damage` at $7AB8)

```
1. Check if attack hits: roll (2 * random(0-7) + 3 + XP_bonus) vs target AC
2. If hit, calculate damage:
   - Weapon damage = roll CHAR_ATT_ROUND times:
     - Each roll: (random(0-mask) + 1) * damage_dice
     - Plus: CHAR_SPEED bonus + VAR_BASE_DAMAGE + XP_bonus
     - Minus: VAR_AC_MOD_ENEMY
     - Minimum: 1 per roll
3. Special: Hunter critical = random < CHAR_HUNTER_CHANCE → instant kill
```

### Enemy Attack (`calc_enemy_attack` at $7BF4)

```
1. Hit check: roll (2 * random(0-7) + 2 + ENEMY_ATTACK_SPEC) vs hero AC
2. Damage: roll B times (random(0-3) + 1) + attack_bonus
```

### Armor Class (AC)

AC is computed by `calc_armor_class` ($75BF), capped at 21:

```
AC = base_from_params
   + equipped_weapon_bonuses (sum of all 8 slots)
   + shield_value + spell_modifier
   - VAR_STAT_MODIFIER
   + class_bonus (Monk: half level, capped at 21)
```

## Flee Mechanics

`combat_flee_check` ($6A66) compares party speed vs enemy speed:

```
party_speed = hero_level/2 (capped at 18) + VAR_DEFENSE_BONUS
            + Paladin_bonus + equipment_bonus + random(0-7)

enemy_speed = ENEMY_ATTACK_SPEC/8 + VAR_DEFENSE_BONUS + random(0-7)
```

If `party_speed >= enemy_speed - 4`, flee fails completely.
If `party_speed < enemy_speed`, 50/50 chance (random check).
Otherwise, flee succeeds.

## Damage Application

### To Enemy Group (`apply_damage_to_group` at $7C4E)

Damage kills individuals one at a time. Survivors shift forward in the
group. When a group is eliminated, remaining groups move up. The group's
member count is decremented and the killed enemy's slot is recycled.

### To Hero (`apply_damage_to_hero` at $7CD3)

After damage is applied, status effects trigger based on `VAR_DAMAGE_TYPE`:

| Type | Effect |
|------|--------|
| 0 | Normal damage only |
| 1 | Poison (STATUS_POISONED) |
| 2 | Level drain (level - 1, recalculate XP) |
| 3 | Status: Nuts (STATUS_NUTS) |
| 4 | Possession (swaps stats, STATUS_POSSESSED) |
| 5 | Resurrection target (special healing) |
| 6 | Stoning (STATUS_STONED, zeroes HP) |
| 7 | Instant kill (Hunter crit) |

If HP reaches 0, hero dies (STATUS_DEAD). If all heroes die → game over.

## Poison

`process_poison` ($78DA) ticks each turn for poisoned heroes. Damage per
tick is based on the poison level. Poison persists until cured at a Temple
or via FLAN/REST spells.

## Party Attack vs Single Attack

"(P)arty attack" auto-targets all enemies. "(A)ttack foes" lets you pick
a specific group. Only the first 3 party members can melee — positions
4-6 must use magic or defend.
