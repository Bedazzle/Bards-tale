; --- new_order -----------------------------------------------
; @done
; The (N)ew Order action: re-sort the party marching order. Prints
; "New Order:", numbers the party slots, then for each position waits
; for a hero-select key, swaps the chosen hero into that slot and
; reprints the party stats. Pauses game updates while active.
; In:  iy = game variables base
; Note: no-ops when the party is empty. Dispatch handler $4E.
new_order:
		inc	(iy+VAR_PAUSE)		; pause ON

		GET_GAME_VARIABLE	VAR_PARTY_SIZE		; ???

		jr	c,new_order_done
		jr	z,new_order_done

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$12			; "New Order:"

		ld	hl,TEXT_BUFFER+5
		ld	b,6
		ld	a,$36 ; '6'

fill_party_header:
		ld	(hl),a
		dec	a
		dec	hl
		djnz	fill_party_header

		ld	c,b

new_order_prompt:
		ld	a,c

		PRINT_NEXT_DIGIT

		ld	a,'>'

		PRINT_WITH_CODES

loop_new_order:
		WAIT_KEY_DOWN

		ld	b,5
		ld	e,a

.scan_keys:
		GET_B_FROM_TABLE	$34

		cp	e
		jr	z,.matched

		dec	b
		jp	p,.scan_keys

		jr	loop_new_order
; -------------------------------------

.matched:
		inc	b

		FIND_HERO_BY_B

		jr	z,loop_new_order

		GET_C_FROM_TABLE	$34

		dec	b

		GET_B_FROM_LIST	$34

		xor	a

		GET_C_FROM_LIST	$34

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		push	ix
		pop	de
		ld	b,c
		inc	b

		FIND_HERO_BY_B

		push	ix
		pop	hl
		ld	a,$64
		call	swap_byte_buffer
		ld	a,(GAME_VARIABLES)
		inc	c

		cp	c
		jr	z,.show_stats
		jr	nc,new_order_prompt

.show_stats:
		PRINT_STATS_TABLE

new_order_done:
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
