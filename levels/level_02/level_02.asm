; ============================================================================
; The Bard's Tale (ZX Spectrum) - Level 02 = THE CELLARS
; (Wine Cellar of the Scarlet Bard - Kylearan's tutorial dungeon)
; ----------------------------------------------------------------------------
; 14789-byte overlay, org $C18C (see docs/BARDSTALE_LEVEL_FORMAT.md).
; Address-ordered stitcher: the dispatch table + handler routines are real source
; (one routine per file under code/, all @done), interleaved with the level's data
; blocks (maze planes as DB grids; text/renderer/tail tables as labelled incbin).
; Each data block carries a §10 header + @done (format understood) or @wip (opaque).
; Rebuild stays byte-identical to original/levels/level_02.bin at every step.
; REMAINING (@wip data): only the PATTERN-BYTE encoding of level_tbl_1..6
; (the 3D wall-renderer tables); their access is understood (see below /
; data/README.md). cellars_data_tail = verified all-zero padding (@done).
; ============================================================================

; $C18C-$C19D - level dispatch table: the engine enters the level through these 6
; JP vectors (movement + event handlers, all landing in cellars_handlers).
LEVEL_START:
	jp	handle_move_key		; [0] movement / action keys
redraw_vector:
	jp	refresh_dungeon_view	; [1] redraw location
	jp	process_turn		; [2] end-of-move processing
	jp	handle_wandering_creature	; [3] wandering-creature encounter
	jp	handle_chest		; [4] chest interaction
	jp	scan_cells_ahead	; [5] scan cells ahead

; $C19E-$C289 (236 bytes) ---------------------------------------------------
	include "levels/level_02/code/C19E-C289__addr_table.asm"

; $C2C2-$C2DF - the level text-decoder clone (code)
	include "levels/level_02/code/C2C2-C2DF__print_msg_cellars.asm"

; --- MESSAGES_TABLE ($C2E0-$C31F, 64 bytes) -------------------
; @done
; Text-length table: leading byte + 63 per-message lengths (5-bit code
; counts). print_msg_cellars uses it to walk the packed bitstream below.
MESSAGES_TABLE:			; leading byte + 63 message lengths (5-bit code counts)
		DB $07,$11,$24,$0A,$14,$20,$1A,$79,$07,$0C,$09,$0B,$13,$15,$12,$18
		DB $15,$13,$1B,$76,$20,$18,$0A,$09,$72,$0D,$0B,$04,$17,$09,$42,$09
		DB $35,$1A,$08,$4F,$31,$41,$1C,$0D,$0C,$05,$0C,$18,$12,$2F,$2F,$3A
		DB $12,$02,$04,$0B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; --- MESSAGES_TEXTS ($C320-$C6CF, 944 bytes) ------------------
; @done
; 63 messages, 5-bit packed (docs/BARDSTALE_TEXT_FORMAT.md). Decoded
; companion: data/C320-C6CF__messages_texts.decoded.txt + TEXT.md -
; identifies this level as the Cellars (Wine Cellar of the Scarlet Bard).
; Kept as .bin: a packed bitstream, not byte-addressable records.
MESSAGES_TEXTS:
	incbin "levels/level_02/data/C320-C6CF__messages_texts.bin"

; --- level_tbl_1 .. level_tbl_6 ($C6D0-$D1D7) -----------------
; @wip
; Six per-level 3D-renderer wall-pattern tables, each an addr_table_2
; (sub-table) slot the City leaves as a dummy (MONST_PIC_07/MONST_PIC_05).
; ACCESS understood: render_wall_face0..3 (maze_cell_addr, $D448) walk 5
; depth steps and per step do GET_B_FROM_LIST $1a/$1b (the _LIST macros
; index addr_table_2, where these tables live) to fetch a wall-face
; pattern byte, gated by GET_B_FROM_TABLE $17/$18 (per-cell reveal/light
; state); render_dungeon_view skips walls entirely when the darkness var
; ($5FEB) is set (dynamically confirmed - see data/README.md). STILL @wip:
; the exact meaning of each PATTERN BYTE (how it maps to the drawn wall
; slices) - the same tables are unnamed in level 1 too.
level_tbl_1:
	incbin "levels/level_02/data/C6D0-C850__level_tbl_1.bin"
level_tbl_2:
	incbin "levels/level_02/data/C851-C9E6__level_tbl_2.bin"
level_tbl_3:
	incbin "levels/level_02/data/C9E7-CC7E__level_tbl_3.bin"
level_tbl_4:
	incbin "levels/level_02/data/CC7F-CE1C__level_tbl_4.bin"
level_tbl_5:
	incbin "levels/level_02/data/CE1D-CFE2__level_tbl_5.bin"
level_tbl_6:
	incbin "levels/level_02/data/CFE3-D1D7__level_tbl_6.bin"

; $D1D8-$DC51 (2682 bytes) - dungeon event/dispatch handlers ------------------
; 26 routines, one file each (below), disassembled to instructions. RST 10h dispatch
; renders as named macros; shared-engine calls symbolic via level_02_externals.asm.
; Confirmed CODE by a live ZX-M8XXX execution map (levels/level_02/EXECMAP.json): 855
; bytes ran during Cellars play; those seeds raised static coverage to 1940/2682 bytes.
cellars_handlers:
	include "levels/level_02/code/D1D8-D1E8__get_cell_feature.asm"
	include "levels/level_02/code/D1E9-D24A__process_cell_features.asm"
	include "levels/level_02/code/D24B-D250__cell_feature_masks.asm"
	include "levels/level_02/code/D251-D259__redraw_after_event.asm"
	include "levels/level_02/code/D25A-D261__mask_cell_byte.asm"
	include "levels/level_02/code/D262-D343__dispatch_special_location.asm"
	include "levels/level_02/code/D344-D358__show_party_stats.asm"
	include "levels/level_02/code/D359-D380__special_dispatch_table.asm"
	include "levels/level_02/code/D381-D3B8__scan_cells_ahead.asm"
	include "levels/level_02/code/D3B9-D3EB__announce_nearby.asm"
	include "levels/level_02/code/D3EC-D3F6__refresh_dungeon_view.asm"
	include "levels/level_02/code/D3F7-D447__render_dungeon_view.asm"
	include "levels/level_02/code/D448-D5A1__maze_cell_addr.asm"
	include "levels/level_02/code/D5A2-D5AB__wrap_view_we.asm"
	include "levels/level_02/code/D5AC-D5B5__wrap_view_ns.asm"
	include "levels/level_02/code/D5B6-D5C1__wrap_maze_coord.asm"
	include "levels/level_02/code/D5C2-D756__handle_chest.asm"
	include "levels/level_02/code/D757-D794__spring_trap.asm"
	include "levels/level_02/code/D795-D7AC__trap_effects.asm"
	include "levels/level_02/code/D7AD-D89C__handle_wandering_creature.asm"
	include "levels/level_02/code/D89D-D8BB__apply_effect_to_hero.asm"
	include "levels/level_02/code/D8BC-D8CC__make_damage_spec.asm"
	include "levels/level_02/code/D8CD-D8EC__roll_damage_from_table.asm"
	include "levels/level_02/code/D8ED-D8FD__point_ix_to_record.asm"
	include "levels/level_02/code/D8FE-D92C__handle_stairs.asm"
	include "levels/level_02/code/D92D-DA4C__draw_view_elements.asm"
	include "levels/level_02/code/DA4D-DAE6__draw_wall_element.asm"
	include "levels/level_02/code/DAE7-DBC5__handle_move_key.asm"
	include "levels/level_02/code/DBC6-DBD6__trap_precheck.asm"
	include "levels/level_02/code/DBD7-DBE1__move_party_forward.asm"
	include "levels/level_02/code/DBE2-DC1A__step_in_direction.asm"
	include "levels/level_02/code/DC1B-DC4A__process_turn.asm"

; $DC4B-$F2E9 - 3D-view graphics (wall_element_table + sprites + shift table)
	include "levels/level_02/code/DC4B-DDDA__wall_element_table.asm"
	include "levels/level_02/code/DDDB-F1FF__cellars_sprites.asm"
	include "levels/level_02/code/F200-F2E9__pixel_shift_table.asm"

; --- MAZE_WALLS ($F2EA-$F4CD, 484 bytes) ----------------------
; @done
; 22x22 wall grid, 1 byte/cell. maze_cell_addr computes the cell address
; as MAZE_WALLS + (row+1)*22 + col (stride 22; $F2EA = sentinel/header
; row). Each byte's nibbles encode the walls around the cell (0=open,
; 4/5=wall); $50/$05/$40/$04 dominate. The 88/08/18 block (rows 4-8) is a
; special room. Rendered map: levels/level_02/MAZE.md.
MAZE_WALLS:			; 22x22 wall grid, 1 byte/cell (nibbles = wall sides)
		DB $AB,$EB,$3B,$7B,$BB,$FB,$0F,$4F,$8F,$CF,$1F,$5F,$9F,$DF,$2F,$6F,$AF,$EF,$3F,$7F,$BF,$FF	; sentinel
		DB $44,$14,$45,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$14	; row  0
		DB $41,$00,$05,$05,$04,$05,$05,$05,$05,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$05,$14,$50	; row  1
		DB $54,$50,$44,$15,$50,$44,$04,$04,$14,$40,$00,$10,$54,$44,$05,$05,$05,$05,$05,$14,$50,$50	; row  2
		DB $50,$50,$50,$54,$50,$40,$00,$00,$10,$40,$00,$10,$50,$50,$54,$56,$56,$56,$56,$50,$50,$50	; row  3
		DB $50,$50,$50,$50,$50,$41,$01,$00,$10,$40,$00,$10,$50,$50,$61,$88,$08,$08,$18,$50,$50,$50	; row  4
		DB $50,$60,$91,$50,$40,$05,$14,$40,$10,$40,$00,$10,$50,$50,$65,$80,$00,$00,$10,$50,$50,$50	; row  5
		DB $50,$50,$44,$10,$50,$54,$50,$40,$10,$40,$00,$10,$50,$50,$64,$82,$02,$02,$10,$50,$50,$50	; row  6
		DB $50,$50,$41,$11,$50,$50,$50,$40,$10,$40,$00,$10,$50,$50,$51,$59,$59,$59,$50,$50,$50,$50	; row  7
		DB $50,$60,$95,$65,$90,$50,$51,$40,$10,$40,$01,$10,$50,$41,$05,$05,$05,$15,$50,$50,$50,$50	; row  8
		DB $50,$50,$45,$15,$50,$41,$05,$01,$11,$50,$55,$50,$41,$05,$05,$05,$05,$15,$52,$51,$50,$50	; row  9
		DB $50,$40,$04,$04,$00,$04,$04,$04,$05,$00,$04,$00,$05,$04,$04,$04,$04,$04,$08,$04,$10,$50	; row 10
		DB $50,$40,$00,$00,$00,$00,$00,$10,$55,$40,$00,$10,$55,$40,$00,$00,$00,$00,$00,$00,$10,$50	; row 11
		DB $50,$40,$01,$01,$00,$01,$01,$01,$05,$00,$01,$00,$05,$01,$01,$01,$01,$02,$01,$01,$10,$50	; row 12
		DB $50,$50,$54,$54,$50,$44,$05,$14,$54,$50,$55,$50,$54,$44,$05,$05,$15,$58,$44,$14,$50,$50	; row 13
		DB $50,$50,$51,$50,$50,$50,$54,$50,$50,$40,$04,$10,$50,$50,$44,$05,$14,$50,$40,$10,$50,$50	; row 14
		DB $50,$50,$45,$11,$50,$50,$50,$51,$50,$40,$00,$10,$50,$50,$50,$55,$50,$50,$41,$10,$50,$50	; row 15
		DB $50,$50,$54,$54,$50,$51,$60,$94,$50,$40,$00,$10,$50,$50,$40,$05,$00,$01,$14,$50,$50,$50	; row 16
		DB $50,$50,$51,$51,$40,$05,$11,$52,$50,$40,$00,$10,$50,$50,$50,$55,$50,$55,$50,$50,$50,$50	; row 17
		DB $50,$60,$85,$25,$90,$44,$14,$59,$50,$40,$00,$10,$50,$50,$41,$05,$01,$05,$11,$50,$50,$50	; row 18
		DB $50,$50,$55,$55,$50,$41,$01,$15,$51,$40,$00,$10,$51,$41,$05,$05,$05,$05,$05,$11,$50,$50	; row 19
		DB $50,$41,$05,$05,$01,$05,$05,$05,$05,$01,$01,$01,$05,$05,$05,$05,$05,$05,$05,$05,$11,$50	; row 20

