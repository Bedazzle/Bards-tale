loc_890D:
		ld	a, (GAME_VARIABLES + VAR_2E)
		inc	a
		jr	nz, loc_8917

		ld	(GAME_VARIABLES + VAR_2E), a

		ret

loc_8917:
		ld	a, 0FFh
		ld	(GAME_VARIABLES + VAR_2E), a

		ret
;***************************
; can be optimized (4 bytes) to
;
;loc_890D:
;		ld	a, (GAME_VARIABLES + VAR_2E)
;		inc	a
;		jr	z, put_a_back
;
;		ld	a, 0FFh
;put_a_back:
;		ld	(GAME_VARIABLES + VAR_2E), a
;
;		ret
;***************************