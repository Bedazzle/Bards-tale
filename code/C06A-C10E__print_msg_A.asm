; --- print_msg_A ------------------------------------------
; @done
; Entry to the packed-text message decoder that first compares A with
; the table base byte, then falls into print_msg_no_cp.
; In:  a = message id, hl = messages_table, de = words_table.
; Note: purpose partially inferred.
print_msg_A:
		cp	(hl)

; --- print_msg_no_cp --------------------------------------
; @done
; Decode and print one packed-text message. The messages are stored as
; a bit-packed stream: this skips to the requested message (summing the
; bit-lengths of earlier messages to a byte offset), then reads the
; stream a few bits at a time, expanding word-codes (via words_table)
; and letter-codes (via lower_letters) into the `sentence` buffer and
; flushing each completed word to the output (print_sentence_buffer / print_from_buffer).
; In:  a = message id, hl = messages_table, de = words_table.
; Note: purpose partially inferred; AF' carries the capitalise flag.
print_msg_no_cp:
		exx
		push	af
		ld	a,1
		ld	c,a
		adc	a,a
		ld	b,a
		dec	b
		pop	af
		ld	(GAME_VARIABLES + VAR_PRINT_POS),ix
		ld	de,$0101
		exx
		and	a
		jr	z,.read_message

		ld	b,0
		ld	c,a
		add	hl,bc
		push	hl

.skip_msg_loop:
		push	hl
		push	af
		ld	a,5
		ld	c,(hl)
		ld	hl,0

.mul5_loop:
		add	hl,bc
		dec	a
		jr	nz,.mul5_loop

		ld	b,3

.div8_loop:
		srl	h
		rr	l
		adc	a,a
		djnz	.div8_loop

		and	a
		jr	z,.add_offset

		inc	hl

.add_offset:
		add	hl,de
		ex	de,hl
		pop	af
		pop	hl
		dec	hl
		dec	a
		jr	nz,.skip_msg_loop

		pop	hl

.read_message:
		ld	c,a
		inc	hl
		push	de
		ld	e,(hl)
		inc	e
		ld	d,a

.next_word:
		exx
		ld	hl,sentence

print_msg_loop:
		exx

.next_letter:
		dec	e
		jp	z,print_msg_A_part_2

		ex	(sp),hl
		ld	b,(hl)
		inc	hl
		ld	a,(hl)
		dec	hl
		ex	(sp),hl
		ld	l,a
		ld	h,b
		dec	c
		inc	c
		jr	z,.take_bits

		ld	b,c

.align_bits:
		add	hl,hl
		djnz	.align_bits

.take_bits:
		srl	h
		srl	h
		srl	h
		ld	a,c
		add	a,5
		ld	c,a
		sub	8
		jr	c,.classify_code

		ld	c,a
		ex	(sp),hl
		inc	hl
		ex	(sp),hl

.classify_code:
		ld	a,h
		sub	$1D
		exx
		jr	c,.decode_letter

		ld	c,b
		inc	a
		ld	b,a

		jr	print_msg_loop
; -------------------------------------

.decode_letter:
		push	hl
		push	bc

.restore_index:
		add	a,$1D
		djnz	.restore_index
		ld	c,a
		ld	hl,lower_letters
		add	hl,bc
		pop	bc
		ld	a,b

		cp	2
		jr	nz,.emit_char

		ld	b,c

.emit_char:
		ld	a,(hl)
		pop	hl

		cp	'\\'
		jr	z,msg_end_of_line

		dec	d
		inc	d
		jr	z,print_msg_loop

		ld	(hl),a		; put unpacked letter to buffer
		inc	hl
		exx
		inc	d

		cp	' '
		jr	z,end_of_word

		cp	CODE_CR
		jr	nz,.next_letter

end_of_word:
		call	print_sentence_buffer

		jr	print_msg_no_cp.next_word
