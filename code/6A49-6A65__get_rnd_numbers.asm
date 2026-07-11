; --- get_rnd_numbers ----------------------------------------
; @done
; Advances the game's pseudo-random generator. Mixes the Z80 R
; refresh register into the two-byte seed (VAR_RND_LO / VAR_RND_HI),
; folding in bytes from both the main and alternate HL pointers
; (xor_by_hl), and writes the new low and high seed bytes back.
; In:  iy = game variables base, hl/hl' = entropy pointers
; Out: a, VAR_RND_LO, VAR_RND_HI updated
get_rnd_numbers:
		ld	a,r
		xor	(iy+VAR_RND_LO)

		call	xor_by_hl

		ld	(GAME_VARIABLES + VAR_RND_LO),a
		xor	(iy+VAR_RND_HI)
		ex	de,hl
		xor	(hl)
		ex	de,hl

		call	xor_by_hl

		ld	(GAME_VARIABLES + VAR_RND_HI),a

		ret

; --- xor_by_hl ----------------------------------------------
; @done
; Helper for get_rnd_numbers: XORs A with the byte at (hl) and with the
; byte at the alternate-set (hl'), stirring two independent pointers
; into the accumulator.
; In:  a = value, hl / hl' = pointers
; Out: a = a XOR (hl) XOR (hl')
xor_by_hl:
		xor	(hl)
		exx
		xor	(hl)
		exx

		ret
