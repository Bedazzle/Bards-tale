# Split the level-03 (Sewers 1) handler mono into one file per routine, named
# STARThex-ENDhex__name.asm with a @wip header banner, and emit the ordered
# `include` lines for the stitcher. Addresses come from the level_03 build .sym
# (routine labels are already applied by regen_level03_handlers.sh).
# Usage: python tools/split_level03.py <mono.asm> <build.sym> <out_code_dir> <includes_out.txt>
import re, os, sys

MONO, SYM, OUT, INC = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

# Routine boundaries: label -> one-line description (@wip). Unnamed real entries
# (ADDR_TABLE / call targets not yet identified) become proc_XXXX. event_done and
# other sub-labels are intentionally NOT boundaries (they ride inside a routine).
DESC = {
 "get_cell_feature":        "Return the MAZE_FEATURES byte for the party's current cell (+$1E4 plane).",
 "process_cell_features":   "Run each of the 6 current-cell feature bits through its effect (masks via cell_feature_masks).",
 "cell_feature_masks":      "DATA: 6 feature-bit masks (01,02,80,10,08,04), ADDR_TABLE slot $03; ANDed with the cell feature byte by process_cell_features (GET_B_FROM_TABLE $03).",
 "set_state_and_redraw":    "Store A to the view-state var ($5FD2), redraw the location, clear the info panel.",
 "mask_cell_byte":          "AND the party's maze feature-plane cell byte with A, storing it back.",
 "dispatch_special_location":"Scan the special-location list ($FA40) for the party cell and SMC-dispatch its event handler (jp slot $D3C0).",
 "ev_spin_facing":          "Special event: randomise facing, redraw compass+view (contains event_done).",
 "ev_smoke":                "Special event: set smoke/darkness state, print 'smoke in your eyes!'.",
 "ev_start_encounter":      "Special event: load a fixed encounter record -> ACTIVE_GUARDIAN + COMBAT_ACTIVE_FLAG.",
 "ev_damage_all":           "Special event: damage all enemy groups.",
 "ev_inc_2f":               "Special event: increment counter (iy+$2f).",
 "ev_inc_3e":               "Special event: increment counter (iy+$3e).",
 "ev_show_number":          "Special event: compute a number (hl-$FB20)/2+$22 and print it.",
 "ev_dispatch_smc":         "Special event: read a handler pointer from the record and SMC-call it (slot $D434).",
 "ev_set_flags":            "Special event: set the 4 party flags at $5FCE.",
 "ev_teleport":             "Special event: read a coord pair from the record -> party position (iy+1/iy+2).",
 "damage_all_groups":       "Damage all 6 enemy groups; trailing data = special_dispatch_table ($D48B) + a record pointer table.",
 "scan_cells_ahead":        "Scan the 3 cells ahead in the facing direction for walls/reveal bits.",
 "announce_nearby":         "After a move, sense and announce nearby special locations / traps.",
 "refresh_dungeon_view":    "Dispatch[1]: redraw the dungeon location view.",
 "redraw_location":         "Prepare + redraw the 3D location view: clear panel, reset light state, set view coords.",
 "maze_cell_addr":          "Compute the maze feature-plane cell address: $F4EA + row*22 + col. Out: hl, a=(hl).",
 "wrap_view_we":            "Wrap the W/E view coord ($5FE4) into 0..21.",
 "wrap_view_ns":            "Wrap the N/S view coord ($5FE3) into 0..21.",
 "wrap_maze_coord":         "Clamp/wrap a maze coord into 0..$15 (21): <0 -> $15, >=$16 -> 0.",
 "handle_chest":            "Dispatch[4]: chest interaction (Examine/Open/Disarm/Trap-zap/Leave).",
 "wandering_creature_data": "DATA: wandering-creature/encounter tables - value tables, a bit-mask ladder ($D826), the record-pointer table at $D83E (read by point_ix_to_record) and the records at $D84E+.",
 "trap_area_damage":        "Trap/spell area damage: print the trap message, play a tune, roll daypart-scaled damage and apply it to party members in a loop.",
 "handle_wandering_creature":"Dispatch[3]: wandering-creature encounter (offer join / fight / leave).",
 "prompt_pick_hero":        "Prompt the player to pick a party member (1-6); returns the chosen hero.",
 "damage_group_checked":    "Set ACTIVE_GUARDIAN, run the flee check, then apply the rolled damage to group B.",
 "set_damage_state":        "Set up the damage-state vars ($5FFB, iy+$52) and return the high nibble of $5FFF.",
 "roll_from_daypart_table": "Sum a table by daypart (iy+$54) then roll a random amount from it.",
 "point_ix_to_record":      "Index the WORD pointer table at $D83E by A*2 -> ix.",
 "announce_stairs":         "Announce stairs at the cell: print 'there are stairs '+'here, going '+up/down.",
 "draw_view_elements":      "Render the 3D view: loop 5 depth slots calling draw_wall_column.",
 "draw_wall_column":        "Render one 3D-view column/slot: dispatch by wall type, call draw_wall_element.",
 "draw_wall_faces":         "Render all wall faces/edges for a cell: test each reveal/pattern slot (GET_B_FROM_TABLE $17-$1d) and blit the matching element (draw_wall_element e=2..15).",
 "draw_wall_element":       "Blit one view element from the 5-byte-record table at $DD5F (stride $19).",
 "handle_move_key":         "Dispatch[0]: read the movement/action key and act (move/turn/etc.).",
 "move_beep":               "Conditionally beep on move (guarded by vars $10/$2e).",
 "move_party_forward":      "Reset combat flags then step the party one cell in the facing direction.",
 "step_in_facing":          "Advance a coord one cell in the facing direction (0-3), wrapping.",
 "process_turn":            "Dispatch[2]: end-of-move turn processing (events, combat, view refresh).",
}

