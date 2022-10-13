load_party:
		call	enter_filename

		jp	c, proc_guild

		PRINT_MESSAGE	3Ah			; "Insert party tape."

		PRINT_MESSAGE	33h			; "Press Any Key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		ld	b, (iy+VAR_14)
		ld	(iy+VAR_07),	0FFh
		ld	hl, PARTY_FILE
		ld	(partyfile_addr), hl
		ld	hl, 344h
		ld	(partyfile_len), hl

		jp	loop_load_headr

; -------------------------------------

save_party:
		call	enter_filename

		jp	c, proc_guild

		ld	b, (iy+VAR_14)

		PRINT_CRLF_AND_MESSAGE	3Ah	; "Insert party tape."

		PRINT_CRLF_AND_MESSAGE	3Bh	; "Press RECORD-PLAY."

		PRINT_MESSAGE	33h			; "Press Any Key..."

		WAIT_KEY_DOWN

		CLEAR_INFO_PANEL

		jp	save_party_file
