; --- encounter (announce_encounter) ----------------------------
; @done
; Announce the enemy encounter on screen. If the party is too divided
; (CHECK_THREE_HEROES) it prints the dissention message; otherwise it
; prints "You face death itself, in the form of:" and lists each enemy
; group as "<count> <name>".
; In:  iy = game variables base
encounter:
		CLEAR_INFO_PANEL

		CHECK_THREE_HEROES

		ld	hl,$150E
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl
		jr	nc,.face_death

		PRINT_MESSAGE	$0B			; "There is dissention in your ranks.."

		CHANGE_SPEED $0A

		jr	enc_print_done
; -------------------------------------

.face_death:
		PRINT_MESSAGE	$23			; "You face"

		PRINT_MESSAGE	$43			; "death itself, in the form of:"


; --- list_enemy_groups (list_enemy_groups) -----------------------------
; @done
; List the surviving enemy groups as "<count> <name>", separated by
; commas and "and" and wrapping the text cursor at the panel edge. If no
; groups remain it prints "hostile party members!" and returns. Re-used
; as an entry point after the "You still face:" banner.
; In:  iy = game variables base
list_enemy_groups:
		IF_FB98_IS_ZERO

		jr	nz,.list_enemies

		PRINT_MESSAGE	$59			; "hostile party members!"

		CHANGE_SPEED 8

		ret
; -------------------------------------

.list_enemies:
		ld	c,0

.next_group:
		GET_C_FROM_TABLE	$36

		ld	e,a

		PRINT_NUM_FROM_E

		dec	e
		ld	(iy+VAR_DISPLAY_COUNT),e

		GET_C_FROM_TABLE	$41

		PRINT_WORD

		inc	c
		ld	a,(GAME_VARIABLES + VAR_CURSOR_COL)
		cp	$15
		jr	nz,.check_more
		dec	(iy+VAR_CURSOR_ROW)
		ld	(iy+VAR_CURSOR_COL),$29	; 41

.check_more:
		ld	a,c
		cp	4
		jr	z,enc_print_done

		GET_C_FROM_TABLE	$36

		jr	z,enc_print_done

		ld	a,$2C ; ','

		PRINT_WITH_CODES

		ld	a,c
		cp	3
		jr	z,.print_and
		inc	a

		GET_A_FROM_TABLE	$36

		jr	nz,.wrap_or_next

.print_and:
		PRINT_MESSAGE	$69			; "and"

.wrap_or_next:
		ld	a,(GAME_VARIABLES + VAR_CURSOR_COL)
		cp	$1A
		jr	c,.next_group

		PRINT_NEWLINE

		jr	.next_group
; -------------------------------------

enc_print_done:
		PRINT_MESSAGE	$63			; ===empty message===

		ret
