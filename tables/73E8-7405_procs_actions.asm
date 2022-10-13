ACTIONS_KEYS:
		db  54h	; T	= trade_gold
		db  45h	; E = equip_item
		db  44h	; D = drop_item
		db  50h	; P = shoppe_pool_gold
		db  4Eh	; N = new_order
		db  50h	; P
		db  43h	; C = cast_spell
		db  42h	; B = play_song
		db  56h	; V
		db  55h	; U = use_item

ACTIONS_PROCS:
		dw trade_gold
		dw equip_item
		dw drop_item
		dw shoppe_pool_gold
		dw new_order
		dw combat_party		; part of combat foes
		dw cast_spell
		dw play_song
		dw loc_890D
		dw use_item