# addresses from the sym
sym = {}
for line in open(SYM):
    m = re.match(r'(\S+):\s+EQU\s+0x0000([0-9A-Fa-f]{4})', line)
    if m: sym[m.group(1)] = int(m.group(2), 16)

lines = open(MONO, encoding="utf-8").read().splitlines()
label_line = {}
for i, ln in enumerate(lines):
    m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):$', ln)
    if m: label_line[m.group(1)] = i

bounds = sorted(DESC, key=lambda n: sym[n])
# validate all present
missing = [n for n in DESC if n not in sym or n not in label_line]
if missing:
    print("MISSING labels:", missing); sys.exit(1)

# region end = $DD7D (one past the last handler byte)
REGION_END = 0xDD7D

# clean old split files - ONLY those whose start address is in the handler region
# ($D30A-$DD7C), so hand-carved files outside it (front_matter, wall_element_table,
# sprites, maze_planes) are never deleted.
for f in os.listdir(OUT):
    m = re.match(r'^([0-9A-Fa-f]{4})-[0-9A-Fa-f]{4}__', f)
    if m and 0xD30A <= int(m.group(1), 16) <= 0xDD7C:
        os.remove(os.path.join(OUT, f))

# §8 In:/Out:/Note fields per routine (register/var interface). Absent = data block
# or implicit-state routine (dispatch entry / event handler).
HDR = {
 "get_cell_feature":   ["In:  ($5FAC)=N/S, ($5FAD)=W/E coord", "Out: a = feature byte at cell+$1E4"],
 "mask_cell_byte":     ["In:  a = AND mask (applied to the cell feature byte)"],
 "maze_cell_addr":     ["In:  c = row, b = col", "Out: hl = cell address, a = (hl)"],
 "wrap_maze_coord":    ["In:  a = signed coord", "Out: a = wrapped into 0..21"],
 "wrap_view_we":       ["Wraps the W/E view coord ($5FE4) in place into 0..21"],
 "wrap_view_ns":       ["Wraps the N/S view coord ($5FE3) in place into 0..21"],
 "point_ix_to_record": ["In:  a = record index", "Out: ix = record pointer (from the $D83E table)"],
 "scan_cells_ahead":   ["In:  ($5FAE) = facing", "Out: e = collected reveal/sense bits"],
 "set_state_and_redraw":["In:  a = view-state value (stored to $5FD2), then redraw + clear panel"],
 "roll_from_daypart_table":["In:  hl = table base", "Out: a = amount summed by daypart then randomised"],
 "prompt_pick_hero":   ["Out: b = chosen hero, carry set if cancelled"],
 "damage_group_checked":["In:  a = guardian id, b = target group"],
 "set_damage_state":   ["In:  a = damage value (stored to $5FFB)", "Out: a = hi nibble of $5FFF"],
 "draw_wall_element":  ["In:  b = view position, e = element index (into wall_element_table)"],
 "draw_wall_column":   ["In:  a = view slot / depth"],
 "step_in_facing":     ["In:  a = facing (1-3)", "Out: the party coord advanced one cell, wrapped"],
 "move_party_forward": ["In:  (iy+3) = facing; steps the party one cell forward"],
 "damage_all_groups":  ["Applies the rolled damage to all 6 enemy groups (uses $5FFF)"],
 "announce_stairs":    ["Prints 'there are stairs here, going up/down' for the current cell"],
 "dispatch_special_location":["In:  party cell (iy+1/iy+2); fires that cell's special event via the SMC jp"],
}
inc = []
for k, name in enumerate(bounds):
    a = sym[name]
    b = (sym[bounds[k+1]] - 1) if k+1 < len(bounds) else (REGION_END - 1)
    i0 = label_line[name]
    i1 = label_line[bounds[k+1]] if k+1 < len(bounds) else len(lines)
    body = lines[i0:i1]
    fn = "%04X-%04X__%s.asm" % (a, b, name)
    hdr = ["; --- %s ($%04X-$%04X) %s" % (name, a, b, "-"*max(3, 44-len(name))),
           "; @wip", "; " + DESC[name]]
    hdr += ["; " + ln for ln in HDR.get(name, [])]
    open(os.path.join(OUT, fn), "w", newline="\r\n").write("\n".join(hdr + [""] + body) + "\n")
    inc.append('\tinclude "levels/level_03/code/%s"' % fn)

open(INC, "w", newline="\r\n").write("\n".join(inc) + "\n")
print("wrote %d routine files" % len(bounds))
