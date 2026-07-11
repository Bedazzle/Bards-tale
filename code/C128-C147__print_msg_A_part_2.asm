; --- print_msg_A_part_2 -----------------------------------
; @done
; Finalize path of the packed-text decoder, reached when a message's
; word count reaches zero. Restores the saved AF; if no characters are
; pending in the buffer (d = 0) it returns, otherwise it falls into
; print_sentence_buffer to flush the last word.
; In:  d = pending buffer length, af on stack.
print_msg_A_part_2:
		pop	af
		dec	d
		inc	d

		jr	z,print_sentence_buffer.done

; --- print_sentence_buffer ---------------------------------------------
; @done
; Flush the `sentence` buffer. With the AF' flag set (store mode) it
; copies d bytes to the growing output at VAR_PRINT_POS; with the flag
; clear it renders them to the info panel via print_from_buffer.
; In:  d = byte count; AF' flag selects store vs. print.
; Out: carry cleared.
print_sentence_buffer:
		ld	hl,sentence
		ex	af,af'
		or	a
		jr	z,print_from_buffer

		ex	af,af'
		push	bc
		ld	bc,(GAME_VARIABLES + VAR_PRINT_POS)

.copy_loop:
		ld	a,(hl)
		ld	(bc),a
		inc	hl
		inc	bc
		dec	d
		jr	nz,.copy_loop

		ld	(GAME_VARIABLES + VAR_PRINT_POS),bc
		pop	bc

.done:
		and	a

		ret
