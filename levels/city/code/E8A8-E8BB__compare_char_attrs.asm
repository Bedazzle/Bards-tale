; --- compare_char_attrs -----------------------------------------------
; @done
; Compare the current hero's 4-byte CHAR_SAVED_STATS block against
; the 4-byte reference table at SWAP_STAT_TEMPLATE. Used to detect whether
; the hero's saved stats still hold the default/template values
; (e.g. before restoring backed-up params on advancement / healing).
; In:  ix = hero record
; Out: Z (a=0) if all 4 bytes match; NZ on the first mismatch
compare_char_attrs:
		PUSH_REGS

		ld	b,4
		ld	de,SWAP_STAT_TEMPLATE+3	;7DB7h

		FIND_ATTR_AND_ADDRESS	CHAR_SAVED_STATS

.compare:
		ld	a,(de)

		cp	(hl)
		jr	nz,locret_E8BB

		dec	de
		dec	hl
		djnz	.compare

		xor	a

locret_E8BB:
		ret
