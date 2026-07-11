; --- divide_A_by_8 ------------------------------------------
; @done
; Unsigned divide of A by 8 (three right shifts, masking off the top 3
; bits so shifted-in carry/high bits are discarded).
; In:  a = value
; Out: a = a >> 3 (0..31)
divide_A_by_8:
		rra
		rra
		rra
		and	$1F

		ret
