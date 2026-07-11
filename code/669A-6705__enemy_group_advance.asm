; --- enemy_group_advance (enemy_group_advance) ---------------------------
; @done
; Let enemy groups close ranks. For the 3 rear groups it compares each
; group's advance value against the group ahead (CHECK_ITEM_MASK table
; $70) and, when it should move up, swaps the two group records
; (swap_byte_buffer) plus their fields and prints "The <group>
; advances!". Ends by refreshing the picture/text via show_some_pictext.
; In:  iy = game variables base
enemy_group_advance:
		ld	b,3

.grp_loop:
		GET_B_FROM_TABLE	$36

		jr	z,.next_grp

		GET_B_FROM_TABLE	$41

		ld	d,a

		CHECK_ITEM_MASK	$70,$1F

		ld	c,a
		dec	b

		GET_B_FROM_TABLE	$41

		inc	b

		CHECK_ITEM_MASK	$70,$1F

		cp	c
		jr	nc,.next_grp

		push	de

		CALC_IN_FB7D

		dec b
		ex de,hl

		CALC_IN_FB7D

		inc b
		ld	a,$64

		call	swap_byte_buffer
		pop	de
		ld	e,4
		ld	hl,GROUP_FIELD_IDS

.copy_loop:
		ld	a,(hl)
		inc	hl
		call	swap_group_field
		dec	e
		jr	nz,.copy_loop

		dec	a
		ld	(GAME_VARIABLES + VAR_DISPLAY_COUNT),a

		PRINT_CRLF_AND_MESSAGE	$0C			; "The"

		ld	a,d

		PRINT_WORD

		PRINT_MESSAGE	$5A					; "advances!"

		PRINT_NEWLINE

		CHANGE_SPEED 5

.next_grp:
		djnz	.grp_loop

		jp	show_some_pictext

; -------------------------------------
; Field table-ids that swap_group_field swaps between the two groups on advance.
GROUP_FIELD_IDS:
		DB $57	; W
		DB $41	; A
		DB $42	; B
		DB $36	; 6
; -------------------------------------

; --- swap_group_field (swap_group_field) ------------------------------
; @done
; Swap one field between two adjacent enemy groups. A selects the field
; table-id, patched into both GET_B_FROM_TABLE lookups (.read_this /
; .read_prev); the field is read for group B and group B-1 and the two
; stored bytes are exchanged.
; In:  a = field table-id, b = group index
; Note: self-modifies both lookup operands; uses the alt register set.
swap_group_field:
		ld	(.read_this+2),a
		ld	(.read_prev+2),a

.read_this:
		GET_B_FROM_TABLE	$42

		push	af
		exx
		push	hl
		exx
		dec	b

.read_prev:
		GET_B_FROM_TABLE	$42

		inc	b
		exx
		ex	(sp),hl
		ld	(hl),a
		pop	hl
		pop	af
		ld	(hl),a
		exx

		ret
