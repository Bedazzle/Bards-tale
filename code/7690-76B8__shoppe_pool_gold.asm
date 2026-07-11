; --- shoppe_pool_gold ---------------------------------------
; @done
; Pools the whole party's gold onto one hero: for every party member
; it moves their gold into the target hero's gold field (via
; pool_gold_from_hero), so one purse holds the combined total.
; In:  ix = destination hero record
; Note: uses EXEC_FOR_HEROES to iterate the party.
shoppe_pool_gold:
		PUSH_REGS

		FIND_ATTR_AND_ADDRESS	CHAR_GOLD_END

		ex	de,hl

		EXEC_FOR_HEROES	pool_gold_from_hero

		ret

; -------------------------------------

; --- pool_gold_from_hero ------------------------------------
; @done
; EXEC_FOR_HEROES callback: adds one donor hero's 12-digit BCD gold
; into the recipient's gold field and zeroes the donor, then
; re-normalises the recipient (CONVERT_12_DIGITS). Skips the
; recipient himself (source == destination).
; In:  de = recipient gold field (LSD), ix = donor hero record
pool_gold_from_hero:
		push	de

		FIND_ATTR_AND_ADDRESS	CHAR_GOLD_END

		push	hl
		and	a
		sbc	hl,de
		pop	hl
		jr	z,pool_gold_done

		ld	c,$0C		; 12 digits

pool_nxt_gold_dig:
		ld	a,(de)
		add	a,(hl)
		ld	(de),a		; gold to recipient
		ld	(hl),0		; from donor
		dec	hl
		dec	de
		dec	c
		jr	nz,pool_nxt_gold_dig

		ex	de,hl
		push	bc

		CONVERT_12_DIGITS

		pop	bc

pool_gold_done:
		pop	de

		ret
