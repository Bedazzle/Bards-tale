; ============================================================================
; The Bard's Tale (ZX Spectrum) - Level 03 = SEWERS 1
; "You are in the sewers under Skara Brae. The shallow water holds unknown
;  terrors. Be careful!"  (see levels/level_03/TEXT.md, levels/LEVEL_INDEX.md)
; ----------------------------------------------------------------------------
; 14789-byte dungeon overlay, org $C18C (docs/BARDSTALE_LEVEL_FORMAT.md). Same
; overlay FORMAT as the carved level_02 (Cellars 1) template, but ~86% of the
; bytes differ (byte-diff: only the ADDR_TABLE frame + a few shared tables +
; the tail are identical) - so level 3 gets its own full carve.
;
; CARVE STATUS: fully carved. Front matter ($C18C-$C2DF: dispatch + ADDR_TABLE +
; addr_table_2 + decoder) is relocatable source; the handler code ($D30A-$DD7C) is
; split one-file-per-routine (all named); level_tbl split into 6 sub-tables; the two
; maze planes are DB grids (see MAZE.md); pixel_shift_table + special_loc_list are
; labelled. The only opaque blobs left are byte-exact .bin data: the packed text,
; the wall-pattern level_tbl, the pixel/lookup tables, the sparse maze_tail, and the
; wall_element_table+sprites (a future sprite-art pass would split those into
; labelled sprites). All byte-exact.
;
; REGION MAP (recovered from the dispatch table + addr_table_2 pointers):
;   $C18C-$C19D  dispatch JP table (6 vectors, roles fixed across levels):
;                [0] handle_move_key         -> $DC19
;                [1] refresh_dungeon_view     -> $D51E
;                [2] process_turn             -> $DD4D
;                [3] handle_wandering_creature -> $D8DF
;                [4] handle_chest             -> $D6F4
;                [5] scan_cells_ahead         -> $D4B3
;   $C19E-$C289  ADDR_TABLE (118 words, DW label+1)
;   $C28A-$C2C1  addr_table_2 (28 words) - level_tbl slots point in-overlay to
;                $C7E0/$C961/$CAF7/$CD8F/$CF2D/$D0F3 (the 6 wall-pattern tables)
;   $C2C2-$C2DF  print_msg decoder clone (BYTE-IDENTICAL to level_02's)
;   $C2E0-$C31F  MESSAGES_TABLE (64B: leading byte + 63 lengths)   [source]
;   $C320-$C7D2  MESSAGES_TEXTS (1203B, 5-bit packed, 63 msgs)     [named .bin]
;   $C7D3-$D309  level_tbl_pad + level_tbl_1..6 wall-pattern tables [incbin]
;   $D30A-$DD7C  handler code - 44 files, one per routine           [source]
;   $DD7D-$FA3F  3D-view graphics + maze planes                     [incbin]
;   $FA40-$FB50  special_loc_list                                   [incbin]
; ============================================================================

; $C18C-$C2DF - dispatch JP table + ADDR_TABLE + addr_table_2 + text decoder (source).
	include "levels/level_03/code/C18C-C2DF__front_matter.asm"
	ASSERT $ == $C2E0

; --- MESSAGES_TABLE ($C2E0-$C31F, 64 bytes) -------------------
; @done
; Text-length table: leading byte + 63 per-message 5-bit code counts. The
; decoder clone at $C2C2 walks it to slice the packed bitstream below.
MESSAGES_TABLE:
		DB $07,$11,$24,$0A,$14,$20,$1A,$79,$07,$0C,$09,$0B,$13,$15,$12,$18
		DB $15,$13,$1B,$76,$20,$18,$0A,$09,$72,$0D,$0B,$04,$17,$09,$42,$09
		DB $35,$1A,$07,$62,$40,$27,$28,$3F,$43,$34,$32,$0A,$5C,$1B,$1C,$0D
		DB $0C,$05,$0C,$18,$12,$2F,$2F,$3A,$12,$02,$04,$0B,$00,$00,$00,$00

; --- MESSAGES_TEXTS ($C320-$C7D2, 1203 bytes) -----------------
; @done
; 63 messages, 5-bit packed (docs/BARDSTALE_TEXT_FORMAT.md). Decoded companions:
; data/C320-C7D2__messages_texts.decoded.txt + TEXT.md - identify this level as
; Sewers 1 (#33 'Sewers', #34 the sewers entry blurb; lore: Kylearan, Spidergod,
; IRKM DESMET DAEM, the Basilisk snare, the giant-spider statue). Kept as .bin:
; a packed bitstream (5-bit codes cross byte boundaries), not byte-addressable.
MESSAGES_TEXTS:
	incbin "levels/level_03/data/C320-C7D2__messages_texts.bin"

; --- level_tbl padding ($C7D3-$C7DF, 13 bytes) ---------------
; @done
; Zero padding between the packed MESSAGES_TEXTS and the first wall-pattern table.
level_tbl_pad:
	DB 0,0,0,0,0,0,0,0,0,0,0,0,0

; --- level_tbl_1..6 ($C7E0-$D309) ----------------------------
; @wip
; The six per-level 3D-renderer wall-pattern tables (addr_table_2 in-overlay
; slots, sub-idx $17/$08/$1B/$06/$09/$0B). Same role as level_02's level_tbl_1..6:
; the wall renderer (draw_wall_faces/draw_wall_column) walks them per depth step
; to fetch wall-face pattern bytes ($AA/$A8/$07/$55/$54 pixel data). Per-BYTE
; pixel meaning still @wip (unnamed in level 1 too). Kept as .bin.
level_tbl_1:
	incbin "levels/level_03/data/C7E0-C960__level_tbl_1.bin"
level_tbl_2:
	incbin "levels/level_03/data/C961-CAF6__level_tbl_2.bin"
level_tbl_3:
	incbin "levels/level_03/data/CAF7-CD8E__level_tbl_3.bin"
level_tbl_4:
	incbin "levels/level_03/data/CD8F-CF2C__level_tbl_4.bin"
level_tbl_5:
	incbin "levels/level_03/data/CF2D-D0F2__level_tbl_5.bin"
level_tbl_6:
	incbin "levels/level_03/data/D0F3-D309__level_tbl_6.bin"
	ASSERT $ == $D30A

; --- handler code ($D30A-$DD7C) ------------------------------
; @wip  Disassembled to instructions (byte-exact), shared-engine calls
; symbolised, split one-file-per-routine (STARThex-ENDhex__name). ~37 routine
; entry points named by behaviour (6 dispatch handlers, the cell/maze helpers,
; the special-location event handlers, the 3D-view renderer hierarchy, movement);
; the l_dXXX-named files are still-unidentified routine entries. Regenerated by
; tools/regen_level03_handlers.sh (disasm+name+symbolize) then split by
; tools/split_level03.py. Analogous to level_02's $D1D8-$DC51 handler region.
sewers_handlers:
	include "levels/level_03/code/D30A-D31A__get_cell_feature.asm"
	include "levels/level_03/code/D31B-D37C__process_cell_features.asm"
	include "levels/level_03/code/D37D-D382__cell_feature_masks.asm"
	include "levels/level_03/code/D383-D38B__set_state_and_redraw.asm"
	include "levels/level_03/code/D38C-D393__mask_cell_byte.asm"
	include "levels/level_03/code/D394-D3CE__dispatch_special_location.asm"
	include "levels/level_03/code/D3CF-D3DE__ev_spin_facing.asm"
	include "levels/level_03/code/D3DF-D3E8__ev_smoke.asm"
	include "levels/level_03/code/D3E9-D406__ev_start_encounter.asm"
	include "levels/level_03/code/D407-D40B__ev_damage_all.asm"
	include "levels/level_03/code/D40C-D410__ev_inc_2f.asm"
	include "levels/level_03/code/D411-D415__ev_inc_3e.asm"
	include "levels/level_03/code/D416-D428__ev_show_number.asm"
	include "levels/level_03/code/D429-D440__ev_dispatch_smc.asm"
	include "levels/level_03/code/D441-D455__ev_set_flags.asm"
	include "levels/level_03/code/D456-D475__ev_teleport.asm"
	include "levels/level_03/code/D476-D4B2__damage_all_groups.asm"
	include "levels/level_03/code/D4B3-D4EA__scan_cells_ahead.asm"
	include "levels/level_03/code/D4EB-D51D__announce_nearby.asm"
	include "levels/level_03/code/D51E-D528__refresh_dungeon_view.asm"
	include "levels/level_03/code/D529-D579__redraw_location.asm"
	include "levels/level_03/code/D57A-D6D3__maze_cell_addr.asm"
	include "levels/level_03/code/D6D4-D6DD__wrap_view_we.asm"
	include "levels/level_03/code/D6DE-D6E7__wrap_view_ns.asm"
	include "levels/level_03/code/D6E8-D6F3__wrap_maze_coord.asm"
	include "levels/level_03/code/D6F4-D805__handle_chest.asm"
	include "levels/level_03/code/D806-D888__wandering_creature_data.asm"
	include "levels/level_03/code/D889-D8DE__trap_area_damage.asm"
	include "levels/level_03/code/D8DF-D98A__handle_wandering_creature.asm"
	include "levels/level_03/code/D98B-D9CE__prompt_pick_hero.asm"
	include "levels/level_03/code/D9CF-D9ED__damage_group_checked.asm"
	include "levels/level_03/code/D9EE-D9FE__set_damage_state.asm"
	include "levels/level_03/code/D9FF-DA1E__roll_from_daypart_table.asm"
	include "levels/level_03/code/DA1F-DA2F__point_ix_to_record.asm"
	include "levels/level_03/code/DA30-DA5E__announce_stairs.asm"
	include "levels/level_03/code/DA5F-DA72__draw_view_elements.asm"
	include "levels/level_03/code/DA73-DABC__draw_wall_column.asm"
	include "levels/level_03/code/DABD-DB7E__draw_wall_faces.asm"
	include "levels/level_03/code/DB7F-DC18__draw_wall_element.asm"
	include "levels/level_03/code/DC19-DCF7__handle_move_key.asm"
	include "levels/level_03/code/DCF8-DD08__move_beep.asm"
	include "levels/level_03/code/DD09-DD13__move_party_forward.asm"
	include "levels/level_03/code/DD14-DD4C__step_in_facing.asm"
	include "levels/level_03/code/DD4D-DD7C__process_turn.asm"
	ASSERT $ == $DD7D

; $DD7D-$DF0C - wall_element_table (16 view slots x 5 records; source)
	include "levels/level_03/code/DD7D-DF0C__wall_element_table.asm"
; $DF0D-$F3FF - the 45 labelled 3D-view sprite bitmaps (source)
	include "levels/level_03/code/DF0D-F3FF__sprites.asm"

; --- pixel_shift_table ($F400-$F4E9, 234 bytes) --------------
; @done
; Pixel bit-position translate table (00,40,80,C0,10,50,90,D0,...) indexed by a
; sprite pixel byte; draw_wall_element does `ld h,$F4 : ld a,(hl)` to map a sprite
; byte to its shifted screen-pixel pattern. 234 bytes ($F400-$F4E9), sitting just
; below the maze planes (same layout as level_02's $F200 pixel_shift_table).
pixel_shift_table:
	incbin "levels/level_03/data/F400-F4E9__pixel_shift_table.bin"

; $F4EA-$F8B1 - the two 22x22 maze planes (source, DB grids)
	include "levels/level_03/code/F4EA-F8B1__maze_planes.asm"

; --- maze_tail ($F8B2-$FA3F, 398 bytes) ----------------------
; @wip
; Sparse data between MAZE_FEATURES and special_loc_list - mostly zero with a few
; $04 cells (a sparse per-cell overlay/flag plane, not a full 484-byte plane).
maze_tail:
	incbin "levels/level_03/data/F8B2-FA3F__maze_tail.bin"

; --- special_loc_list ($FA40-$FB50) --------------------------
; @wip
; The special-location list (ADDR_TABLE slot $58): dispatch_special_location
; does `ld hl,special_loc_list` and scans it for the party cell to fire an event.
; Flat {SO_NO,WE_EA} cell entries partitioned by special_dispatch_table (like
; level_02's). Kept as .bin until the per-partition record layout is verified.
special_loc_list:
	incbin "levels/level_03/data/FA40-FB50__special_loc_list.bin"
overlay_end:					; $FB51 - one past the overlay (ADDR_TABLE slot $5E)
