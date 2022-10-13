; -------------------------------------
partyfile_addr:	dw 0
partyfile_len:	dw 0
; -------------------------------------

loop_load_headr:
		CLEAR_INFO_PANEL

		di
		ld	ix, FILEHEADER_BUFF
		ld	de, 9
		xor	a
		cp	e
		ex	af, af'
		call	ROM_BYTES_LOAD
		jr	nc, loop_load_headr

		ld	hl, TEXT_BUFFER
		ld	de, sentence
		ld	b, 8

match_filename:
		ld	a, (de)

		cp	(hl)
		jr	nz, loc_633D

		inc	hl
		inc	de
		djnz	match_filename

		ld	ix, (partyfile_addr)
		ld	de, (partyfile_len)
		ld	a, 0FFh
		or	a
		scf
		ex	af, af'
		call	ROM_BYTES_LOAD
		jr	nc, tape_error

		ei

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z, run_after_load

		ld	a, (CITY_MAP_DATA+269h)
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART), a

		jr	run_after_load
; -------------------------------------

loc_633D:
		ei
		ld	a, (GAME_VARIABLES + VAR_07)

		cp	0FFh
		jr	nz, rewind_or_forward

		ld	a, (FILEHEADER_BUFF)

		cp	0FFh
		jr	nz, insert_party_tape

		ld	d, 8
		call	print_from_buffer

		PRINT_CRLF_AND_MESSAGE	48h			; "[ext] to abort"

		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	nz, loop_load_headr

run_after_load:
		jp	set_vars_and_IM
; -------------------------------------

insert_party_tape:
		PRINT_MESSAGE	3Ah			; "Insert party tape."

		jr	wait_for_header
; -------------------------------------

rewind_or_forward:
		ld	b, a
		ld	a, (FILEHEADER_BUFF)

		cp	b
		jr	nc, rewind_tape

		PRINT_MESSAGE	3Ch			; "Fast forward tape."

wait_for_header:
		PRINT_AND_WAIT

		jr	loop_load_headr

rewind_tape:
		PRINT_MESSAGE	39h			; "Rewind tape."

		jr	wait_for_header
; -------------------------------------

tape_error:
		ld	a, (GAME_VARIABLES + VAR_07)

		cp	0FFh
		jr	z, loop_heroes

		PRINT_MESSAGE	3Dh			; "TAPE ERROR!"

		PRINT_NEWLINE

		jr	rewind_tape
; -------------------------------------

loop_heroes:
		ld	b, 6

loop_next_hero:
		FIND_HERO_BY_B

		CLEAN_HERO_MEMORY

		dec	b
		jp	p, loop_next_hero

		PRINT_MESSAGE	3Dh			; "TAPE ERROR!"

		PRINT_AND_WAIT

		jr	run_after_load
; -------------------------------------

save_party_file:
		ld	de, 9
		ld	a, 0FFh
		ld	(PARTY_HEADER),	a
		ld	ix, PARTY_HEADER
		xor	a
		call	ROM_BYTES_SAVE
		xor	a
		out	(0FEh),	a
		ld	c, 0FFh
		call	dummy_pause
		ld	de, 344h
		ld	ix, PARTY_FILE
		ld	a, 0FFh
		call	ROM_BYTES_SAVE
		xor	a
		out	(0FEh),	a
		ei

		jp	set_vars_and_IM
; -------------------------------------

insert_skara_tape:
		push	bc

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	3Eh			; "Insert Skara-Dungeon	tape"

		ld	a, c
		cp	8
		jr	nc, tape2

tape_1:
		PRINT_MESSAGE	41h			; "1, side B"

		jr	press_play_hitkey
; -------------------------------------

tape2:
		push	af

		PRINT_MESSAGE	42h			; "2, side"

		pop	af
		cp	0Eh						; 14
		jr	nc, side_b

side_a:
		ld	a, 'A'
		jr	print_tape_side

side_b:
		ld	a, 'B'

print_tape_side:
		PRINT_WITH_CODES

press_play_hitkey:
		PRINT_MESSAGE	3Fh			; "Press play then hit a	key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		xor	a
		call	prep_black_color
		inc	(iy+VAR_06)

		CLEAR_TXT_BUFFER

		PRINT_LOCATION_NAME

		pop	bc
		ld	a, c
		sub	3
		jr	nc, loc_63F9

		xor	a

loc_63F9:
		inc	a
		ld	(iy+VAR_07), a
		ld	a, c
		add	a, a
		ld	(loc_6437+1), a
		add	a, a
		cp	10h
		jr	c, loc_6409

		ld	a, 10h

loc_6409:
		ld	e, a
		ld	d, 0
		ld	hl, addr_6460
		add	hl, de
		inc	b
		jr	z, loc_6423

		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_COORD_WE_EA), a
		inc	hl
		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO), a
		inc	hl
		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_FACE_DIRECTION), a

		jr	loc_6425
; -------------------------------------

loc_6423:
		inc	hl
		inc	hl

loc_6425:
		inc	hl
		ld	a, (hl)
		ld	(GAME_VARIABLES + VAR_UNDERGROUND), a
		ld	a, (GAME_VARIABLES + VAR_DAY_PART)
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART), a
		xor	a
		ld	(GAME_VARIABLES + VAR_3E), a
		ld	(GAME_VARIABLES + VAR_3D), a

loc_6437:
		ld	de, 0					; !!! SMC
		ld	hl, addr_6474
		add	hl, de
		ld	a, (hl)
		ld	(TEXT_BUFFER), a
		inc	hl
		ld	a, (hl)
		ld	(TEXT_BUFFER+1), a
		ld	hl, addr_FB64
		ld	b, 8

loc_644C:
		ld	(hl), 20h ; ' '
		inc	hl
		djnz	loc_644C

		ld	hl, jmp_to_movement
		ld	(partyfile_addr), hl
		ld	hl, 39C5h
		ld	(partyfile_len), hl

		jp	loop_load_headr
