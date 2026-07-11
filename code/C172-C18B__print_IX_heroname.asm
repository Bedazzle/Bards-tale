; --- print_IX_heroname ------------------------------------
; @done
; Print the hero name pointed to by IX (field CHAR_NAME, $FF-terminated)
; to the info panel. Copies the name into the `sentence` buffer, tracking
; the word length in D (advanced up to each space), then renders it via
; print_from_buffer.
; In:  ix -> hero record (name field).
print_IX_heroname:
		PUSH_REGS

		ld	hl,sentence
		ld	b,1

next_letter:
		ld	a,(ix+CHAR_NAME)
		ld	(hl),a
		inc	hl
		inc	ix

		cp	$FF		; name terminator
		jr	z,print_from_buffer

		cp	' '
		jr	z,next_column

		ld	d,b

next_column:
		inc	b

		jr	next_letter
