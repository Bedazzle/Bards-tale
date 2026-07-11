; --- REVEAL_DURAT ---------------------------------------------
; @done
; Base secret-reveal duration (turns) per light source, 1 DB byte each,
; indexed in parallel with RANGE_VALUES / LIGHT_DURAT. light_the_light
; loads it into VAR_REVEAL_SECRET; 0 => no reveal (no_reveal_secrets),
; otherwise adds rnd(0..15)+1, $FF => unlimited (infinite_reveal).
; Referenced by: ADDR_TABLE index $60 (INX_REVEAL_DURAT) - light_the_light
		debug "REVEAL_DURAT: "
REVEAL_DURAT:		;___table_26:
		DB 0		; MAFL - none
		DB 60		; LERE
		DB 80		; GRRE
		DB 0		; CAEY - none
		DB 0		; STLI - none
		DB 60		; STSI
		DB 0		; Torch - none
		DB 0		; Lamp - none
		DB 0		; ??
		DB 16 		; ?? - 10h
		DB 24 		; ?? - 18h
		DB 32 		; ?? - 20h
