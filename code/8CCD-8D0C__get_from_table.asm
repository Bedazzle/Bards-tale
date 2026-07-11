; --- get_A_from_table -------------------------------------
; @done
; Look up a byte in the ADDR_TABLE table named by the next parameter,
; at the sub-record index in A. Result is returned in A (via
; test_A_copyB, which also sets Z on zero).
; In:  a = sub-record index.  Out: a = looked-up byte.
get_A_from_table:
		push	bc
		ld	c,a
		jr	call_load_BC
; -------------------------------------

; --- get_B_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is taken from B.
; In:  b = sub-record index.  Out: a = looked-up byte.
get_B_from_table:
		push	bc
		ld	c,b
		jr	call_load_BC
; -------------------------------------

; --- get_D_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is taken from D.
; In:  d = sub-record index.  Out: a = looked-up byte.
get_D_from_table:
		push	bc
		ld	c,d
		jr	call_load_BC
; -------------------------------------

; --- get_C_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is already in C.
; In:  c = sub-record index.  Out: a = looked-up byte.
get_C_from_table:
		push	bc
		jr	call_load_BC
; -------------------------------------

; --- get_E_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is taken from E.
; In:  e = sub-record index.  Out: a = looked-up byte.
get_E_from_table:
		push	bc
		ld	c,e
		jr	call_load_BC
; -------------------------------------

; --- get_L_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is taken from L.
; In:  l = sub-record index.  Out: a = looked-up byte.
get_L_from_table:
		push	bc
		ld	c,l
		jr	call_load_BC
; -------------------------------------

; --- get_H_from_table -------------------------------------
; @done
; As get_A_from_table but the sub-record index is taken from H.
; In:  h = sub-record index.  Out: a = looked-up byte.
get_H_from_table:
		push	bc
		ld	c,h
		jr	call_load_BC
; -------------------------------------

; --- get_IY_A_from_table ----------------------------------
; @done
; As get_A_from_table but the sub-record index is read from a game
; variable: fetches a param (the VAR_* offset), patches the SMC slot
; below, then loads (iy+offset) into C as the index.
; Out: a = looked-up byte.
; Note: load_from_IY+2 is a self-modified displacement.
get_IY_A_from_table:
		push	bc
		call	get_param_to_A
		ld	(load_from_IY+2),a

load_from_IY:
		ld	c,(iy+VAR_PARTY_SIZE)		; !!! SMC

call_load_BC:
		call	do_table_lookup
		pop	bc

		ret

; --- do_table_lookup --------------------------------------
; @done
; Trampoline into lookup_addr_table (a near jp bridges the jr-range
; gap from the get_*_from_table / get_*_from_list callers).
do_table_lookup:
		jp	lookup_addr_table

; -------------------------------------

; --- get_B_from_list --------------------------------------
; @done
; Look up a byte in the table named by the next parameter at the
; sub-record index in B, and store it to the address in HL' (shadow HL).
; In:  b = sub-record index, hl' = destination address.
get_B_from_list:
		push	bc
		ld	c,b

		jr	get_from_list
; -------------------------------------

; --- get_E_from_list --------------------------------------
; @done
; As get_B_from_list but the sub-record index is taken from E.
; In:  e = sub-record index, hl' = destination address.
get_E_from_list:
		push	bc
		ld	c,e

		jr	get_from_list
; -------------------------------------

; --- get_C_from_list --------------------------------------
; @done
; As get_B_from_list but the sub-record index is already in C.
; In:  c = sub-record index, hl' = destination address.
get_C_from_list:
		push	bc

get_from_list:
		push	af
		call	do_table_lookup
		pop	af
		pop	bc
		exx
		ld	(hl),a
		exx

		ret
