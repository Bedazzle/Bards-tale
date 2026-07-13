; --- run_cell_encounter ($D9AA-$D9B7) ----------------------------------
; @done
; Run a cell encounter (trigger_cell_encounter with a=b), storing the resulting
; column into iy+2 if combat occurred ($51 flag).

run_cell_encounter:
		push	af
		ld	a,b
		call	trigger_cell_encounter
		pop	bc
		GET_GAME_VARIABLE $51
		ret	z
		ld	(iy+2),b
		ret
