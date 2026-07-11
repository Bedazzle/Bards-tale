; --- oh_dear_game_over ----------------------------------------
; @done
; Party-wipe handler. Shows the zombie picture with the "Rot In
; Peace" title and the "Oh dear! Your gang hath ceased to be..."
; message plus the final stats, waits for a key, then respawns the
; party at the Guild: sets the Guild coordinates, faces west and
; clears teleport mode. If the party died underground it resumes the
; main loop (game_cycle); on the surface it reloads the Skara Brae
; map tape (insert_skara_tape).
; In:  iy = game variables
; Note: GUILD_COORDS is a placeholder (see TODO) — should come from
;       the current level's data.
oh_dear_game_over:
		ld	a,PIC_ZOMBIE
		ld	b,$93						; text: Rot In Peace

		SHOW_NAME_PIC_AB

		PRINT_MESSAGE	$40				; "Oh dear! Your gang hath ceased to be..."

		PRINT_STATS_TABLE

		WAIT_KEY_DOWN

		ld	hl,GUILD_COORDS			; TODO: load from level's data
		ld	(GAME_VARIABLES + VAR_COORD_SO_NO),hl
		ld	(iy+VAR_FACE_DIRECTION),FACE_WEST

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jp	z,game_cycle

		xor	a
		ld	(GAME_VARIABLES + VAR_TELEPORT_MODE),a
		ld	c,1
		ld	b,c

		jp	insert_skara_tape
