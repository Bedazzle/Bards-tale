; --- jmp_to_movement ---------------------------------------
; @done
; Dispatch stub at the level's fixed $C18C entry. The shared engine
; calls here to run the City's walk-around loop; it forwards to this
; level's movement/redraw handler.
jmp_to_movement:
		jp	movement

; --- dispatch_movement -------------------------------------------
; @done
; Movement/event-step hook, reached via the DISPATCH_MOVEMENT vector
; (RST 10h, table index $4B / procs_buffer). Runs one step of the
; City street handler by forwarding to proc_sinistr_strt.
dispatch_movement:					; DISPATCH_MOVEMENT
		jp	proc_sinistr_strt

; --- hook_street_step ----------------------------------------------
; @done
; Second fixed entry ($C192) into the City street-step handler, called
; directly (game_cycle, teleport) rather than through the RST dispatch.
; Forwards to proc_sinistr_strt.
hook_street_step:
		jp	proc_sinistr_strt

; --- hook_gamecycle ----------------------------------------------
; @done
; Per-level event hook at $C195 (called from game_cycle). The City has
; no handler here, so it forwards to invalid_spell.
; Out: carry set (handler not present in the City)
hook_gamecycle:
		jp	invalid_spell

; --- hook_postcombat ----------------------------------------------
; @done
; Per-level event hook at $C198 (called from enemies_killed). Unused in
; the City, so it forwards to invalid_spell.
; Out: carry set (handler not present in the City)
hook_postcombat:
		jp	invalid_spell

; --- hook_dungeon_step ----------------------------------------------
; @done
; Per-level event hook at $C19B (called from process_dungeon_step).
; Unused in the City, so it forwards to invalid_spell.
; Out: carry set (handler not present in the City)
hook_dungeon_step:
		jp	invalid_spell
