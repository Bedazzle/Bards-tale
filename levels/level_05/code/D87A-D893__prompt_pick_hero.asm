; --- prompt_pick_hero ($D87A-$D893) ----------------------------------
; @done
; Prompt the player to pick a party member (1-6); returns the chosen hero.
; Out: b = chosen hero, carry set if cancelled

prompt_pick_hero:
		push	af
		PRINT_MESSAGE $1E
		pop	af
		PRINT2_A_WITH_FLAG_0
		PRINT_MESSAGE2 $07
		call	enter_1_to_6
		ret	c
		ld	b,a
		FIND_HERO_BY_B
		ret	z
		CHECK_HERO_STATUS
		ccf
		ret	c
		ld	a,1
		or	a
		ret
