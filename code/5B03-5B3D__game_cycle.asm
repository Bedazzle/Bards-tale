; --- game_cycle -------------------------------------------
; @done
; Main city / overworld walk loop. Sets up a fresh turn (zero
; scratch buffers, recalc party armour class, run the per-level
; street-step hook, clear the map-reveal flag) then spins each
; frame: on a held key it branches to press_hero_number, otherwise
; it rolls the random-encounter dice and, on a hit, runs
; combat_foes; every accepted move ends with a movement dispatch.
; In:  iy = game variables base ($5FAB)
; Note: entered by jp from INIT_GAME and after game-over; the
;       NOCITYMONSTERS build flag disables random city ambushes.
game_cycle:
		ZERO_BUFFERS

		RECALC_ALL_AC

		call	hook_street_step
		ld	(iy+VAR_REVEAL_FLAG),0

loop_city_walk:
		halt

		GET_GAME_VARIABLE	VAR_KEEP_PRESSED

		jr	nz,press_hero_number

		ld	(GAME_VARIABLES + VAR_PRESSED_KEY),a

		GET_RND_BY_PARAM	$3F

		jr	nz,no_city_ambush

		GET_RND_BY_PARAM	$3F

		IFDEF NOCITYMONSTERS
			jr	no_city_ambush
		ELSE
			jr	nz,no_city_ambush
		ENDIF

city_ambush:
		ld	(GAME_VARIABLES + VAR_AMBUSH_FLAG),a
		call	combat_foes

		DISPATCH_MOVEMENT

		jr	loop_city_walk

; -------------------------------------

no_city_ambush:
		GET_RND_BY_PARAM $3F

		jr	nz,loop_city_walk

		GET_RND_BY_PARAM	$7F

		jr	nz,loop_city_walk

		call	hook_gamecycle
		jr	c,loop_city_walk

		DISPATCH_MOVEMENT

		jr	loop_city_walk
