; --- add_rnd_number -----------------------------------------
; @done
; Add a small random amount (1..16) to a value. The sentinel $FF
; ("none") is passed through unchanged so callers can skip absent
; values.
; In:  a = base value (or $FF = none)
; Out: a = base + rnd(1..16), or $FF unchanged
add_rnd_number:
		cp	$FF
		ret	z

		ld	e,a

		GET_RND_BY_PARAM	$0F

		inc	a
		add	a,e

		ret
