; --- is_roster_full -----------------------------------------
; @done
; Scans roster slots 1..6 for an empty hero record.
; Out: carry set if the roster is full; when not full, carry clear
;      and b = index of the first empty slot.
; Note: FIND_HERO_BY_B reports the empty slot via Z.
is_roster_full:
		ld	b,1

loop_roster:
		FIND_HERO_BY_B

		jr	z,empty_hero_found

		inc	b
		ld	a,b
		sub	7
		jr	c,loop_roster

empty_hero_found:
		ccf

		ret
