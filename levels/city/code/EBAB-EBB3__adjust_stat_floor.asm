; --- adjust_stat_floor -------------------------------------------------
; @done
; Fold a raw roll into a running gain total in b, with a floor:
; take a-14 (clamped to 0 if it would underflow) then set
; b = b + that + 1.  Used by do_advancement to accumulate the
; per-level condition / spell-point increases.
; In:  a = raw value, b = running total
; Out: b = updated total
; Note: exact stat semantics partially inferred.
adjust_stat_floor:
		sub	$0E
		jr	nc,.add_to_b

		xor	a

.add_to_b:
		add	a,b
		inc	a
		ld	b,a

		ret
