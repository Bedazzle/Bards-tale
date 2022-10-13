run_dynamic:
		pop	hl						; skip
		pop	hl						; skip
		exx
		ex	(sp), hl				; HL=addr after	RST 10
		push	de
		ld	de, (GAME_VARIABLES + VAR_CURRENT_PARAM)
		inc	hl
		ld	(GAME_VARIABLES + VAR_CURRENT_PARAM), hl
		pop	hl
		ex	de, hl
		ex	(sp), hl
		push	hl
		push	de
		push	af
		ld	hl, (GAME_VARIABLES + VAR_CURRENT_PARAM)
		dec	hl
		ld	l, (hl)					; calculate proc address
		ld	h, 0
		add	hl, hl
		ld	de, procs_buffer
		add	hl, de
		ld	e, (hl)
		inc	hl
		ld	d, (hl)
		ld	(dynamic_funct+1), de	;	SMC to proc address
		pop	af
		pop	de
		pop	hl

dynamic_funct:
		call	0					; !!! SMC

		ex	(sp), hl
		push	de
		ld	de, (GAME_VARIABLES + VAR_CURRENT_PARAM)
		ld	(GAME_VARIABLES + VAR_CURRENT_PARAM), hl
		pop	hl
		ex	de, hl
		ex	(sp), hl

		ret
