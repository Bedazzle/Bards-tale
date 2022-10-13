dyn_proc_61:						; RST_10_30
		PUSH_REGS

		ld	b, a
		dec	b
		jp	m, loc_6C53
		jr	z, loc_6C49

		dec	b
		jr	z, loc_6C26

		dec	b
		jr	z, loc_6BFA

		ld	a, (byte_FB99)
		or	a
		jr	nz, loc_6BDB

		and	a
		ld	a, 80h

		ret

loc_6BDB:
		call	print_group
		ld	a, 'B'

		PRINT_WITH_CODES

		PRINT_MESSAGE	56h		; "]"

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort"

loop_for_action:
		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jp	z, abort_action

		sub	'A'
		jr	c, loop_for_action

		cp	2
		jr	nc, loop_for_action

		or	80h

		ret

loc_6BFA:
		PRINT_MEMBERS_COUNT

		call	print_s_bracket

		RST_10_5D

		jr	c, loc_6C21

		ld	a, b
		call	sub_6CAB

		PRINT_MESSAGE	58h			; "or"

		ld	a, b
		or	a
		jr	nz, loc_6C15

		PRINT_IN_LOOP
		db  57h, 56h, 0FFh			; "group [A"
									; "]"

		jr	loc_6C21

loc_6C15:
		call	print_group
		ld	a, (GAME_VARIABLES + VAR_70)
		dec	a

		PRINT_WITH_CODES

		PRINT_MESSAGE	56h			; "]"

loc_6C21:
		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort"

		jr	loc_6C5B

loc_6C26:
		call	sub_6CB1

		RST_10_5D

		jr	c, loc_6C31

		ld	a, b
		or	a
		jr	nz, loc_6C35

loc_6C31:
		ld	a, 80h
		and	a

		ret

loc_6C35:
		call	sub_6CAB
		call	print_group
		ld	a, (GAME_VARIABLES + VAR_70)
		dec	a

		PRINT_WITH_CODES

		PRINT_MESSAGE	56h		; "]"

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort

		jr	loc_6C5B

loc_6C49:
		PRINT_MEMBERS_COUNT

		call	print_s_bracket

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort

		jr	loc_6C5B

loc_6C53:
		PRINT_MEMBERS_COUNT

		PRINT_MESSAGE	56h		; "]"

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort

loc_6C5B:
		ld	hl, GAME_VARIABLES + VAR_6E

		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	z, abort_action

		cp	'1'
		jr	c, loc_6C5B

		cp	(hl)
		jr	c, loc_6C7E

		inc	hl

		cp	(hl)
		jr	z, loc_6C7C

		cp	'A'
		jr	c, loc_6C5B

		inc	hl

		cp	(hl)
		jr	nc, loc_6C5B

		sub	'A'
		or	80h

		ret

loc_6C7C:
		ld	a, '0'

loc_6C7E:
		sub	'0'

		ret

abort_action:
		scf

		ret
