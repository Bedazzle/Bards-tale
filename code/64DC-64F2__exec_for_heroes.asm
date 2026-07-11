; --- exec_for_heroes ------------------------------------------
; @done
; Call a caller-supplied routine once for every party member. Reads a
; 16-bit routine address from two inline params, patches it into the SMC
; "call nz" slot (hero_function+1), then walks all 6 hero slots
; (FIND_HERO_BY_B); the routine is called only for slots that hold a
; hero.
; In:  two inline params = low/high byte of the per-hero routine address
; Note: self-modifies hero_function+1; preserves HL.
exec_for_heroes:
		push	hl
		call	get_param_to_A

		ld	l,a
		call	get_param_to_A

		ld	h,a
		ld	b,6			; number of heros
		ld	(hero_function+1),hl
		pop	hl

loop_find_addr:
		FIND_HERO_BY_B

hero_function:
		call	nz,$		; !!! SMC
		djnz	loop_find_addr

		ret
