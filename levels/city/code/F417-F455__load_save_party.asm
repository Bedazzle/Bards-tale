; --- load_party ----------------------------------------------
; @done
; Guild command: load a saved party from tape. Asks for the file
; name, prompts the user to insert the tape and press a key, then
; points the tape loader at PARTY_FILE ($0344 bytes) and jumps to
; loop_load_headr to pull the block in. Marks the dungeon level
; as $FF (none) so the loaded party starts back in the city.
; In:  iy = game vars
load_party:
		call	enter_filename

		jp	c,proc_guild

		PRINT_MESSAGE	$3A			; "Insert party tape."

		PRINT_MESSAGE	$33			; "Press Any Key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		ld	b,(iy+VAR_HERO_SLOT)
		ld	(iy+VAR_DUNGEON_LEVEL),$FF
		ld	hl,PARTY_FILE
		ld	(partyfile_addr),hl
		ld	hl,$0344
		ld	(partyfile_len),hl

		jp	loop_load_headr

; -------------------------------------

; --- save_party ----------------------------------------------
; @done
; Guild command: save the current party to tape. Asks for the
; file name, prompts the user to insert the tape and press
; RECORD-PLAY, then jumps to save_party_file to write the block.
; In:  iy = game vars
save_party:
		call	enter_filename

		jp	c,proc_guild

		ld	b,(iy+VAR_HERO_SLOT)

		PRINT_CRLF_AND_MESSAGE	$3A	; "Insert party tape."

		PRINT_CRLF_AND_MESSAGE	$3B	; "Press RECORD-PLAY."

		PRINT_MESSAGE	$33			; "Press Any Key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		jp	save_party_file
