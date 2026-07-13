; --- handle_chest ------------------------------------------
; @done
; Chest interaction (dispatch[4]): show the chest picture + menu (Examine/Open/
; Disarm/Trap-zap/Leave), read the key and run the chosen action. Uses chest_attr_table
; + chest_option_masks; a sprung chest trap is named via chest_trap_name_ptrs ->
; chest_trap_names. (Internal branch labels are address-scoped dot-locals .cXXX.)
handle_chest:
		SHOW_PIC_BY_PARAM $18
		GET_RND_NUMBERS
		and	3
		ld	e,a
		ld	a,(copy_daypart)
		sla	a
		sla	a
		add	a,e
		GET_A_FROM_TABLE $1e
		ld	(treasure_flag),a
		xor	a
		ld	(DISPLAY_PALETTE),a
.c5dc:
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $06
.c5e1:
		WAIT_KEY_DOWN
		cp	'O'
		jp	z,.c689
		cp	'T'
		jr	z,.c62d
		cp	'D'
		jr	z,.c651
		cp	'L'
		jr	z,.c64d
		cp	'E'
		jr	nz,.c5e1
		ld	a,8
		call	enc_pick_hero
		jr	c,.c5dc
		jr	z,.c5dc
		PRINT_NEWLINE
		GET_B_FROM_TABLE $1f
		ld	e,a
		ld	a,(DISPLAY_PALETTE)
		ld	d,a
		and	e
		jr	nz,.c648
		ld	a,e
		or	d
		ld	(DISPLAY_PALETTE),a
		GET_RND_NUMBERS
		ld	e,a
		ld	a,(ix+$3f)
		cp	e
		jr	c,.c640
		GET_GAME_VARIABLE $36
		jr	z,.c640
		push	af
		PRINT_MESSAGE2 $0f
		pop	af
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		jr	.c643
.c62d:
		call	who_cast_spell
		jr	c,.c5dc
		ld	a,(current_spell)
		cp	3
		jr	nz,.c5dc
		call	spend_spell_points
		jr	c,.c5dc
		jr	.c680
.c640:
		PRINT_MESSAGE2 $0b
.c643:
		CHANGE_SPEED $08
.c646:
		jr	.c5dc
.c648:
		PRINT_MESSAGE2 $0c
		jr	.c643
.c64d:
		inc	(iy+$36)
		ret
.c651:
		ld	a,10
		call	enc_pick_hero
		jr	c,.c5dc
		jr	z,.c5dc
		ld	(iy+$53),b
		PRINT_MESSAGE2 $0e
		call	enter_text
		jr	c,.c646
		PRINT_MESSAGE2 $1a
		GET_GAME_VARIABLE $36
		jr	z,.c680
		call	point_ix_to_record
		ld	de,TEXT_BUFFER
		ex	de,hl
.c674:
		ld	a,(de)
		cp	$fe
		jr	z,.c680
		cp	(hl)
		jr	nz,.c698
		inc	hl
		inc	de
		jr	.c674
.c680:
		PRINT_MESSAGE2 $0d
		ld	(iy+$36),0
		jr	.c643
.c689:
		ld	a,9
		call	enc_pick_hero
		jp	c,.c5dc
		ld	(iy+$53),b
		GET_GAME_VARIABLE $36
		ret	z
.c698:
		PRINT_MESSAGE2 $10
		ld	a,(iy+$36)
		call	point_ix_to_record
		PRINT_IX_HERO_NAME
		CHANGE_SPEED $08
		ld	hl,$d6dc
		call	roll_damage_from_table
		ld	a,(iy+$36)
		cp	3
		jr	c,.c6b7
		ld	(iy+$53),6
.c6b7:
		ld	b,a
.c6b8:
		GET_B_FROM_TABLE $52
		call	make_damage_spec
		add	a,15
		call	apply_effect_to_hero
		cp	3
		jr	c,.c6cd
		dec	(iy+$53)
		jp	p,.c6b8
.c6cd:
		ld	(iy+$36),0
		jp	print_stats_table

; --- chest data -------------------------------------------------------------
chest_attr_table:			; 6 rows x 8: chest contents/trap attributes
		DB $00,$01,$00,$00,$01,$00,$03,$05
		DB $01,$01,$02,$04,$03,$07,$01,$01
		DB $00,$00,$01,$01,$01,$01,$02,$03
		DB $03,$04,$04,$05,$03,$04,$05,$05
		DB $05,$06,$06,$07,$05,$06,$07,$07
		DB $06,$05,$07,$07,$05,$06,$07,$07

chest_option_masks:			; bit per chest menu option
		DB $01,$02,$04,$08,$10,$20,$40,$80

chest_trap_name_ptrs:			; -> chest_trap_names (point_ix_to_record indexes this)
		DW ctn_poison, ctn_poison, ctn_blade1, ctn_dart
		DW ctn_blade2, ctn_shocker, ctn_crazy, ctn_mindtrap

chest_trap_names:
ctn_poison:	DB "POISON NEEDLE",$FF
ctn_blade1:	DB "BLADE",$FF
ctn_dart:	DB "DART",$FF
ctn_blade2:	DB "BLADE",$FF
ctn_shocker:	DB "SHOCKER",$FF
ctn_crazy:	DB "CRAZYCLOUD",$FF
ctn_mindtrap:	DB "MINDTRAP",$FF
