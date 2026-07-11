filename_long:
		PRINT_MESSAGE2	$33		; "That name is too long."

		PRINT_AND_WAIT

; --- enter_filename ------------------------------------------
; @done
; Prompt for a party-file name and read it into TEXT_BUFFER for
; the tape save/load. Pre-fills the 10-byte buffer with spaces,
; reads the text, and enforces a max length of 8 characters,
; re-prompting via filename_long if the entry is too long.
; Out: carry set if the user aborted; carry clear on a valid
;      name left in TEXT_BUFFER
enter_filename:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$32		; "Enter the name of the party."

		ld	b,$0A
		ld	hl,TEXT_BUFFER

clear_filename:
		ld	(hl),' '
		inc	hl
		djnz	clear_filename

		call	enter_text

		ret	c

		CLEAR_INFO_PANEL

		ld	a,8
		sub	b
		jr	c,filename_long

		and	a

		ret