; --- MAZE_FEATURES ($F4CE-$F6B1, 484 bytes) -------------------
; @done
; Parallel 22x22 feature plane, read at (MAZE_WALLS cell + $1E4). Few
; distinct values (0,1,2,4,5,$10,$11,$41,$80) = per-cell door / stair /
; special / trap flags overlaid on the wall grid.
MAZE_FEATURES:			; 22x22 feature plane (stairs/doors/specials/traps)
		DB $41,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$11	; sentinel
		DB $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  0
		DB $00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  1
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  2
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$80,$00,$00,$00,$00	; row  3
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  4
		DB $00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  5
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  6
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00	; row  7
		DB $00,$00,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  8
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row  9
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00	; row 10
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 11
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00	; row 12
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00	; row 13
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 14
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 15
		DB $00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00	; row 16
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 17
		DB $00,$00,$80,$80,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 18
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 19
		DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; row 20

; --- cellars_data_tail ($F6B2-$FA3F, 910 bytes) ---------------
; @done
; Trailing region after the maze planes and before special_loc_list.
; Verified ENTIRELY ZERO (all 910 bytes) - it is padding / zero-initialised
; runtime working space, not data. Kept as an incbin so the rebuild stays
; byte-identical.
cellars_data_tail:
	incbin "levels/level_02/data/F6B2-FA3F__cellars_data_tail.bin"

; --- special_loc_list ($FA40-$FB50, 273 bytes) ----------------
; @done
; Flat list of 2-byte {SO_NO, WE_EA} cell coordinates, partitioned by event
; type. dispatch_special_location walks it per special_dispatch_table record:
; for event N it scans `count` coordinate-pairs starting at special_loc_list
; + `offset` (both taken from the record); a pair matching the party's cell
; (iy+1 / iy+2) fires that event's handler (ev_portal/ev_teleport/...). $FF
; pairs are empty slots (the Cellars, a tutorial level, uses few special cells).
special_loc_list:
	incbin "levels/level_02/data/FA40-FB50__special_loc_list.bin"
overlay_end:					; $FB51 - one past the overlay (ADDR_TABLE slot $5E)

