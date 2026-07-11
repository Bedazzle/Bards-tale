; --- print_stats_table ------------------------------------
; @done
; Redraw the party roster panel: one row per party slot (6 heroes plus
; the summoned ally) showing name, armour class, and either hit points
; or the current status/condition/spell-points/class abbreviations. If a
; game turn is being processed (VAR_TURN_PROCESSING) it defers by setting
; VAR_REDRAW_STATS and returns, so the table is redrawn after the turn.
; In:  iy = GAME_VARIABLES.
; Note: pauses scrolling (VAR_PAUSE) while drawing; a slot with no living
;       hero and zero condition is marked STATUS_DEAD.
print_stats_table:
		GET_GAME_VARIABLE	VAR_TURN_PROCESSING		; ???

		jr	z,.draw

		inc	(iy+VAR_REDRAW_STATS)

		ret

.draw:
		push	ix
		inc	(iy+VAR_PAUSE)		; pause ON
		ld	hl,$1800
		ld	(GAME_VARIABLES + VAR_INFO_COL_POS),hl
		ld	hl,(GAME_VARIABLES + VAR_CURSOR_ROW)
		push	hl
		ld	hl,GAME_VARIABLES + VAR_CURSOR_ROW
		ld	(hl),$11		; set row
		inc	hl
		ld	c,7			; 6 heroes count + ally
		ld	b,0

.hero_loop:
		push	bc
		ld	(hl),3			; set column

		FIND_HERO_BY_B

		jr	z,.pad_row

		PRINT_IX_HERO_NAME

		ld	a,$12
		call	print_spaces_eol
		ld	a,(ix+CHAR_NATURAL_AC)

		cp	$15
		jr	c,.print_ac

		ld	a,$14

.print_ac:
		add	a,a
		inc	(hl)

		PRINT_LETTER_PAIR

		ld	a,(ix+CHAR_COND_LO)
		or	(ix+CHAR_COND_HI)
		jr	nz,.check_status

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS

		jr	nz,.check_status

		ld	(ix+CHAR_STATUS),STATUS_DEAD

.check_status:
		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_STATUS

		jr	z,.print_hits

		inc	(hl)
		add	a,a
		add	a,a
		add	a,$42			; statuses
		push	af

		PRINT_LETTER_PAIR	; two first letters of status

		pop	af
		add	a,2

		PRINT_LETTER_PAIR	; following two letters of status

		jr	.print_cond
; -------------------------------------

.print_hits:
		ld	a,CHAR_HITS_LO

		PRINT_HERO_ATTR

.print_cond:
		ld	a,CHAR_COND_LO

		PRINT_HERO_ATTR

		ld	a,CHAR_SPPT_LO

		PRINT_HERO_ATTR

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		jr	nc,.print_class

		ld	a,$0A

.print_class:
		add	a,a
		add	a,$2A			; classes
		inc	(hl)

		PRINT_LETTER_PAIR

.pad_row:
		GET_GAME_VARIABLE	VAR_CURSOR_COL

		jr	z,.next_hero

		PRINT_SPACE

		jr	.pad_row
; -------------------------------------

.next_hero:
		pop	bc
		inc	b
		dec	c
		jr	nz,.hero_loop

		pop	hl
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl

.finish:
		ld	hl,$0E15
		ld	(GAME_VARIABLES + VAR_INFO_COL_POS),hl
		pop	ix
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
