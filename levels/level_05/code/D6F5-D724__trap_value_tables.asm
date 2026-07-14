; --- trap_value_tables ($D6F5-$D724) ----------------------------------
; @done

trap_value_tables:
		nop
		ld	bc,0
		ld	bc,$300
		dec	b
		ld	bc,$201
		inc	b
		inc	bc
		rlca
		ld	bc,1
		nop
		ld	bc,$101
		ld	bc,$302
		inc	bc
		inc	b
		inc	b
		dec	b
		inc	bc
		inc	b
		dec	b
		dec	b
		dec	b
		ld	b,6
		rlca
		dec	b
		ld	b,7
		rlca
		ld	b,5
		rlca
		rlca
		dec	b
		ld	b,7
		rlca
