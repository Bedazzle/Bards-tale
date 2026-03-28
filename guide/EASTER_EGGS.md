# Easter Eggs & Hidden Mechanics

Secrets found by reading the actual Z80 assembly source code — things the
manual never told you.

## Hidden Mechanics

### Enemies Can Join Your Party
After combat, there's a random chance an enemy will "jump into your party!"
(`enemy_joins_party` at $7FB3). The game copies the enemy's full stat block
into a party slot and prints the message. This is separate from summoning —
it happens spontaneously after a fight.

### Hunter Critical Hit — The Silent Killer
Hunters have a hidden critical hit mechanic (`calc_attack_damage` at $7BEB).
After all normal damage is calculated, the game rolls a random number against
`CHAR_HUNTER_CHANCE`. If the roll is lower, `VAR_DAMAGE_TYPE` is set to 7
(instant kill). This check happens *every attack* — Hunters become incredibly
deadly at high levels.

### Monk Unarmed Scaling — Better Than Weapons
Monks get their unarmed damage from half their level (`calc_attack_damage`
at $7B56). The value is looked up in a damage table and can exceed any
weapon in the game. At level 31+, Monks hit harder barehanded than a
warrior with the best sword. The cap is level 63 (damage table index 31).

### Items Can Break When Used
Using an item in combat has a random chance to destroy it (`use_and_break_item`
at $75A5). If the item's value is below 0x30 (48 decimal), there's a 1-in-64
chance it breaks. Expensive items (value >= 0x30) never break.

### Paladin Defense Bonus
Paladins get a hidden AC bonus equal to half their level, capped at 15
(`calc_defense_rating` at $6AFA). This is separate from equipped armor —
a high-level Paladin in light armor can be tankier than a Warrior in full
plate. The game looks this up from a special table (index 0x3D).

### Day/Night Encounter Rates
City encounters use a **triple random check** (`game_cycle` at $5B03).
Three successive `GET_RND_BY_PARAM 3Fh` calls must ALL pass for an
ambush to trigger. This means encounter chance is roughly
(1/64) * (1/64) * (1/128) = about 1 in 500,000 per step during the day.
At night or underground, the rates are much higher.

### The "Disbelieve" Phase
After each combat round, the game runs `party_disbelieve` ($7906). It
loops through up to 3 enemy groups checking if they're illusions. If
the disbelieve succeeds, the group vanishes and "The party disbelieves..."
is printed. Some enemies are immune to this.

### Anti-Magic Zones Block Everything
`apply_anti_magic` ($78A8) doesn't just block new spells — it clears
ALL active spell effects on the party and resets every hero's spell
flags. Even bard songs get cancelled. One anti-magic hit can undo
multiple rounds of buffing.

## Oddities in the Code

### Self-Modifying Code Everywhere
The game uses self-modifying code (SMC) extensively — writing new
instruction bytes into code that's about to execute. The spell casting
system (`spell_casting` at $810E) literally rewrites a `CALL` instruction's
target address at runtime. This was a common Z80 optimization to avoid
indirect jumps.

### The Optimization Comment
In `toggle_speed_flag` ($890D), the original reverse engineer left a
comment noting the code could be optimized to save 4 bytes. The original
developers wrote slightly inefficient code — proof this was hand-assembled,
not compiler-generated.

### Cheat Defines
The source has conditional compile flags for cheating:
- `KILLERS` — unknown effect (likely instant-kill weapons)
- `MAXEXPIRIENCE` — max XP
- `MAXGOLD` — max gold
- `MAXLEVEL` — max level
- `MAXSPLEVEL` — max spell level
- `MAXSPPOINTS` — max spell points
- `NOCITYMONSTERS` — disables city ambushes

These were likely used by the developers during testing.

### BCD Math for Gold and XP
Gold and experience are stored as **12-digit BCD** (Binary Coded Decimal)
— each digit takes 4 bits, 6 bytes total. This means the max gold/XP is
999,999,999,999. The game has dedicated BCD math routines
(`add_to_bcd_number`, `increas_12_digits`, `decreas_12_digits`) because
the Z80 has no native BCD arithmetic beyond single-digit `DAA`.

## Map Secrets

### Guardian Locations (exact coordinates)
From the source code, guardians are placed at these exact city grid positions:

| Guardian | Grid Position | Area |
|----------|--------------|------|
| Stone Giant | (26, 4) | Near Castle |
| Golem | (26, 6) | North of Castle |
| Grey Dragon | (24, 6) | Outside Castle |
| Golem | (22, 6) | SE of Castle |
| Ogre Lord | (14, 3) | Near City Gates |
| Ogre Lord | (6, 3) | Near Mangar's Tower |
| Ogre Lord | (6, 6) | Near Mangar's Tower |
| Samurai | (6, 27) | Near Scarlet Bard |
| Stone Giant | (3, 22) | SE of City |
| Stone Giant | (2, 21) | SE of City |

### Inn Locations
| Inn | Grid Position |
|-----|--------------|
| Scarlet Bard | (5, 28) |
| Sinister Inn | (19, 23) |
| Dragon's Breath | (7, 21) |
| Ask Y'Mother | (6, 20) |
| Archmage Inn | (1, 20) |
| Skull Tavern | (8, 1) |
| Drawn Blade | (18, 11) |

### Sinister Street
The `proc_sinister_street` handler ($EF70) triggers special encounters on
Sinister Street — it checks for a specific teleport coordinate (2, 25) and
can warp the party. This is one of the few scripted encounter locations
in the city.
