; --- find_hero_by_name --------------------------------------
; @done
; Search the 6-slot party roster for a hero whose 15-char name
; matches the text just typed into TEXT_BUFFER. Pads the typed
; name out to 15 chars with spaces (plus an $FF sentinel) so the
; compare always runs the full name width, then walks slots 6..1
; comparing byte-for-byte.
; In:  b = length of typed name, TEXT_BUFFER = name
; Out: carry set + ix = matched hero record if found;
;      carry clear if no match
find_hero_by_name:
		ld	hl,TEXT_BUFFER
		ld	c,b
		ld	b,0
		add	hl,bc					; HL = end of name
		ld	a,c

loop_clr_txtbuf:
		ld	(hl),$20 				; ' '
		inc	hl
		inc	a

		cp	$10						; hero name length = 15
		jr	c,loop_clr_txtbuf

		ld	(hl),$FF
		ld	b,6

loop_for_heroes:
		FIND_HERO_BY_B

		ld	hl,TEXT_BUFFER
		ld	c,$0F					; hero name length = 15

name_check:
		ld	a,(ix+CHAR_NAME)

		cp	(hl)
		jr	nz,mismatch_hero

		inc	hl
		inc	ix
		dec	c
		jr	nz,name_check

		jp	find_hero_by_B

mismatch_hero:
		dec	b
		jp	p,loop_for_heroes

		and	a

		ret
