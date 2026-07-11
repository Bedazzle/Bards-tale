; --- find_hero_by_A ---------------------------------------
; @done
; Locate a hero record by number held in A (copies A to B and falls
; into find_hero_by_B).
; In:  a = hero number
; Out: ix = hero record; see find_hero_by_B
find_hero_by_A:
		ld	b,a

; --- find_hero_by_B ---------------------------------------
; @done
; Point IX at a party member's record. Hero numbers above 6 are
; clamped to 1; IX = HEROES + hero*$65. Also fetches the hero's
; name pointer and returns carry set.
; In:  b = hero number (1-6)
; Out: ix = hero record, hl = name field, carry set; bc/de preserved
find_hero_by_B:
		ld	a,b		; in: B	= hero number
						; out: IX = start of hero block
		cp	7
		jr	c,find_hero_data

		ld	b,1

find_hero_data:
		push	bc
		push	de
		ld	de,$65
		ld	ix,HEROES
		inc	b

loop_find_hero:
		add	ix,de
		djnz	loop_find_hero

		pop	de
		pop	bc

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NAME

		scf

		ret
