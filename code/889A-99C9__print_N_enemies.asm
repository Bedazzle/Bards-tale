; --- print_N_enemies ----------------------------------------
; @done
; List the enemy groups in the info panel, one line each:
; "[a] <count> <group-name>", "[b] ...", up to 4 groups. Counts
; come from the table at COMBAT_ACTIVE_FLAG; printing stops at the first
; zero count. The group-name word is fetched from table $41.
; In:  iy = game variables
; Note: group labels run a, b, c, d.
print_N_enemies:
		PUSH_REGS

		ld	hl,COMBAT_ACTIVE_FLAG
		ld	b,0

loop_enemy_block:
		ld	a,(hl)
		or	a
		ret	z

		ld	a,'['

		PRINT_WITH_CODES

		ld	a,b
		add	a,'a'

		PRINT_WITH_CODES

		ld	a,']'

		PRINT_WITH_CODES

		PRINT_SPACE

		ld	a,(hl)
		ld	e,a
		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		PRINT_NUM_FROM_E

		GET_B_FROM_TABLE	$41

		PRINT_WORD

		PRINT_NEWLINE

		inc	hl
		inc	b
		ld	a,b

		cp	4
		jr	nz,loop_enemy_block

		ret
