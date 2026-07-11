; --- party_disbelieve ----------------------------------------
; @done
; Combat action: the party tries to "disbelieve" (dispel) up to three
; illusionary enemy groups. It scans the three group slots (ids $83
; down to $81); for each group that qualifies on the two group tables
; ($36 and $42) it — unless anti-magic is in force — rolls a save via
; the local check below, and on success flags the group with damage
; type 6, applies it through apply_damage_to_group and prints "The party
; disbelieves...". Clears the anti-magic flag before returning.
; In:  iy = game variables base
party_disbelieve:
		ld	c,3
		ld	e,$83

.next_group:
		GET_C_FROM_TABLE	$36

		jr	z,.continue

		GET_C_FROM_TABLE	$42

		jr	z,.continue

		GET_GAME_VARIABLE	VAR_ANTIMAGIC			; ???

		jr	nz,.disbelieve

		call	disbelieve_roll
		jr	c,.continue

		jr	nz,.continue

.disbelieve:
		ld	a,1

		GET_C_FROM_LIST	$36

		ld	(iy+VAR_DAMAGE_TYPE),6
		ld	a,e
		call	apply_damage_to_group

		PRINT_MESSAGE	$29			; "The party disbelieves..."

		CHANGE_COMBAT_SPEED

.continue:
		dec	e
		dec	c
		jp	m,.next_group

		GET_GAME_VARIABLE	VAR_ANTIMAGIC			; ???

		ret	c

		xor	a
		ld	(GAME_VARIABLES + VAR_ANTIMAGIC),a

		ret

; --- disbelieve_roll ------------------------------------------------
; @done
; Save/flee roll used by party_disbelieve. Points the effect at a
; dummy target (active-hero $80, target id 1) and runs the shared
; CHECK_FLEE_RESULT check, returning its carry (and Z via the trailing
; or a) so the caller can decide whether the disbelieve succeeds.
; In:  iy = game variables base
; Out: carry / Z from CHECK_FLEE_RESULT
disbelieve_roll:
		ld	(iy+VAR_ACTIVE_HERO),$80
		ld	(iy+VAR_TARGET_ID),1

		CHECK_FLEE_RESULT

		ret	c
		or	a

		ret
