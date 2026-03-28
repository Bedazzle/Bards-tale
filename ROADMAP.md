# Bard's Tale ZX Spectrum - Reverse Engineering Roadmap

## Project Overview

Partial reverse engineering of **The Bard's Tale** (1988 ZX Spectrum port).
Z80 assembly, compiled with SjASMPlus. Original work done 2020-2022.

## Current State (v1.0.0)

The codebase contains a disassembly of the full game binary (`$5B00-$FFFF`) with the
original memory dumps in `original/` for byte-level verification.

### What exists

- **107 identified code files** — routines with meaningful names (e.g. `fight_or_run`,
  `process_spell`, `create_char`, `movement`)
- **61 unidentified core code files** — labeled `___UNKNOWN`
- **24 unidentified city/level code files** — in `levels/city/`
- **Full macro library** — 60+ macros wrapping the RST 10h dispatch system
- **Constants defined** — character classes, races, statuses, time-of-day, directions,
  icons, screen addresses, character struct offsets, enemy struct offsets
- **Data tables** — monsters, spells, items, spell costs, light durations, summon
  creatures, city map, icons, font data
- **Compile script** (Windows `.bat`) with binary diff verification against original
- **Original binary dumps** for verification

### What works

- The assembly is structurally complete — all addresses from `$5B00` to `$FFFF` are
  accounted for in the include chain
- Binary diff verification exists to confirm recompiled output matches original
- Compilation has not been verified on macOS yet

### What doesn't work / is missing

- No macOS/Linux build script (only `_compile_bt.bat` for Windows)
- 85 routines across core + city code remain unidentified
- Many game variables (`VAR_00` through `VAR_76`) are unnamed
- Many character/enemy struct offsets are unnamed (`CHAR_12`, `ENEMY_10`, etc.)
- Several data tables are unnamed (`___table_83` through `___table_95`)
- No dungeon levels included (only `levels/city/`)
- No documentation of the RST 10h dispatch system
- No cross-reference map of which routines call which

---

## Milestones

### v0.2.0 — Build & Run on macOS (DONE)

- [x] Create cross-platform build script (Makefile)
- [x] Verify SjASMPlus compiles cleanly on macOS/ARM (v1.22.0)
- [x] Create `recompile/` output directory if missing
- [x] Verify binary diff against original dumps passes
- [x] Add `.gitignore` for build artifacts
- [x] Document emulator setup (Fuse for macOS) in README

### v0.3.0 — Reverse Engineer Combat System (19 files) (DONE)

All 19 combat routines identified, renamed, and verified.

- [x] `6746-680C` — calculate_combat_initiative
- [x] `680D-6857` — select_random_hero (enemy targeting)
- [x] `6977-69B7` — handle_battle_actions (attack/hide)
- [x] `6A03-6A26` — select_spell_target
- [x] `6A27-6A48` — check_party_alive
- [x] `6A66-6AC5` — combat_flee_check
- [x] `6ACC-6B23` — calc_defense_rating
- [x] `6BC2-6C82` — select_combat_target (UI)
- [x] `6D05-6D2B` — find_special_weapon
- [x] `7144-719A` — lookup_addr_table (spell/ability dispatch)
- [x] `719B-71AF` — print_combat_actor
- [x] `73A6-73E7` — process_action_key (menu key handler)
- [x] `7906-794C` — party_disbelieve (illusion check)
- [x] `794D-7966` — spend_spell_points
- [x] `7967-7A31` — post_combat_cleanup
- [x] `7A67-7A9D` — process_special_event
- [x] `7A9E-7AB7` — find_equipped_by_type
- [x] `7F79-7FB2` — award_experience
- [x] `7FB3-7FF1` — enemy_joins_party
- [x] `7FF2-8064` — process_bard_song

### v0.4.0 — Reverse Engineer Encounter Generation (4 files) (DONE)

- [x] `656A-65FE` — generate_encounter
- [x] `669A-6705` — enemy_group_advance
- [x] `5C17-5C50` — calc_xp_thresholds
- [x] `64CA-64DB` — check_item_effect

### v0.5.0 — Reverse Engineer Character/Party System (14 files) (DONE)

- [x] `7590-75A4` — check_spell_cost
- [x] `75A5-75BE` — use_and_break_item
- [x] `75BF-7624` — calc_armor_class (Monk level bonus, equipped weapon/shield)
- [x] `7625-7638` — recalc_party_ac
- [x] `7639-7663` — add_item_to_hero (class equip eligibility)
- [x] `76B9-76EC` — calc_xp_for_level (per-class thresholds)
- [x] `771C-773B` — add_to_bcd_number (12-digit BCD math)
- [x] `7766-7779` — check_heroes_alive
- [x] `77B0-77D7` — store_bcd_and_compare (overflow check)
- [x] `7828-78A7` — summon_creature (enemy becomes ally)
- [x] `78A8-78CB` — apply_anti_magic
- [x] `78CC-78D9` — process_dungeon_step
- [x] `7DB8-7DF8` — regenerate_hp_sp
- [x] `7DF9-7E37` — regen_equipped_effects

### v0.6.0 — Reverse Engineer Magic/Damage System (8 files) (DONE)

