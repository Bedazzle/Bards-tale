; --- divide_A_by_16 -----------------------------------------
; @done
; Divide A by 16 (shift right four times) and mask to the low
; nibble - i.e. return the high nibble of the original A.
; In:  a = value
; Out: a = a >> 4 (0..15)
divide_A_by_16:
		rra
		rra
		rra
		rra
		and	$0F

		ret
