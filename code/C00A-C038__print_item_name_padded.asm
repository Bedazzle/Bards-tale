; --- print_item_name_padded -------------------------------
; @done
; Print an item's name into the info panel in a fixed-width field. Fills
; an 11-byte scratch buffer (SPELL_LIGHT_STATE+$4) with spaces, decodes the item
; name (id in A) into it via set_item_tables, then prints 9 columns so short
; names are space-padded to align.
; In:  a = item id.
; Note: pauses scrolling (VAR_PAUSE) while printing.
print_item_name_padded:
		PUSH_REGS

		inc	(iy+VAR_PAUSE)		; pause ON
		dec	a
		ex	af,af'
		ld	a,1
		ex	af,af'
		push	ix
		push	af
		ld	hl,SPELL_LIGHT_STATE+$4
		ld	b,$0B
		ld	a,$20 ; ' '

.fill_spaces:
		ld	(hl),a
		dec	hl
		djnz	.fill_spaces

		push	hl
		pop	ix
		pop	af
		push	hl
		call	set_item_tables
		pop	hl
		ld	b,9

.print_loop:
		ld	a,(hl)

		PRINT_WITH_CODES

		inc	hl

		djnz	.print_loop

		pop	ix
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
