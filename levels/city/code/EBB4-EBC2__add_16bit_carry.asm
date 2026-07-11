; --- add_16bit_carry -------------------------------------------------
; @done
; Add b into two adjacent big-endian 16-bit fields, walking hl
; downward through memory: bump (hl) and carry into (hl-1), then
; bump (hl-2) and carry into (hl-3). Used to increment paired
; counters (e.g. condition / spell-point attribute words).
; In:  b = amount, hl -> low byte of the first 16-bit field
; Note: shared 16-bit-add helper; also called from
;       E950-EA54__do_advancement.asm.
add_16bit_carry:
		ld	a,b
		add	a,(hl)
		ld	(hl),a
		dec	hl
		jr	nc,.next_word

		inc	(hl)

.next_word:
		dec	hl
		ld	a,b
		add	a,(hl)
		ld	(hl),a
		dec	hl
		ret	nc

		inc	(hl)

		ret
