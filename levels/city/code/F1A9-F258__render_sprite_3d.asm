; --- render_sprite_3d ------------------------------------------------
; @done
; Draw one creature/monster sprite into the 3D city view.
; display_walls_creatures calls this once per occupied view slot.
; The slot index selects a sprite id (GET_C_FROM_TABLE 8), which
; indexes the pointer table at CITY_SPRITE_DATA to reach the sprite
; record (width/height + RLE stream). The on-screen position is
; built from the current view attributes (GET_C_FROM_TABLE 5/7):
; base $3EFF plus the column and row/pixel-line offsets. The RLE
; stream is then decoded row by row - each data byte is mapped
; through the pixel table SPRITE_PIXEL_XLAT (CITY_SPRITE_DATA+$240), its
; mask computed by decode_sprite_mask, and the result AND/OR-composited with
; attributes written at char-cell boundaries.
; In:  a = view slot index (0-based); rst-10h view attr tables
; Out: sprite drawn to the screen buffer
; Note: purpose partially inferred - sprite record layout and the
;       exact RLE token scheme are read from the code, not docs
render_sprite_3d:
		ld	e,a

		GET_C_FROM_TABLE	8

		ld	d,a
		ld	hl,CITY_SPRITE_DATA
		add	a,l
		ld	l,a
		jr	nc,.load_record
		inc	h

.load_record:
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		ld	b,(hl)
		inc	hl

		GET_C_FROM_TABLE	7

		push	af

		GET_C_FROM_TABLE	5

		ld	c,a
		pop	af
		push	hl
		push	de
		ld	hl,$3EFF

.calc_screen:
		add	a,l
		ld	l,a
		jr	nc,.col_no_carry
		inc	h

.col_no_carry:
		ld	a,b
		call	divide_A_by_8
		ld	de,$20

.add_char_rows:
		add	hl,de
		dec	a
		jp	p,.add_char_rows

		ld	a,b
		and	7
		ld	de,$0100

.add_pixel_lines:
		add	hl,de
		dec	a
		jp	p,.add_pixel_lines

		pop	de
		exx
		ld	b,1
		pop	hl
		exx

.row_loop:
		ld	b,d
		inc	b
		push	hl
		push	de
		xor	a
		ex	af,af'

.pixel_loop:
		push	hl
		exx
		dec	b
		ld	a,c
		jr	nz,.emit_byte

		ld	b,1
		ld	a,(hl)
		dec	a
		jr	nz,.literal_byte

		inc	hl
		ld	b,(hl)
		inc	hl
		ld	c,(hl)

.literal_byte:
		ld	a,(hl)
		inc	hl

.emit_byte:
		exx
		ld	e,a
		ld	d,0
		dec	c
		inc	c
		jr	z,.no_xlat

		ld	hl,SPRITE_PIXEL_XLAT
		add	hl,de
		ld	e,(hl)

.no_xlat:
		call	decode_sprite_mask
		cpl
		pop	hl
		and	(hl)
		or	e
		ld	(hl),a
		jr	z,.next_scanline

		ex	af,af'
		inc	a
		ex	af,af'

.next_scanline:
		inc	h
		ld	a,h
		and	7
		jr	nz,.next_col

		ex	af,af'
		cp	8
		jr	nz,.skip_attr

		push	hl
		dec	h
		ld	a,h
		rra
		rra
		rra
		rra
		ld	a,$58 ; 'X'
		adc	a,0
		ld	h,a
		ld	a,(SCR_ATTR+$21)
		ld	(hl),a
		pop	hl

.skip_attr:
		xor	a
		ex	af,af'
		ld	a,l
		add	a,$20 ; ' '
		ld	l,a
		jr	c,.next_col

		ld	a,h
		sub	8
		ld	h,a

.next_col:
		djnz	.pixel_loop

		pop	de
		pop	hl
		dec	c
		inc	c
		jr	z,.next_row

		dec	hl
		dec	hl

.next_row:
		inc	hl
		dec	e
		jr	nz,.row_loop

		ret
