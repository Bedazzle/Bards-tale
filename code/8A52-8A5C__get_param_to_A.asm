; --- get_param_to_A ---------------------------------------
; @done
; Fetch the next parameter byte from the RST-10h parameter stream:
; reads the byte at VAR_CURRENT_PARAM, advances that pointer, and
; returns the byte in A.
; Out: a = parameter byte.
; Note: preserves hl; VAR_CURRENT_PARAM is the shared stream cursor.
get_param_to_A:
		push	hl
		ld	hl,(GAME_VARIABLES + VAR_CURRENT_PARAM)
		ld	a,(hl)
		inc	hl
		ld	(GAME_VARIABLES + VAR_CURRENT_PARAM),hl
		pop	hl

		ret