- [x] `7AB8-7BEC` — calc_attack_damage (melee: weapon, AC, class, Monk/Hunter specials)
- [x] `7BF4-7C4D` — calc_enemy_attack (monster attack vs hero)
- [x] `7C4E-7CD2` — apply_damage_to_group (kill enemies, shift survivors)
- [x] `7CD3-7DB3` — apply_damage_to_hero (death, stoning, poison, level drain, possession)
- [x] `819B-81D4` — check_spell_valid (caster type vs spell class validation)
- [x] `81D5-82BD` — resolve_spell_effect (full spell resolution + damage output)
- [x] `82BE-82D1` — tick_spell_duration (decrement timer, cleanup on expire)
- [x] `82D7-82FB` — start_spell_or_song (init duration, store ID, activate)

### v0.7.0 — Reverse Engineer Spell Effect Handlers (8 files) (DONE)

Note: originally labeled "dungeon" — turned out to be spell effect dispatch targets.

- [x] `8314-8412` — spell_breath_attack (area damage + status effects)
- [x] `8413-8496` — spell_stat_modifiers (AC/defense/attack buffs)
- [x] `8497-8517` — spell_heal_and_cure (HP restore, cure poison/paralysis/nuts)
- [x] `851A-85EB` — spell_summon_monster (create ally from summon table)
- [x] `85EC-8606` — calc_monster_hp (HP from spec table + random)
- [x] `8607-861A` — spell_reveal_secret (underground secret passage reveal)
- [x] `861B-8625` — spell_flee_effect (spell-assisted escape)
- [x] `8626-8648` — spell_ac_modifier (party/enemy AC buff/debuff)

### v0.8.0 — Reverse Engineer Remaining Core + Print/Display (7 files) (DONE)

- [x] `8649-86A9` — show_location_info ("You face East, in Skara Brae" / dungeon coords)
- [x] `86AA-86C4` — spell_attack_bonus (attack power buff)
- [x] `8778-87B4` — adjust_value_updown (UI: +/- value selector)
- [x] `8889-8895` — roll_damage_dice (B random d4 rolls added to HL)
- [x] `88E5-890C` — print_large_number (multi-digit formatted output)
- [x] `890D-891C` — toggle_speed_flag (animation speed toggle)
- [x] `C00A-C038` — print_item_name_padded (right-pad item name to 11 chars)

### v0.9.0 — Reverse Engineer City/Level Code (14 files) (DONE)

All code UNKNOWN files now identified. Only data/table UNKNOWN files remain.

- [x] `C18C-C19D` — movement_dispatch (entry routing for movement/sinister events)
- [x] `E4F4-E50C` — shift_price_buffer (BCD right-shift for price display)
- [x] `E50D-E54B` — display_inventory_list (show items with equip markers + prices)
- [x] `E54C-E561` — get_inventory_selection (validate 1-8 item choice)
- [x] `E5F3-E5FF` — format_item_price (price display formatting helper)
- [x] `E8A8-E8BB` — compare_char_attrs (4-byte attribute block comparison)
- [x] `E8BC-E8CB` — copy_char_params (save/restore params during class change)
- [x] `EBAB-EBB3` — adjust_stat_floor (subtract with zero floor + add)
- [x] `EBB4-EBC2` — add_16bit_carry (16-bit addition with carry propagation)
- [x] `EF70-EFD1` — proc_sinister_street (evil magic encounter on Sinister Street)
- [x] `EFD2-F13E` — render_3d_view (core 3D dungeon rendering engine)
- [x] `F13F-F178` — display_walls_creatures (wall/creature layer rendering)
- [x] `F1A9-F258` — render_sprite_3d (3D sprite decoder and renderer)
- [x] `F259-F28E` — decode_sprite_mask (pixel transparency mask decoder)

### v1.0.0 — Code Identification Complete (DONE)

All 75 code UNKNOWN routines identified and renamed.

- [x] Verify final binary still matches original

#### Future work (not blocking 1.0.0)
- [ ] Name all `VAR_xx` game variables
- [ ] Name all `CHAR_xx` and `ENEMY_xx` struct offsets
- [ ] Name all `___table_xx` data tables
- [ ] Document RST 10h dispatch system architecture
- [ ] Create cross-reference map (caller/callee graph)
- [ ] Write architecture overview document

---

## File Inventory

| Category | Identified | Unknown | Total |
|----------|-----------|---------|-------|
| Core code | 107 | 0 | 107 |
| City/level code | 40 | 0 | 40 |
| Data files | — | 26 | 26 |
| Tables | — | — | 12 |
| Graphics | — | — | 2 |
| **Code Total** | **147** | **0** | **147** |

## Notes

- The original reverse engineer used an interceptor/debugger hack (`hack_interceptor.asm`,
  `hack_tools.asm`) with conditional compilation (`DEFINE INTERCEPT`) — useful for
  runtime analysis
- Cheat defines exist: `KILLERS`, `MAXEXPIRIENCE`, `MAXGOLD`, `MAXLEVEL`, etc.
- Only the city level is included; dungeon levels load at `$C18C` and would replace
  the city data at runtime
- The compile script diffs recompiled binary against original to verify correctness —
  this is the ultimate validation that reverse engineering is accurate
