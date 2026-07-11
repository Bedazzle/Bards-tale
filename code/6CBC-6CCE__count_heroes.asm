; --- count_heroes -----------------------------------------
; @done
; Find an active party member and report the party-size test used
; for singular/plural wording. Scans the 6 hero slots top-down
; (FIND_HERO_BY_B) and returns the slot of the first active hero;
; the ENEMY counter byte is then folded into the carry flag as the
; single-hero test the callers branch on.
; In:  iy = game variables base
; Out: b = active hero slot; carry = single-hero test
; Note: exact meaning of the carry test partially inferred
count_heroes:
		push	ix
		ld	b,6

loop_find_count:
		FIND_HERO_BY_B

		jr	nz,hero_found
		djnz	loop_find_count

hero_found:
		ld	a,(ENEMY)		; check if only one active hero
		add	a,$FF			; then set C flag, otherwise C unset
		ld	a,b
		pop	ix

		ret
