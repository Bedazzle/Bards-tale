get_A_from_table:
		push	bc
		ld	c, a
		jr	call_load_BC
; -------------------------------------

get_B_from_table:
		push	bc
		ld	c, b
		jr	call_load_BC
; -------------------------------------

get_D_from_table:
		push	bc
		ld	c, d
		jr	call_load_BC
; -------------------------------------

get_C_from_table:
		push	bc
		jr	call_load_BC
; -------------------------------------

get_E_from_table:
		push	bc
		ld	c, e
		jr	call_load_BC
; -------------------------------------

get_L_from_table:
		push	bc
		ld	c, l
		jr	call_load_BC
; -------------------------------------

get_H_from_table:
		push	bc
		ld	c, h
		jr	call_load_BC
; -------------------------------------

get_IY_A_from_table:
		push	bc
		call	get_param_to_A
		ld	(load_from_IY+2), a

load_from_IY:
		ld	c, (iy+VAR_00)		; !!! SMC

call_load_BC:
		call	sub_8CF7
		pop	bc

		ret

; ======= S U B	R O U T	I N E =========

sub_8CF7:
		jp	loc_7144

; -------------------------------------

get_B_from_list:
		push	bc
		ld	c, b

		jr	get_from_list
; -------------------------------------

get_E_from_list:
		push	bc
		ld	c, e

		jr	get_from_list
; -------------------------------------

get_C_from_list:
		push	bc

get_from_list:
		push	af
		call	sub_8CF7
		pop	af
		pop	bc
		exx
		ld	(hl), a
		exx

		ret
