; --- adjust_value_updown ------------------------------------
; @done
; Interactive +/- selector widget. Shows a signed delta the player
; nudges with the up/down keys (CODE_C9 / CODE_C8), SPACE accepts.
; On accept, returns the base value with the delta applied, wrapped
; into the 0..21 range (the 22x22 maze grid). Used by proc_teleport
; to pick coordinates and dungeon level.
; In:  a = base value (0..21), iy = game variables
; Out: a = adjusted value (0..21)
; Note: delta is clamped to the range -21..+21; advances VAR_CURSOR_ROW.
adjust_value_updown:				; ADJUST_VALUE
		push	bc
		ld	e,a
		ld	c,0			; c = signed delta accumulator

.redraw:
		call	print_plus_minus

.wait_key:
		WAIT_KEY_DOWN

		cp	' '
		jr	z,.accept

		cp	CODE_C8
		jr	z,.inc_delta

		cp	CODE_C9
		jr	nz,.wait_key
		ld	a,c

		cp	$EB			; delta at -21 lower bound?
		jr	z,.wait_key

		dec	c
		jr	.redraw

.inc_delta:
		ld	a,c

		cp	$15			; delta at +21 upper bound?
		jr	z,.wait_key

		inc	c

		jr	.redraw

.accept:
		ld	a,e
		bit	7,c
		jr	nz,.neg_wrap

		add	a,c
		cp	$16			; >=22 -> wrap down
		jr	c,.done

		sub	$16

		jr	.done

.neg_wrap:
		add	a,c
		jr	c,.done

		add	a,$16			; underflow -> wrap into 0..21

.done:
		inc	(iy+VAR_CURSOR_ROW)
		pop	bc

		ret
