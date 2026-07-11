; --- remove_char ---------------------------------------------
; @done
; Guild command: remove a character from the party. Prompts for
; a name, looks it up with find_hero_by_name, and if found drops
; the party count and marks the slot removed (via the shared
; free_hero_slot tail). Reports "no character of that name" otherwise.
; In:  iy = game vars
; Out: returns to proc_guild
remove_char:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$30			; "Enter the name of the character:"

		call	enter_text
		jr	c,abort_remove_char

		call	find_hero_by_name
		jr	c,found_hero

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$31			; "There's no character of that name in the party."

		PRINT_AND_WAIT

abort_remove_char:
		jp	proc_guild

found_hero:
		dec	(iy+VAR_PARTY_SIZE)

; --- free_hero_slot ------------------------------------------------
; @done
; Shared tail that frees a hero slot: sets the record's status to
; 3 (removed) and the negative flag, refreshes the on-screen
; stats table, and returns to the guild. Entered here by
; create_char to discard a just-rolled character when name entry
; is aborted (no party-count change), and fallen into from
; found_hero after the party count is decremented.
; In:  ix = hero record, iy = game vars
free_hero_slot:
		ld	(ix+CHAR_STATUS),3
		ld	(ix+CHAR_NEG_FLAG),1
		call	post_combat_cleanup

		PRINT_STATS_TABLE

		jp	proc_guild
