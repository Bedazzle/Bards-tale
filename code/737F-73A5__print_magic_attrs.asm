; --- print_magic_attrs ---------------------------------------
; @done
; Print the four spell-caster class levels (Sorc / Conj / Magi /
; Wizd) for the current hero, laid out in two columns over two rows.
; In:  ix -> first class-level field (CHAR_SORC_LEVEL)
; Note: the 4th value is printed by falling through into
;       loop_magic_attr after the third call returns.
print_magic_attrs:
		PUSH_REGS

		PRINT_MESSAGE	$1D			; "Sorc:   Conj:"
									; "Magi:   Wizd:"

		dec	(iy+VAR_CURSOR_ROW)
		ld	hl,MAGIC_COLUMNS
		push	hl
		call	loop_magic_attr
		call	loop_magic_attr

		PRINT_NEWLINE

		pop	hl
		call	loop_magic_attr

; --- loop_magic_attr -----------------------------------------
; @done
; Print one class's spell level: set the cursor column from (hl),
; read the level from (ix+CHAR_SORC_LEVEL), print it, then advance
; ix and hl to the next class.
; In:  hl -> column value, ix -> class level field
; Out: ix, hl advanced by one class
loop_magic_attr:
		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_CURSOR_COL),a
		ld	e,(ix+CHAR_SORC_LEVEL)		; Sorc, Conj, Magi, Wizd spell level

		PRINT_NUM_FROM_E

		inc	ix
		inc	hl

		ret

MAGIC_COLUMNS:
		DB $1A
		DB $23
