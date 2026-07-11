; --- cast_spell ----------------------------------------------
; @done
; The (C)ast action: pick the caster (who_cast_spell), read the spell
; and its target range; for single-target spells prompt "Cast at" and
; select a target, otherwise skip target selection. Stores the target
; in VAR_TARGET_ID and hands off to casts_a_spell. Dispatch handler.
cast_spell:
		call	who_cast_spell
		ret	c

		GET_IY_A_FROM_TABLE	$4B,$69

		and	7

		cp	4
		jr	nc,.set_target

		push	af

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	5			; "Cast at"

		pop	af

		SELECT_TARGET

		ret	c

.set_target:
		ld	(GAME_VARIABLES + VAR_TARGET_ID),a

		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		jp	casts_a_spell
