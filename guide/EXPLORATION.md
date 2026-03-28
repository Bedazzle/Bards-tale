# Exploration — Technical Guide

## City of Skara Brae

The city is a grid map stored at `levels/city/data/F7E7-FA98_city_map.asm`.
Navigation uses I/J/K/L keys (forward/left/right/kick door).

### Day/Night Cycle

The day cycle is driven by three nested counters:
- `VAR_DAY_OUTER_CTR` — outer loop
- `VAR_DAY_MID_CTR` — middle loop
- `VAR_DAY_INNER_CTR` — inner loop (resets to 10)

Time of day phases (from constants.asm):
```
$00-$03  After Midnight
$04-$07  Midnight
$08-$0B  Evening
$0C-$0F  Dusk
$10-$13  Afternoon
$14-$17  Noon
$18-$1B  Mid Morning
$1C-$1F  Early Morning
```

Encounters are more frequent at night. The city ambush check in
`game_cycle` requires three consecutive random checks to pass, making
daytime encounters extremely rare.

### Encounter Rates

**City (daytime):** ~1 in 500,000 per step (three 1/64 checks must pass)

**City (nighttime):** Significantly higher — the underground flag modifies
the random thresholds.

**Underground:** `generate_encounter` checks `VAR_UNDERGROUND` and allows
up to 4 enemy groups instead of the city's reduced count. Random group
count is `random(0-3)` underground vs 0 on the surface.

### Building Types

When you walk into a building tile, the city map value dispatches to:

| Building | What to do |
|----------|-----------|
| Adventurer's Guild | Create characters, manage party roster |
| Review Board | Level up (required!), class change |
| Shoppe | Buy/sell/identify equipment |
| Temple | Heal, cure poison, resurrect (costs gold) |
| Tavern | Rest, order drinks, talk to barkeep for hints |
| Roscoe's | Energy emporium — special items |

### The Taverns (with coordinates)

| Tavern | Location |
|--------|----------|
| Scarlet Bard | (5, 28) — near starting area |
| Sinister Inn | (19, 23) |
| Dragon's Breath | (7, 21) |
| Ask Y'Mother | (6, 20) |
| Archmage Inn | (1, 20) |
| Skull Tavern | (8, 1) |
| Drawn Blade | (18, 11) |

Tavern drinks: Ale, Beer, Mrad, Foul Spirits, Ginger Ale, Wine.

### Sinister Street

Location (EF70) has a special encounter handler. Walking on Sinister
Street triggers `proc_sinister_street` which checks for teleport at
coordinate (2, 25) and can force encounters with special monsters.

## Dungeon Navigation

### Level Loading

Dungeon levels load into memory at `$C18C`, replacing the city data.
The core engine ($5B00-$C18B) stays resident. This means:
- All combat/spell/character code works in dungeons
- Only the map data and location-specific handlers change
- Only the city level is included in this disassembly

### 3D View

The dungeon view is rendered by the 3D rendering pipeline:
1. `render_3d_view` — converts player position + facing to view coordinates
2. `display_walls_creatures` — renders 8 depth layers of walls/creatures
3. `render_sprite_3d` — decodes RLE-compressed sprite data to screen

The view uses `VAR_VIEW_Y_OFFSET` and `VAR_VIEW_X_OFFSET` for camera
position. Four facing directions (N/E/S/W) each have different offset
tables for the 8 render bytes stored at $FBD7-$FBDE.

### Compass and Coordinates

- Cast MACO (Magic Compass) to see a compass icon
- Cast SCSI (Scry Site) or LERE to see your coordinates
- The location info screen (`show_location_info`) prints:
  "You face [direction] and are [N] levels [above/below],
   [X] squares [north/south], [Y] squares [east/west]
   of the entry stairs."

### Secret Passages

`spell_reveal_secret` checks the map data for hidden passages and sets
`VAR_REVEAL_FLAG`. Without a reveal spell active, secret doors are
invisible — you'll walk right past them.
