; --- find_inn -----------------------------------------------
; @done
; Look up the inn record whose coordinates match the party's
; current map position and print its name into the info panel.
; The caller's parameter byte selects the message-flag base
; (added to $34 and patched into the default_inn fallback record),
; then inns_data is scanned for a SO/NO + WE/EA coordinate match;
; the matched record's id byte is printed as the location name.
; In:  iy = game vars (VAR_COORD_SO_NO / VAR_COORD_WE_EA), param byte follows the call
; Out: inn name printed; falls through to print_loc_name
; Note: default_inn+2 is self-modified so an unmatched search still prints something.
find_inn:
		call	get_param_to_A
		add	a,$34
		ld	(default_inn + 2),a
		ld	hl,inns_data

check_inn_id:
		ld	a,(hl)

		cp	(iy+VAR_COORD_SO_NO)
		inc	hl
		ld	a,(hl)
		inc	hl
		inc	hl
		jr	nz,check_last_inn

		cp	(iy+VAR_COORD_WE_EA)
		jr	z,found_inn

check_last_inn:
		cp	$FF
		jr	nz,check_inn_id

found_inn:
		dec	hl
		ld	a,(hl)

		CLEAR_TXT_BUFFER

		PRINT2_A_WITH_FLAG_1

		jp	print_loc_name
