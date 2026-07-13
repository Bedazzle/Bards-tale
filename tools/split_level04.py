# Split the level-04 (Sewers 2) handler mono into one file per REAL routine entry,
# named STARThex-ENDhex__name.asm, and emit the ordered include list for the stitcher.
# Real entries = CALL targets + dispatch/ADDR_TABLE/SMC seeds (NOT fall-through jr/jp
# branch labels, which stay as intra-routine locals for the dot-local pass).
# Addresses come straight from the l_XXXX label names (address-encoded) + the known
# dispatch/renamed addresses.  Named routines get @done; still-l_XXXX get @wip.
# Usage: python tools/split_level04.py <mono.asm> <out_code_dir> <includes_out.txt>
import re, os, sys

MONO, OUT, INC = sys.argv[1], sys.argv[2], sys.argv[3]
REGION_START, REGION_END = 0xD354, 0xDDC7      # handler code range (exclusive end)

# renamed labels -> address (dispatch + confident structural matches + data blocks)
NAMED_ADDR = {
    'handle_move_key': 0xDC63, 'refresh_dungeon_view': 0xD568, 'process_turn': 0xDD97,
    'handle_wandering_creature': 0xD929, 'handle_chest': 0xD73E, 'scan_cells_ahead': 0xD4FD,
    'ev_spin_facing': 0xD419, 'redraw_location': 0xD573, 'trap_area_damage': 0xD8D3,
    'prompt_pick_hero': 0xD9D5, 'damage_group_checked': 0xDA19, 'announce_stairs': 0xDA7A,
    'move_beep': 0xDD42, 'special_dispatch_table': 0xD4D1, 'wandering_creature_data': 0xD911,
    'get_cell_feature': 0xD354, 'process_cell_features': 0xD365, 'set_state_and_redraw': 0xD3CD,
    'ev_show_number': 0xD460, 'ev_teleport': 0xD4A0, 'damage_all_groups': 0xD4C0,
    'announce_nearby': 0xD535, 'maze_cell_addr': 0xD5C4, 'render_wall_face0': 0xD5D3,
    'render_wall_face1': 0xD5F7, 'render_wall_face2': 0xD61B, 'render_wall_face3': 0xD640,
    'wall_init_face0': 0xD6A0, 'wall_init_face1': 0xD6B0, 'wall_init_face2': 0xD6C0,
    'wall_init_face3': 0xD6D0, 'unpack_cell_walls': 0xD6E0, 'render_wall_flags': 0xD701,
    'wrap_view_we': 0xD71E,
    'wrap_view_ns': 0xD728, 'wrap_maze_coord': 0xD732, 'roll_from_daypart_table': 0xDA49,
    'ev_smoke': 0xD429, 'ev_start_encounter': 0xD433, 'ev_damage_all': 0xD451,
    'ev_inc_2f': 0xD456, 'ev_inc_3e': 0xD45B, 'ev_dispatch_smc': 0xD473, 'ev_set_flags': 0xD48B,
    'get_walls_e': 0xD664, 'get_walls_w': 0xD673, 'get_walls_n': 0xD682, 'get_walls_s': 0xD691,
    'draw_view_elements': 0xDAA9, 'draw_wall_column': 0xDABD, 'draw_wall_element': 0xDBC9,
    'set_damage_state': 0xDA38, 'move_party_forward': 0xDD53, 'step_in_facing': 0xDD5E,
    'mask_cell_byte': 0xD3D6, 'dispatch_special_location': 0xD3DE, 'wc_join_scan': 0xD984,
    'wc_join_hero': 0xD998, 'start_combat': 0xD9F8, 'point_ix_to_record': 0xDA69,
    'trap_value_tables': 0xD850, 'trap_name_table': 0xD880, 'cell_feature_masks': 0xD3C7,
}
# extra seed entry addresses that must start their own file even if not a CALL target
SEED_ADDR = [0xD3C7, 0xD40D, 0xD429, 0xD433, 0xD451, 0xD456, 0xD45B, 0xD460, 0xD473,
             0xD48B, 0xD4A0, 0xD5D3, 0xD5F7, 0xD61B, 0xD640, 0xD850, 0xD860, 0xD880,
             0xD919, 0xD984, 0xD998, 0xD9AA, 0xD9B8, 0xD9C3, 0xD9EF, 0xD9F8, 0xDA0D]

lines = open(MONO, encoding='utf-8').read().splitlines()
# map current label -> (line index, address)
label_line, label_addr = {}, {}
for i, ln in enumerate(lines):
    m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):$', ln)
    if not m:
        continue
    lbl = m.group(1)
    label_line[lbl] = i
    if lbl in NAMED_ADDR:
        label_addr[lbl] = NAMED_ADDR[lbl]
    else:
        g = re.match(r'l_([0-9a-f]{4})$', lbl)
        if g:
            label_addr[lbl] = int(g.group(1), 16)

# real routine entries = CALL targets + named + seed addrs (that exist as labels)
txt = '\n'.join(lines)
calltgt = set(re.findall(r'\bcall\s+(?:z,|nz,|c,|nc,)?([A-Za-z_][A-Za-z0-9_]*)', txt))
seed_lbls = {l for l, a in label_addr.items() if a in SEED_ADDR}
entries = set(NAMED_ADDR) | (calltgt & set(label_addr)) | seed_lbls
entries = sorted((label_addr[l], l) for l in entries if l in label_addr)

# clean any prior split files in the handler range
if os.path.isdir(OUT):
    for f in os.listdir(OUT):
        g = re.match(r'^([0-9A-Fa-f]{4})-', f)
        if g and REGION_START <= int(g.group(1), 16) < REGION_END:
            os.remove(os.path.join(OUT, f))
else:
    os.makedirs(OUT)

DATA = {'special_dispatch_table', 'wandering_creature_data'}
inc = []
for k, (a, lbl) in enumerate(entries):
    b = (entries[k + 1][0] - 1) if k + 1 < len(entries) else (REGION_END - 1)
    i0 = label_line[lbl]
    i1 = label_line[entries[k + 1][1]] if k + 1 < len(entries) else len(lines)
    body = lines[i0:i1]
    fn = "%04X-%04X__%s.asm" % (a, b, lbl)
    # First split = all @wip: names are structural-match hypotheses / still-l_XXXX, and
    # nothing is hand-polished yet. Flip to @done per-routine as each is verified+polished
    # (done-marker-honesty: @done means FULLY understood, not just tentatively named).
    hdr = ["; --- %s ($%04X-$%04X) %s" % (lbl, a, b, "-" * max(3, 40 - len(lbl))), "; @wip"]
    open(os.path.join(OUT, fn), "w", newline="\r\n").write("\n".join(hdr + [""] + body) + "\n")
    inc.append('\tinclude "levels/level_04/code/%s"' % fn)

open(INC, "w", newline="\r\n").write("\n".join(inc) + "\n")
print("wrote %d routine files (%d named, %d l_XXXX)" %
      (len(entries), sum(1 for a, l in entries if not l.startswith('l_')),
       sum(1 for a, l in entries if l.startswith('l_'))))
