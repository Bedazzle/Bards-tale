; --- choose_hero ----------------------------------------------
; @done
; Prompts the player to pick a party member (1-6) and validates the
; choice. Stores the slot in VAR_ACTIVE_HERO, locates the hero
; record, rejects an empty slot or a hero whose status forbids
; acting, and echoes the chosen digit.
; Out: CF set = aborted or the hero can't act; Z set (with NC) = the
;      slot is empty; else a = hero index, ix = hero record, NC/NZ
choose_hero:
		ENTER_1_TO_6

		ret	c

		ld	(GAME_VARIABLES + VAR_ACTIVE_HERO),a

		FIND_HERO_BY_A

		ret	z

		CHECK_HERO_STATUS

		ccf
		ret	c

		ld	a,b

		PRINT_DIGIT

		ld	a,b
		and	a

		ret
