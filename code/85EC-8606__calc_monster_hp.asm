; --- calc_monster_hp ----------------------------------------
; @done
; Derive a monster's hit points from its stat-spec tables plus a
; random component. Takes the HP/AC field (INX_MONST_HP_AC), the
; option-keys field, and a $64-table entry, masks the latter with
; the current random value and sums them; overflow past 255 is
; clamped to $FF.
; In:  a = monster spec index, iy = game variables
; Out: a = hit points (1..255)
; Note: purpose partially inferred; exact per-table weighting unclear.
calc_monster_hp:				; CALC_MONSTER_HP
		push	de
		ld	d,a

		GET_A_FROM_TABLE	INX_MONST_HP_AC

		call	divide_A_by_16
		ld	e,a

		GET_D_FROM_TABLE	INX_OPTION_KEYS

		call	divide_A_by_16

		GET_A_FROM_TABLE	$64

		and	(iy+VAR_RND_HI)
		add	a,e
		pop	de
		ret	nc

		ld	a,$FF

		ret
