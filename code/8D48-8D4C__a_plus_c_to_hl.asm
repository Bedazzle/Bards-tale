; --- a_plus_c_to_hl ---------------------------------------
; @done
; Add C to A and store the result through the shadow HL' pointer
; (exx; ld (hl),a; exx). Used to write a computed value to a buffer
; addressed by the alternate register set.
; In:  a = value, c = addend, hl' = destination address.
; Out: (hl') = a + c.
a_plus_c_to_hl:
		add	a,c
		exx
		ld	(hl),a
		exx

		ret
