; --- clean_ally_memory ---------------------------------------
; @done
; Releases the summoned-ally slot. Wipes the ENEMY (ally) character
; record via the clean_hero_memory service, then zeroes the ally
; bookkeeping bytes (ALLY_STATE, FD7A_ANCHOR, ALLY_DATA) and the
; VAR_ALLY_COUNTER so no ally is considered present.
; Note: also invoked engine-wide via the CLEAN_ALLY_MEMORY macro (RST 10h id $4F).
clean_ally_memory:
		push	ix
		ld	ix,ENEMY

		CLEAN_HERO_MEMORY

		pop	ix
		xor	a
		ld	(ALLY_STATE),a
		ld	(FD7A_ANCHOR),a
		ld	(ALLY_DATA),a
		ld	(GAME_VARIABLES + VAR_ALLY_COUNTER),a

		ret
