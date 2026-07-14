; ============================================================================
; The Bard's Tale (ZX Spectrum) - Level 06 = CATACOMBS 1
; 14789-byte dungeon overlay, org $C18C. NEW dungeon type (own sprite art).
; CARVE STATUS: FULLY CARVED + byte-exact. Front matter, handlers (all named + @done),
; wall_element_table (DW-of-labels), sprites (45 Catacombs bitmaps + PNGs), maze planes
; (DB grids) are source. Remaining incbin = irreducible data (packed text, level_tbl,
; pixel_shift, gfx_xlat, maze_tail, special_loc).
; Dispatch: handle_move_key $DB87 / refresh_dungeon_view $D48C / process_turn $DCBB /
;   handle_wandering_creature $D84D / handle_chest $D662 / scan_cells_ahead $D421.
; ============================================================================

	include "levels/level_06/code/C18C-C2DF__front_matter.asm"

MESSAGES_TABLE:
		DB $07,$11,$24,$0A,$14,$20,$1A,$79,$07,$0C,$09,$0B,$13,$15,$12,$18
		DB $15,$13,$1B,$76,$20,$18,$0A,$09,$72,$0D,$0B,$04,$17,$09,$42,$09
		DB $35,$1A,$0A,$6F,$71,$5D,$7C,$1C,$0D,$0C,$05,$0C,$18,$12,$2F,$2F
		DB $3A,$12,$02,$04,$0B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

MESSAGES_TEXTS:
	incbin "levels/level_06/data/C320-C76D__messages_texts.bin"

level_tbl_pad:
		DB $00,$00
level_tbl_1:
	incbin "levels/level_06/data/C770-C8F0__level_tbl_1.bin"
level_tbl_2:
	incbin "levels/level_06/data/C8F1-CA86__level_tbl_2.bin"
level_tbl_3:
	incbin "levels/level_06/data/CA87-CD1E__level_tbl_3.bin"
level_tbl_4:
	incbin "levels/level_06/data/CD1F-CEBC__level_tbl_4.bin"
level_tbl_5:
	incbin "levels/level_06/data/CEBD-D082__level_tbl_5.bin"
level_tbl_6:
	incbin "levels/level_06/data/D083-D277__level_tbl_6.bin"

