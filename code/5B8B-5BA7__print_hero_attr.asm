; --- print_hero_attr --------------------------------------
; @done
; Print a hero attribute as a number with its leading pad spaces
; shown. Fetches the 16-bit attribute selected by A, patches
; print_number's SMC slot so the pad characters are emitted (RST 10
; / $1E prnt_with_codes) instead of skipped, prints it, then
; restores the slot to NOP/NOP.
; In:  a = attribute id (GET_ATTR_BY_A selector), ix = hero block
; Note: pauses scrolling (VAR_PAUSE) around the print.
print_hero_attr:
		push	hl
		inc	(iy+VAR_PAUSE)		; pause ON

		GET_ATTR_BY_A

		ld	e,a
		dec	hl
		ld	d,(hl)
		ld	hl,$1ED7		; RST 10 / $1E (prnt_with_codes)
		ld	(SMC_print_with_codes),hl
		call	print_number
		ld	hl,0			; NOP / NOP
		ld	(SMC_print_with_codes),hl
		pop	hl
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
