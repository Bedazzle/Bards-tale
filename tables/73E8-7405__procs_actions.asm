; --- ACTIONS_KEYS ---------------------------------------------
; @done
; Parallel arrays for the party command bar. ACTIONS_KEYS is 10 x DB
; command-key ASCII codes; ACTIONS_PROCS is the matching 10 x DW
; handler-address table (same order). process_action_key scans
; ACTIONS_KEYS for the typed key (GET_C_FROM_TABLE INX_ACTIONS_KEYS),
; then fetches the handler word from ACTIONS_PROCS at the same index
; and patches it into a self-modified call.
; Referenced by: ADDR_TABLE index $32 (INX_ACTIONS_KEYS) - process_action_key
ACTIONS_KEYS:
		DB $54	; T	= trade_gold
		DB $45	; E = equip_item
		DB $44	; D = drop_item
		DB $50	; P = shoppe_pool_gold
		DB $4E	; N = new_order
		DB $50	; P
		DB $43	; C = cast_spell
		DB $42	; B = play_song
		DB $56	; V
		DB $55	; U = use_item

; --- ACTIONS_PROCS --------------------------------------------
; @done
; DW dispatch table (10 entries) of command handler routines, one per
; ACTIONS_KEYS key in the same order. process_action_key reads a word
; here (low byte then high byte, GET_C_FROM_TABLE INX_ACTIONS_PROCS)
; and calls it through a patched call operand.
; Referenced by: ADDR_TABLE index $31 (INX_ACTIONS_PROCS) - process_action_key
ACTIONS_PROCS:
		DW trade_gold
		DW equip_item
		DW drop_item
		DW shoppe_pool_gold
		DW new_order
		DW combat_party		; part of combat foes
		DW cast_spell
		DW play_song
		DW toggle_speed_flag
		DW use_item
