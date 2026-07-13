; --- calc_in_FB7D ---------------------------------------------
; @done
; Point HL at group record B inside the FB7D combat table (100 bytes per
; record) via calculate_addr.
; In:  b = group index
; Out: hl = FB7D + 100*(b+1)
calc_in_FB7D:
		ld	hl,DISPLAY_PALETTE+$A

		jr	calculate_addr
; -------------------------------------

; --- calc_in_FD7A ---------------------------------------------
; @done
; Point HL at record B inside the FD7A table (100 bytes per record) via
; calculate_addr.
; In:  b = index
; Out: hl = FD7A + 100*(b+1)
calc_in_FD7A:
		ld	hl,FD7A_ANCHOR+$2

; --- calculate_addr -------------------------------------------
; @done
; Advance HL by 100 bytes for each of (B+1) records - the shared index
; step for the 100-byte-per-group combat tables.
; In:  hl = table base, b = index
; Out: hl = base + 100*(b+1)
; Note: preserves BC and DE.
calculate_addr:
		push	de
		push	bc
		ld	de,$64
		inc	b

.add_stride:
		add	hl,de
		djnz	.add_stride

		pop	bc
		pop	de

		ret
