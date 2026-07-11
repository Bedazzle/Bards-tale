; --- show_damage ---------------------------------------------
; @done
; Announce combat damage: print the damage amount (DE), then
; "point(s) of damage", and fall through to apply_damage_to_group
; (apply_damage_to_group) against the current target. Dispatch handler $54.
; In:  hl/de = damage amount, VAR_TARGET_ID = target
; Note: stores the amount in VAR_DISPLAY_COUNT for singular/plural text.
show_damage:
		PUSH_REGS

		push	hl
		pop	de
		xor	a

		cp	d
		ld	a,e
		jr	z,.set_count

		inc	a

.set_count:
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		PRINT_NUM_FROM_DE

		PRINT_IN_LOOP
		DB $60,$61,$FF			; "point"
									; "of damage"

		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)

		jp	apply_damage_to_group
