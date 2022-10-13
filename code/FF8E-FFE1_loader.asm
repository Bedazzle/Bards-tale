		di
		ld	hl, 3D00h
		ld	(word_FF79), hl
		ld	sp, STACK_LOADER
		scf

		ld	hl, SCR_ATTR
		ld	de, SCR_ATTR+1
		ld	bc, SCR_ATTR_LEN-1
		ld	(hl), 7
		ldir

load_header:
		ld	ix, addr_FF44	; destination
		ld	de, 7			; length
		xor	a				; A->0 header
		cp	e
		ex	af, af'

		call	ROM_BYTES_LOAD

		jr	nc, load_header

		ld	b, 5
		ld	hl, addr_FF44	; loaded header
		ld	de, addr_FF5A	; filename to load

test_filename:
		ld	a, (de)
		cp	(hl)
		jr	nz, load_header

		inc	de
		inc	hl
		djnz	test_filename

		ld	ix, SCR_ATTR	; destination
		ld	de, (addr_FF49)	; length
		ld	a, 0FFh			; A->FF data
		or	a
		scf
		ex	af, af'

		ld	a, 0Fh
		out	(PORT_BORDER),	a
		di

		call	ROM_BYTES_LOAD

		jr	nc, load_header

		xor	a
		out	(PORT_BORDER),	a

		jp	binary_start
