get_attr_by_param:
		call	get_param_to_A

get_attr_by_A:
		push	ix
		pop	hl
		push	bc
		ld	c, a
		ld	b, 0
		add	hl, bc		; HL points to variable
		ld	a, (hl)
		call	test_A_copyB
		pop	bc

		ret

test_A_copyB:
		ld	b, a
		add	a, a		; ??? remove to	optimize
		ld	a, b		; ??? remove to	optimize
		dec	a
		inc	a

		ret
; -------------------------------------

get_attr_by_param_save_HL:
		push	hl
		call	get_attr_by_param
		pop	hl

		ret
; -------------------------------------

find_attr_and_address:
		push	af
		call	get_attr_by_param
		pop	af

		ret
; -------------------------------------

get_game_variable:
		push	ix
		push	iy
		pop	ix
		call	get_attr_by_param_save_HL
		pop	ix

		ret			; reg A contains copy of variable, flag Z is set if A=0
; -------------------------------------

get_attr_by_param_save_IX:
		push	ix
		push	iy
		pop	ix
		call	get_attr_by_param
		pop	ix

		ret
