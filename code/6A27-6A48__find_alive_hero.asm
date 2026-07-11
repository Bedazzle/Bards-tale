; --- find_alive_hero (find_alive_hero / dispatch $2F) -----------
; @done
; Scans the party for a hero who is present and still able to act.
; First checks the lead slot (0); otherwise walks slots 6..0, skipping
; empty slots and heroes that fail CHECK_HERO_STATUS, and accepts one
; whose CHAR_FORMER_HEALTH is non-zero. Used to decide whether combat
; can proceed / a run is possible.
; In:  iy = game variables base
; Out: carry set = an able hero exists; carry clear = none
find_alive_hero:								; FIND_ALIVE_HERO
		ld	b,0

		FIND_HERO_BY_B

		jr	z,.scan_all

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_PARAMS_HI

		jr	nz,.found

.scan_all:
		ld	b,6

.check_slot:
		FIND_HERO_BY_B

		jr	z,.next_slot

		CHECK_HERO_STATUS

		jr	nc,.next_slot

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_FORMER_HEALTH

		jr	nz,.found

.next_slot:
		dec	b
		jp	p,.check_slot

		and	a

		ret

.found:
		scf

		ret
