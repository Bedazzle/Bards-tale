; --- lookup_addr_table ------------------------------------------------
; @done
; Resolve a variable-length record address from ADDR_TABLE. Fetches a
; parameter (get_param_to_A), looks up ADDR_TABLE[param] for a base
; pointer, then walks forward over $FC-terminated records to reach the
; requested sub-record, handing the resulting byte/address to
; test_A_copyB.
; Note: purpose partially inferred. lookup_addr_by_A is an alternate entry
;       (b/a preset) used by the main dispatcher.
lookup_addr_table:
		PUSH_REGS

		ld	b,0
		call	get_param_to_A

; --- lookup_addr_by_A ------------------------------------------------
; @done
; Alternate entry to the lookup_addr_table table lookup, entered from the main
; dispatch (BT_game) with the record index already in a and the skip
; counter seeded in b; skips the register-save and parameter fetch and
; falls into calc_addr_from_A.
; In:  a = table index, b = record-skip count (high)
lookup_addr_by_A:
		cp	$72			; 114
		jr	c,calc_addr_from_A

		inc	bc

calc_addr_from_A:					; get address from table, A=position
		ld	l,a
		ld	h,0
		add	hl,hl
		ld	de,ADDR_TABLE
		add	hl,de
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		ld	(addr_table_index),a

		cp	$67 		; 103
		ld	a,$FC
		jr	nc,.have_marker

		xor	a

.have_marker:
		ex	af,af'

.next_entry:
		ld	a,b
		or	c
		jr	z,.resolve

		ex	af,af'

.find_end:
		ex	af,af'
		ld	a,$FC
		cpir
		jr	nz,.resolve

		ld	a,(addr_table_index)

		cp	$67 		; 103
		jr	nc,.check_end

		ld	a,c
		or	b
		jr	z,.resolve

.check_end:
		ex	af,af'

		cp	$FC
		jr	nz,.find_end

		ex	af,af'
		ld	a,c
		ld	c,(hl)
		dec	c
		sub	c
		inc	hl
		inc	hl
		ld	c,a
		jr	nc,.next_entry

		dec	b
		jp	p,.next_entry

.resolve:
		dec	hl
		ld	a,(hl)
		push	hl
		exx
		pop	hl
		exx

		jp	test_A_copyB

; -------------------------------------
addr_table_index:
		DB 0
