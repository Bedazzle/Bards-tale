loc_669A:
		ld	b, 3

loc_669C:
		GET_B_FROM_TABLE	36h

		jr	z, loc_66E3

		GET_B_FROM_TABLE	41h

		ld	d, a

		RST_10_61	70h, 1Fh

		ld	c, a
		dec	b

		GET_B_FROM_TABLE	41h

		inc	b

		RST_10_61	70h, 1Fh

		cp	c
		jr	nc, loc_66E3

		push	de

		CALC_IN_FB7D

		dec b
		ex de, hl

		CALC_IN_FB7D

		inc b
		ld	a, 64h

		call	swap_byte_buffer
		pop	de
		ld	e, 4
		ld	hl, addr_66E8

loc_66C9:
		ld	a, (hl)
		inc	hl
		call	loc_66EC
		dec	e
		jr	nz, loc_66C9

		dec	a
		ld	(GAME_VARIABLES + VAR_4F), a

		PRINT_CRLF_AND_MESSAGE	0Ch			; "The"

		ld	a, d

		PRINT_WORD

		PRINT_MESSAGE	5Ah					; "advances!"

		PRINT_NEWLINE

		CHANGE_SPEED 5

loc_66E3:
		djnz	loc_669C

		jp	show_some_pictext

; -------------------------------------
		db  57h	; W
		db  41h	; A
		db  42h	; B
		db  36h	; 6
; -------------------------------------

loc_66EC:
		ld	(byte_66F2+2), a
		ld	(byte_66FA+2), a

byte_66F2:
		GET_B_FROM_TABLE	42h

		push	af
		exx
		push	hl
		exx
		dec	b

byte_66FA:
		GET_B_FROM_TABLE	42h

		inc	b
		exx
		ex	(sp), hl
		ld	(hl), a
		pop	hl
		pop	af
		ld	(hl), a
		exx

		ret
