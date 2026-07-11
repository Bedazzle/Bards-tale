; --- get_attr_by_param ------------------------------------
; @done
; Read an attribute byte from the current hero record (IX). Fetches the
; next parameter (the attribute offset), then falls into get_attr_by_A.
; Out: a = attribute byte, hl -> that byte, Z set if it is zero.
get_attr_by_param:
		call	get_param_to_A

; --- get_attr_by_A ----------------------------------------
; @done
; Read the attribute at offset A from the record based at IX: computes
; HL = IX + A, loads the byte, and returns it in A (Z set if zero) with
; HL pointing at it.
; In:  a = attribute offset, ix = record base.
; Out: a = attribute byte, hl -> that byte, b = copy, Z if zero.
get_attr_by_A:
		push	ix
		pop	hl
		push	bc
		ld	c,a
		ld	b,0
		add	hl,bc		; HL points to variable
		ld	a,(hl)
		call	test_A_copyB
		pop	bc

		ret

; --- test_A_copyB -----------------------------------------
; @done
; Copy A into B and set the flags to reflect A (Z if A is zero). The
; add/dec/inc sequence is a redundant way of exercising the flags.
; In:  a = value.  Out: b = a, flags reflect a.
test_A_copyB:
		ld	b,a
		add	a,a		; ??? remove to	optimize
		ld	a,b		; ??? remove to	optimize
		dec	a
		inc	a

		ret
; -------------------------------------

; --- get_attr_by_param_save_HL ----------------------------
; @done
; Like get_attr_by_param but preserves HL (returns only the attribute
; byte in A, Z set if zero).
; Out: a = attribute byte, Z if zero.
get_attr_by_param_save_HL:
		push	hl
		call	get_attr_by_param
		pop	hl

		ret
; -------------------------------------

; --- find_attr_and_address --------------------------------
; @done
; Like get_attr_by_param but preserves the caller's AF, so the caller
; keeps both the returned attribute address in HL and its own flags.
; Out: hl -> attribute byte, a = attribute byte.
find_attr_and_address:
		push	af
		call	get_attr_by_param
		pop	af

		ret
; -------------------------------------

; --- get_game_variable ------------------------------------
; @done
; Read a game variable: same attribute lookup as get_attr_by_param but
; based at IY (GAME_VARIABLES) instead of the hero record, restoring IX.
; Out: a = copy of the variable, Z set if it is zero.
get_game_variable:
		push	ix
		push	iy
		pop	ix
		call	get_attr_by_param_save_HL
		pop	ix

		ret			; reg A contains copy of variable, flag Z is set if A=0
; -------------------------------------

; --- get_attr_by_param_save_IX ----------------------------
; @done
; Read a game variable based at IY (GAME_VARIABLES) and return HL
; pointing at it, restoring the caller's IX afterwards.
; Out: a = variable byte, hl -> that byte, Z if zero.
get_attr_by_param_save_IX:
		push	ix
		push	iy
		pop	ix
		call	get_attr_by_param
		pop	ix

		ret
