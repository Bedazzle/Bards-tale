; -------------------------------------
; --- partyfile_addr / partyfile_len -----------------------
; Destination address and length for the next tape block loaded by
; loop_load_headr (set by the caller before jumping in).
partyfile_addr:	DW 0
partyfile_len:	DW 0
; -------------------------------------

; --- loop_load_headr --------------------------------------
; @done
; Load a tape block whose 8-byte name matches `sentence`. Repeatedly
; reads file headers; on a name match it loads the data to
; (partyfile_addr) for (partyfile_len) bytes and resumes via
; set_vars_and_IM, otherwise it prompts the player to insert /
; rewind / fast-forward the correct tape (per VAR_DUNGEON_LEVEL) and
; retries. Tape errors fall through to the recovery paths
; (tape_error / loop_heroes).
; In:  sentence = 8-char target name; partyfile_addr/len set by caller
; Note: runs with interrupts disabled during the ROM loads.
loop_load_headr:
		CLEAR_INFO_PANEL

		di
		ld	ix,FILEHEADER_BUFF
		ld	de,9
		xor	a
		cp	e
		ex	af,af'
		call	ROM_BYTES_LOAD
		jr	nc,loop_load_headr

		ld	hl,TEXT_BUFFER
		ld	de,sentence
		ld	b,8

match_filename:
		ld	a,(de)

		cp	(hl)
		jr	nz,name_mismatch

		inc	hl
		inc	de
		djnz	match_filename

		ld	ix,(partyfile_addr)
		ld	de,(partyfile_len)
		ld	a,$FF
		or	a
		scf
		ex	af,af'
		call	ROM_BYTES_LOAD
		jr	nc,tape_error

		ei

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z,run_after_load

		ld	a,(CITY_MAP_DATA+$0269)
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART),a

		jr	run_after_load
; -------------------------------------

name_mismatch:
		ei
		ld	a,(GAME_VARIABLES + VAR_DUNGEON_LEVEL)

		cp	$FF
		jr	nz,rewind_or_forward

		ld	a,(FILEHEADER_BUFF)

		cp	$FF
		jr	nz,insert_party_tape

		ld	d,8
		call	print_from_buffer

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort"

		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	nz,loop_load_headr

run_after_load:
		jp	set_vars_and_IM
; -------------------------------------

insert_party_tape:
		PRINT_MESSAGE	$3A			; "Insert party tape."

		jr	wait_for_header
; -------------------------------------

rewind_or_forward:
		ld	b,a
		ld	a,(FILEHEADER_BUFF)

		cp	b
		jr	nc,rewind_tape

		PRINT_MESSAGE	$3C			; "Fast forward tape."

wait_for_header:
		PRINT_AND_WAIT

		jr	loop_load_headr

rewind_tape:
		PRINT_MESSAGE	$39			; "Rewind tape."

		jr	wait_for_header
; -------------------------------------

tape_error:
		ld	a,(GAME_VARIABLES + VAR_DUNGEON_LEVEL)

		cp	$FF
		jr	z,loop_heroes

		PRINT_MESSAGE	$3D			; "TAPE ERROR!"

		PRINT_NEWLINE

		jr	rewind_tape
; -------------------------------------

loop_heroes:
		ld	b,6

loop_next_hero:
		FIND_HERO_BY_B

		CLEAN_HERO_MEMORY

		dec	b
		jp	p,loop_next_hero

		PRINT_MESSAGE	$3D			; "TAPE ERROR!"

		PRINT_AND_WAIT

		jr	run_after_load
; -------------------------------------

; --- save_party_file --------------------------------------
; @done
; Save the party to tape: write the 9-byte header (PARTY_HEADER)
; then the party block (PARTY_FILE, $0344 bytes) via the ROM save
; routine, with a short pause between, then resume through
; set_vars_and_IM.
save_party_file:
		ld	de,9
		ld	a,$FF
		ld	(PARTY_HEADER),a
		ld	ix,PARTY_HEADER
		xor	a
		call	ROM_BYTES_SAVE
		xor	a
		out	($FE),a
		ld	c,$FF
		call	dummy_pause
		ld	de,$0344
		ld	ix,PARTY_FILE
		ld	a,$FF
		call	ROM_BYTES_SAVE
		xor	a
		out	($FE),a
		ei

		jp	set_vars_and_IM
; -------------------------------------

; --- insert_skara_tape ------------------------------------
; @done
; Prompt for and load a Skara Brae dungeon tape, then set up entry
; into that level. Chooses the "1 side B" / "2 side A|B" prompt from
; the tape id in C, waits for the player, records the new dungeon
; level and the starting map coordinates / facing (from the tables
; at FIXED_LOCATIONS / LOCATION_TILE_COL), then hands off to loop_load_headr to
; pull the level block in.
; In:  c = tape / level id, b = coordinate-set selector
; Note: set_level_name's ld de operand is self-modified from the id.
insert_skara_tape:
		push	bc

		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$3E			; "Insert Skara-Dungeon	tape"

		ld	a,c
		cp	8
		jr	nc,tape2

tape_1:
		PRINT_MESSAGE	$41			; "1, side B"

		jr	press_play_hitkey
; -------------------------------------

tape2:
		push	af

		PRINT_MESSAGE	$42			; "2, side"

		pop	af
		cp	$0E						; 14
		jr	nc,side_b

side_a:
		ld	a,'A'
		jr	print_tape_side

side_b:
		ld	a,'B'

print_tape_side:
		PRINT_WITH_CODES

press_play_hitkey:
		PRINT_MESSAGE	$3F			; "Press play then hit a	key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		xor	a
		call	prep_black_color
		inc	(iy+VAR_DISPLAY_STATE)

		CLEAR_TXT_BUFFER

		PRINT_LOCATION_NAME

		pop	bc
		ld	a,c
		sub	3
		jr	nc,level_id_ok

		xor	a

level_id_ok:
		inc	a
		ld	(iy+VAR_DUNGEON_LEVEL),a
		ld	a,c
		add	a,a
		ld	(set_level_name+1),a
		add	a,a
		cp	$10
		jr	c,coord_index_ok

		ld	a,$10

coord_index_ok:
		ld	e,a
		ld	d,0
		ld	hl,FIXED_LOCATIONS
		add	hl,de
		inc	b
		jr	z,skip_coords

		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_COORD_WE_EA),a
		inc	hl
		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO),a
		inc	hl
		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_FACE_DIRECTION),a

		jr	after_coords
; -------------------------------------

skip_coords:
		inc	hl
		inc	hl

after_coords:
		inc	hl
		ld	a,(hl)
		ld	(GAME_VARIABLES + VAR_UNDERGROUND),a
		ld	a,(GAME_VARIABLES + VAR_DAY_PART)
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART),a
		xor	a
		ld	(GAME_VARIABLES + VAR_SAVE_STATE_HI),a
		ld	(GAME_VARIABLES + VAR_SAVE_STATE_LO),a

set_level_name:
		ld	de,0					; !!! SMC
		ld	hl,LOCATION_TILE_COL
		add	hl,de
		ld	a,(hl)
		ld	(TEXT_BUFFER),a
		inc	hl
		ld	a,(hl)
		ld	(TEXT_BUFFER+1),a
		ld	hl,byte_FB63+$1
		ld	b,8

clear_name_buf:
		ld	(hl),$20 ; ' '
		inc	hl
		djnz	clear_name_buf

		ld	hl,jmp_to_movement
		ld	(partyfile_addr),hl
		ld	hl,$39C5
		ld	(partyfile_len),hl

		jp	loop_load_headr
