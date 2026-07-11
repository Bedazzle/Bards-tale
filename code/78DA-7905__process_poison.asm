; --- process_poison ------------------------------------------
; @done
; Per-turn poison tick. Walks all 6 party slots; for each hero whose
; CHAR_STATUS is "poisoned" (1) it subtracts a table-driven poison
; amount from the hero's current condition (CHAR_COND 16-bit). If the
; condition underflows past zero it is clamped to 0 and the hero is
; marked STATUS_DEAD. Refreshes the party stats table when done.
; In:  iy = game variables base
process_poison:
		ld	b,6

loop_poisoned:
		FIND_HERO_BY_B

		jr	z,search_nxt_poison

		ld	a,(ix+CHAR_STATUS)
		dec	a
		jr	nz,search_nxt_poison

poisoned_char:
		GET_IY_A_FROM_TABLE	$54,$4B

		ld	c,a

		GET_ATTR_BY_PARAM	CHAR_COND_LO

		sub	c
		ld	(hl),a
		dec	hl
		ld	a,(hl)
		sbc	a,0
		ld	(hl),a
		jr	nc,search_nxt_poison

		xor	a
		ld	(hl),a
		inc	hl
		ld	(hl),a
		ld	(ix+CHAR_STATUS),STATUS_DEAD

search_nxt_poison:
		dec	b
		jp	p,loop_poisoned

		jp	print_stats_table