catacombs1_handlers:
	include "levels/level_06/code/D278-D288__get_cell_feature.asm"
	include "levels/level_06/code/D289-D2EA__process_cell_features.asm"
	include "levels/level_06/code/D2EB-D2F0__cell_feature_masks.asm"
	include "levels/level_06/code/D2F1-D2F9__set_state_and_redraw.asm"
	include "levels/level_06/code/D2FA-D33C__mask_cell_byte.asm"
	include "levels/level_06/code/D33D-D34C__ev_spin_facing.asm"
	include "levels/level_06/code/D34D-D356__ev_smoke.asm"
	include "levels/level_06/code/D357-D374__ev_start_encounter.asm"
	include "levels/level_06/code/D375-D379__ev_damage_all.asm"
	include "levels/level_06/code/D37A-D37E__ev_inc_2f.asm"
	include "levels/level_06/code/D37F-D383__ev_inc_3e.asm"
	include "levels/level_06/code/D384-D396__ev_show_number.asm"
	include "levels/level_06/code/D397-D3A1__ev_dispatch_smc.asm"
	include "levels/level_06/code/D3A2-D3AE__ev_dispatch_run.asm"
	include "levels/level_06/code/D3AF-D3C3__ev_set_flags.asm"
	include "levels/level_06/code/D3C4-D3E3__ev_teleport.asm"
	include "levels/level_06/code/D3E4-D3F8__damage_all_groups.asm"
	include "levels/level_06/code/D3F9-D420__special_dispatch_table.asm"
	include "levels/level_06/code/D421-D458__scan_cells_ahead.asm"
	include "levels/level_06/code/D459-D48B__announce_nearby.asm"
	include "levels/level_06/code/D48C-D496__refresh_dungeon_view.asm"
	include "levels/level_06/code/D497-D4E7__redraw_location.asm"
	include "levels/level_06/code/D4E8-D4F6__maze_cell_addr.asm"
	include "levels/level_06/code/D4F7-D51A__render_wall_face0.asm"
	include "levels/level_06/code/D51B-D53E__render_wall_face1.asm"
	include "levels/level_06/code/D53F-D563__render_wall_face2.asm"
	include "levels/level_06/code/D564-D587__render_wall_face3.asm"
	include "levels/level_06/code/D588-D596__get_walls_e.asm"
	include "levels/level_06/code/D597-D5A5__get_walls_w.asm"
	include "levels/level_06/code/D5A6-D5B4__get_walls_n.asm"
	include "levels/level_06/code/D5B5-D5C3__get_walls_s.asm"
	include "levels/level_06/code/D5C4-D5D3__wall_init_face0.asm"
	include "levels/level_06/code/D5D4-D5E3__wall_init_face1.asm"
	include "levels/level_06/code/D5E4-D5F3__wall_init_face2.asm"
	include "levels/level_06/code/D5F4-D603__wall_init_face3.asm"
	include "levels/level_06/code/D604-D624__unpack_cell_walls.asm"
	include "levels/level_06/code/D625-D641__render_wall_flags.asm"
	include "levels/level_06/code/D642-D64B__wrap_view_we.asm"
	include "levels/level_06/code/D64C-D655__wrap_view_ns.asm"
	include "levels/level_06/code/D656-D661__wrap_maze_coord.asm"
	include "levels/level_06/code/D662-D7F6__handle_chest.asm"
	include "levels/level_06/code/D7F7-D834__trap_area_damage.asm"
	include "levels/level_06/code/D835-D84C__wandering_creature_data.asm"
	include "levels/level_06/code/D84D-D88F__handle_wandering_creature.asm"
	include "levels/level_06/code/D890-D8A7__wc_show_joiner.asm"
	include "levels/level_06/code/D8A8-D8BB__wc_join_scan.asm"
	include "levels/level_06/code/D8BC-D8CD__wc_join_hero.asm"
	include "levels/level_06/code/D8CE-D8DB__run_cell_encounter.asm"
	include "levels/level_06/code/D8DC-D8E6__party_has_effect_item.asm"
	include "levels/level_06/code/D8E7-D8F8__damage_groups_by_a.asm"
	include "levels/level_06/code/D8F9-D912__prompt_pick_hero.asm"
	include "levels/level_06/code/D913-D91B__trigger_cell_encounter.asm"
	include "levels/level_06/code/D91C-D93C__start_combat.asm"
	include "levels/level_06/code/D93D-D95B__damage_group_checked.asm"
	include "levels/level_06/code/D95C-D96C__set_damage_state.asm"
	include "levels/level_06/code/D96D-D98C__roll_from_daypart_table.asm"
	include "levels/level_06/code/D98D-D99D__point_ix_to_record.asm"
	include "levels/level_06/code/D99E-D9CC__announce_stairs.asm"
	include "levels/level_06/code/D9CD-D9E0__draw_view_elements.asm"
	include "levels/level_06/code/D9E1-DAEC__draw_wall_column.asm"
	include "levels/level_06/code/DAED-DB86__draw_wall_element.asm"
	include "levels/level_06/code/DB87-DC65__handle_move_key.asm"
	include "levels/level_06/code/DC66-DC76__move_beep.asm"
	include "levels/level_06/code/DC77-DC81__move_party_forward.asm"
	include "levels/level_06/code/DC82-DCBA__step_in_facing.asm"
	include "levels/level_06/code/DCBB-DCEA__process_turn.asm"
; wall_element_table (DW-of-labels) + sprites (Catacombs art, 45 labeled bitmaps -
	include "levels/level_06/code/DCEB-DE7A__wall_element_table.asm"
	include "levels/level_06/code/DE7B-F172__sprites.asm"

pixel_shift_table:
	incbin "levels/level_06/data/F173-F25C__pixel_shift_table.bin"

gfx_xlat_table:
	incbin "levels/level_06/data/F25D-F3E9__gfx_xlat_table.bin"

	include "levels/level_06/code/F3EA-F7B1__maze_planes.asm"

maze_tail:
	incbin "levels/level_06/data/F7B2-FA3F__maze_tail.bin"
special_loc_list:
	incbin "levels/level_06/data/FA40-FB50__special_loc_list.bin"
overlay_end:					; $FB51
