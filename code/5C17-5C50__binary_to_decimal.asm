; --- binary_to_decimal ---------------------------------------------
; @done
; Convert the 16-bit value in DE to decimal digits in the FB57
; buffer for print_number. For each of the 5 place values in the
; power-of-ten table (POW10_TABLE) it repeatedly subtracts, counting
; how many times, and stores that count (0-9) as the digit; the
; remainder carries down to the next place.
; In:  de = value
; Out: FB57.. = 5 decimal digit values (most significant first)
; Note: VAR_XP_THRESHOLD is reused as the per-digit counter; the
;       inc ix at bin2dec_store_digit is a self-modified step; pauses via
;       VAR_PAUSE.
binary_to_decimal:
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		NULLIFY_FB5B

		ld	ix,LEVEL_STOP+$6
		ld	b,5
		ld	hl,POW10_TABLE+9	; top word (10000) high byte; walk down

.next_digit:
		ld	(iy+VAR_XP_THRESHOLD),0
		push	bc

.subtract_loop:
		ld	b,(hl)
		dec	hl
		ld	c,(hl)
		inc	hl
		ex	de,hl
		push	hl
		and	a
		sbc	hl,bc
		ex	de,hl
		pop	bc
		jr	c,.digit_done

		inc	(iy+VAR_XP_THRESHOLD)

		jr	.subtract_loop

.digit_done:
		ld	d,b
		ld	e,c
		dec	hl
		dec	hl
		ld	a,(iy+VAR_XP_THRESHOLD)
		ld	(ix+CHAR_NAME),a

bin2dec_store_digit:
		inc	ix				; !!! SMC
		pop	bc
		djnz	binary_to_decimal.next_digit

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret
