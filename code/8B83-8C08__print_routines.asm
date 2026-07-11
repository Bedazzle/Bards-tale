; --- prnt_next_digit --------------------------------------
; @done
; Print (A+1) as a single decimal digit: bump A then fall into
; print_digit. Used to render a 1-based count.
; In:  a = value; prints a+1 as '0'..'9'.
prnt_next_digit:
		inc	a

; --- print_digit ------------------------------------------
; @done
; Print the value in A (0..9) as an ASCII digit character.
; In:  a = digit value.
print_digit:
		add	a,'0'    ; A=number to print

		jr	prnt_with_codes

; -------------------------------------

; --- print_2newlines --------------------------------------
; @done
; Emit two newlines to the text output (falls into print_newline
; to emit the second).
print_2newlines:
		PRINT_NEWLINE

; --- print_newline ----------------------------------------
; @done
; Emit one carriage-return / newline to the info-panel text output.
print_newline:
		ld	a,CODE_CR

		jr	prnt_with_codes
; -------------------------------------

; --- print_num_from_E -------------------------------------
; @done
; Print the unsigned 8-bit value in E as decimal (clears D, then
; falls into print_num_from_DE).
; In:  e = value.
print_num_from_E:
		ld	d,0

; --- print_num_from_DE ------------------------------------
; @done
; Print the unsigned 16-bit value in DE as decimal via print_number,
; then fall into print_space to emit a trailing space.
; In:  de = value.
print_num_from_DE:
		call	print_number

; --- print_space ------------------------------------------
; @done
; Emit a single space character to the text output.
print_space:
		ld	a,$20 ; ' '

; --- prnt_with_codes --------------------------------------
; @done
; Core character-output routine for the info panel: render the code in
; A. CR (CODE_CR) starts a new line; control codes >= CODE_C8 are
; ignored; a space at the start of a line is swallowed; '.'/',' are
; kept on the current line. Other characters are drawn via
; print_A_symbol, the cursor column advances, and when it reaches the
; right edge ($29) or bottom row (VAR_PORTRAIT_CTR) the panel scrolls up.
; In:  a = character/control code; iy = GAME_VARIABLES.
; Note: scrolls the 11-row info panel by block-copying screen rows.
prnt_with_codes:
		PUSH_REGS

		ld	hl,GAME_VARIABLES + VAR_CURSOR_COL

		cp	CODE_CR
		jr	z,print_crlf

		cp	CODE_C8
		ret	nc

		cp	' '
		jr	nz,regular_symbol

space:
		ld	e,a
		ld	a,(hl)
		cp	(iy+VAR_INFO_COL_POS)
		ld	a,e
		ret	z

regular_symbol:
		cp	','
		jr	z,dot_or_comma

		cp	'.'
		jr	nz,letter_symbol

dot_or_comma:
		ex	af,af'
		ld	a,(hl)

		cp	$15
		ret	z

		ex	af,af'

letter_symbol:
		push	hl
		call	print_A_symbol
		pop	hl
		inc	(hl)		; change cursor	position
		ld	a,(hl)

		cp	$29 ; ')'       ; 29h = 41 dec  ??? symbols in row ???
		ret	c

print_crlf:
		ld	a,(GAME_VARIABLES + VAR_INFO_COL_POS)
		ld	(hl),a
		dec	hl
		inc	(hl)
		ld	a,(hl)

		cp	(iy+VAR_PORTRAIT_CTR)
		ret	z
		ret	c

		dec	(hl)
		ld	hl,SCREEN+$8F
		ld	de,SCREEN+$6F
		ld	a,$0B

copy_11_rows:
		ex	af,af'
		ld	a,8

copy_8_lines:
		ld	bc,$11
		push	hl
		push	de
		ldir

		pop	de
		pop	hl
		inc	h
		inc	d
		dec	a
		jr	nz,copy_8_lines

		ld	a,l
		add	a,$20 ; ' '
		ld	l,a
		jr	c,after_decrease

		ld	a,h
		sub	8
		ld	h,a

after_decrease:
		ld	a,e
		add	a,$20 ; ' '
		ld	e,a
		jr	c,scroll_next_row

		ld	a,d
		sub	8
		ld	d,a

scroll_next_row:
		ex	af,af'
		dec	a
		jr	nz,copy_11_rows

		PRINT_SPACE_LINE

; --- set_pause_len ----------------------------------------
; @done
; Run a fixed-length pause (delay) by loading the counter c = $14 and
; jumping into dummy_pause. Used after a panel scroll so the reader can
; keep up.
set_pause_len:
		ld	c,$14

		jp	dummy_pause
