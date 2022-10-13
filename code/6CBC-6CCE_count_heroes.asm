count_heroes:
		push	ix
		ld	b, 6

loop_find_count:
		FIND_HERO_BY_B

		jr	nz, hero_found
		djnz	loop_find_count

hero_found:
		ld	a, (ENEMY)		; check if only one active hero
		add	a, 0FFh			; then set C flag, otherwise C unset
		ld	a, b
		pop	ix

		ret
