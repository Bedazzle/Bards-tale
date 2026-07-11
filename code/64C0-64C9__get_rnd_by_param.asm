; --- get_rnd_by_param -----------------------------------------
; @done
; Return a random value masked to a caller-supplied bit mask: reads the
; next inline parameter byte as an AND mask, pulls a fresh random number
; and ANDs the two.
; In:  inline param byte = AND mask (via GET_RND_BY_PARAM)
; Out: a = random & mask
; Note: preserves DE.
get_rnd_by_param:
		push	de

		call	get_param_to_A

		ld	e,a

		GET_RND_NUMBERS

		and	e
		pop	de

		ret
