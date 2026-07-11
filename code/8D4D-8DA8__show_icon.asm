; --- show_icon --------------------------------------------
; @done
; Fetch an icon code from the parameter stream and draw it (falls into
; show_icon_A).
show_icon:
		call	get_param_to_A

; --- show_icon_A ------------------------------------------
; @done
; Draw the 2x3-cell icon whose code is in A into the icon window. Code
; $0C is special: it clears the current icon state (VAR_ICON_CODE and the
; equipped-item copy) and recalculates party AC before rendering. Codes
; below ICON_SPACE index the normal sprite set; codes >= ICON_SPACE use
; the extended set. The sprite bytes are copied to the screen 24 lines
; (8x3) tall, two cells wide.
; In:  a = icon code.
show_icon_A:
		cp	$0C
		jr	nz,.render

		push	af
		xor	a
		ld	(GAME_VARIABLES + VAR_ICON_CODE),a
		ld	(GAME_PARAM_COPY+$10),a
		call	recalc_party_ac
		pop	af

.render:
		PUSH_REGS

		cp	ICON_SPACE
		jr	nc,extended_sprites

		ld	c,a
		add	a,a

		GET_A_FROM_TABLE	6

		ld	e,a
		exx
		inc	hl
		ld	a,(hl)
		exx
		ld	d,a
		ld	a,c

		jr	search_sprite

extended_sprites:
		sub	8
		add	a,a

		GET_A_FROM_TABLE	6

		ld	e,a
		exx
		inc	hl
		ld	a,(hl)
		exx
		ld	d,a
		ld	a,9

search_sprite:
		ld hl,ICONS-$30
		ld	bc,$30		; 48 bytes, 2x3 cells

loop_search_spr:
		add	hl,bc
		dec	a
		jr	nz,loop_search_spr

		ld	b,$18		; 8x3 = 24 lines to go

sprite_to_screen:
		ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de

		ld	a,(hl)
		ld	(de),a
		inc	hl
		dec	de

		inc	d
		ld	a,d
		and	7
		jr	nz,loop_scr_cell

		ld	a,e
		add	a,32
		ld	e,a
		jr	c,loop_scr_cell

		ld	a,d
		sub	8
		ld	d,a

loop_scr_cell:
		djnz	sprite_to_screen

		ret
