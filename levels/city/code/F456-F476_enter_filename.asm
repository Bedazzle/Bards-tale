filename_long:
		PRINT_MESSAGE2	33h		; "That name is too long."

		PRINT_AND_WAIT

enter_filename:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	32h		; "Enter the name of the party."

		ld	b, 0Ah
		ld	hl, TEXT_BUFFER

clear_filename:
		ld	(hl), ' '
		inc	hl
		djnz	clear_filename

		call	enter_text

		ret	c

		CLEAR_INFO_PANEL

		ld	a, 8
		sub	b
		jr	c, filename_long

		and	a

		ret
