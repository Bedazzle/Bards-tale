; --- unpack_hero_attrs --------------------------------------
; @done
; Unpacks a hero's two packed attribute words (CHAR_PARAMS_HI/LO)
; into five separate attribute bytes (St, IQ, Dx / Cn, Lk, ?) in the
; buffer at GUARDIAN_TYPE, splitting each 16-bit word into 5-bit fields.
; In:  ix = hero record
; Out: GUARDIAN_TYPE.. filled with unpacked attributes
; Note: bit layout documented in the trailing comment.
unpack_hero_attrs:
		PUSH_REGS

		ld	b,2
		ld	de,GUARDIAN_TYPE

loop_unpack_attrs:
		ld	h,(ix+CHAR_PARAMS_HI)
		ld	l,(ix+CHAR_PARAMS_LO)
		ld	a,h
		call	divide_A_by_8
		ld	(de),a		; put St on first loop, then Cn on second
		inc	de
		push	hl
		add	hl,hl
		add	hl,hl
		ld	a,h
		and	$1F
		ld	(de),a		; put IQ, then Lk
		inc	de
		pop	hl
		ld	a,l
		and	$1F
		ld	(de),a		; put Dx, then ???
		inc	de
		inc	ix
		inc	ix
		djnz	loop_unpack_attrs

		ret

		; 10h        11h          10h        11h
		; 0000-0|000 00|0|0-0000| 0000-0|000 00|0|0-0000
		; ST     IQ     ? DX      CN     LK     ? ?
