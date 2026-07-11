; --- process_dungeon_step ------------------------------------
; @done
; Per-turn tick handler (dispatched from PROCS_2). When the party is
; underground it bumps the VAR_DUNGEON_STEPS counter and runs the
; dungeon-step hook (traps / wandering encounters / regen), then
; prints an ellipsis as turn feedback. On the surface it just prints
; the ellipsis.
; In:  iy = game variables base
process_dungeon_step:
		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	z,.done

		inc	(iy+VAR_DUNGEON_STEPS)
		call	hook_dungeon_step

.done:
		jp	print_ellipsis
