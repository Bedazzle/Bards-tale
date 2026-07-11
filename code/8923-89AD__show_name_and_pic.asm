; --- show_name_and_pic --------------------------------------
; @done
; Proc-code 4 (two params): print a location name then draw its
; picture. Calls find_inn (consumes the first param, prints the
; matching location/inn name) then falls into show_pic_by_param to
; draw the picture whose id is the second param.
; In:  iy = game variables; two proc params follow the call
show_name_and_pic:
		call	find_inn

; --- show_pic_by_param --------------------------------------
; @done
; Proc-code 2 (one param): read the next proc parameter as a
; picture id, then fall into show_pic_by_A to draw it.
; In:  iy = game variables; one proc param follows the call
show_pic_by_param:
		call	get_param_to_A

; --- show_pic_by_A ------------------------------------------
; @done
; Proc-code 1 (no param): decompress and draw the picture whose id
; is in A onto the screen. Looks up the packed-data pointer from
; table $0F (b = 2*id), sets the default picture attribute via
; clear_city_color (when the display state changes), then runs an RLE
; decode loop: a leading key byte marks run tokens; each run byte
; is a length (+3) followed by a fill byte, other bytes are literal.
; Decoded (complemented) bytes are blitted column-by-column into the
; screen area starting at SCREEN+$21.
; In:  a = picture id, iy = game variables
; Note: raises VAR_PAUSE while drawing; self-modifies the run-key
;       compare at .escape_check+1 with the first packed byte.
show_pic_by_A:
		inc	(iy+VAR_PAUSE)		; pause ON
		push	af
		xor	a

		cp	(iy+VAR_DISPLAY_STATE)
		ld	(GAME_VARIABLES + VAR_DISPLAY_STATE),a
		call	nz,clear_city_color
		pop	af
		add	a,a
		ld	b,a

		GET_B_FROM_TABLE	$0F

		ld	e,a
		inc	b

		GET_B_FROM_TABLE	$0F

		ld	d,a
		ld	hl,SCREEN+$21		; 16417
		exx
		ld	de,$0400		; 1024
		ld	b,e
		ld	c,e
		exx
		call	fetch_pic_byte
		ld	(.escape_check+1),a	; SMC: run-key = first packed byte

.resume_decode:
		exx

.next_pixel:
		dec	e
		inc	e
		jr	z,.read_control		; run exhausted -> read next token

		dec	e			; consume one byte of the current run
		ld	a,h			; fill byte
		exx

		jr	.write_pixel
; -------------------------------------

.read_control:
		call	fetch_pic_byte_exx

.escape_check:
		cp	0				; !!! SMC (patched with run-key)
		jr	z,.decode_run

.write_pixel:
		cpl
		ld	(hl),a			; UNPACKED BYTE	TO SCREEN PICTURE
		call	simple_down_hl
		call	simple_down_hl
		exx
		inc	b
		inc	b
		dec	d
		jr	nz,.advance_column

		ld	d,4

.advance_column:
		ld	a,b
		sub	$56
		jr	c,.next_pixel

		ld	b,a
		inc	c
		ld	d,4
		exx
		ld	bc,$0E3F
		sbc	hl,bc
		exx
		ld	a,c
		sub	$0A
		jr	nz,.next_pixel

		ld	c,a
		inc	b
		ld	a,b
		exx
		ld	bc,$FFF6		; -10 (hl -= 10)
		add	hl,bc
		call	simple_down_hl

		cp	2
		jr	nz,.resume_decode

		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

.decode_run:
		call	fetch_pic_byte
		add	a,3			; run length = byte + 3
		exx
		ld	e,a			; e' = remaining run count
		call	fetch_pic_byte_exx
		exx
		ld	h,a			; h' = fill byte for the run

		jr	.next_pixel

; --- fetch_pic_byte_exx / fetch_pic_byte --------------------
; @done
; Read the next byte of packed picture data from DE and advance the
; pointer. fetch_pic_byte_exx first does EXX so it can be called
; from the alternate-register context and still reach the source
; pointer (kept in the main DE); fetch_pic_byte reads directly.
; In:  de = packed-data pointer (main register set)
; Out: a = byte read, de advanced by 1
; Note: fetch_pic_byte_exx leaves the register banks swapped (EXX).
fetch_pic_byte_exx:
		exx

fetch_pic_byte:
		ld	a,(de)
		inc	de

		ret
