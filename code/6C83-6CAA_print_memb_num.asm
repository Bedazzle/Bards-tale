print_memb_num:
		PUSH_REGS

		call	sub_6CB1

		PRINT_MESSAGE	54h			; "member   [1-"

		call	count_heroes
		push	af
		add	a, '1'
		ld	(GAME_VARIABLES + VAR_6E), a
		pop	af

		PRINT_DIGIT

		ret
; -------------------------------------

print_s_bracket:
		PUSH_REGS

		call	count_heroes
		jr	nc, print_r_bracket

		ld	(iy+VAR_6F), 'S'

		PRINT_MESSAGE	38h			; "S]"

		ret
; -------------------------------------

print_r_bracket:
		PRINT_MESSAGE	56h			; "]"

		ret
