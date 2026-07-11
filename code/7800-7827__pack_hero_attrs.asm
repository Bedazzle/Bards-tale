; --- pack_hero_attrs ----------------------------------------
; @done
; Inverse of unpack_hero_attrs: packs the five attribute bytes at
; GUARDIAN_TYPE back into the two packed attribute words
; (CHAR_PARAMS_HI/LO) of the hero record, preserving the two low
; bits already stored there.
; In:  ix = hero record, GUARDIAN_TYPE = unpacked attributes
; Out: (ix+CHAR_PARAMS_HI/LO) updated
pack_hero_attrs:
		PUSH_REGS

		ld	b,2
		ld	de,GUARDIAN_TYPE

loop_pack_attrs:
		ld	a,(de)
		ld	h,a
		inc	de
		ld	a,(de)
		inc	de
		rla
		rla
		rla
		ld	l,a
		add	hl,hl
		add	hl,hl
		add	hl,hl
		ex	de,hl
		ld	a,e
		and	$C0
		or	(hl)
		ld	e,a
		ex	de,hl
		ld	(ix+CHAR_PARAMS_HI),h
		ld	(ix+CHAR_PARAMS_LO),l
		inc	ix
		inc	ix
		inc	de
		djnz	loop_pack_attrs

		ret
