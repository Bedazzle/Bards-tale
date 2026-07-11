; --- LIGHT_DURAT ----------------------------------------------
; @done
; Base light duration (turns) per light source, 1 DB byte each, indexed
; in parallel with RANGE_VALUES / REVEAL_DURAT (MAFL,LERE,GRRE,CAEY,
; STLI,STSI,Torch,Lamp,...). light_the_light loads it into VAR_LIGHT and
; adds a rnd(0..15) roll; $FF => unlimited (infinite_light).
; Referenced by: ADDR_TABLE index $61 (INX_LIGHT_DURAT) - light_the_light
		debug "LIGHT_DURAT: "
LIGHT_DURAT:		;___table_25:
		DB 40		; MAFL
		DB 60		; LERE
		DB 80		; GRRE
		DB 255		; CAEY
		DB 30		; STLI
		DB 60		; STSI
		DB 28		; Torch
		DB 36		; Lamp
		DB 32 		; ?? - 20h
		DB 40 		; ?? - 28h
		DB 48 		; ?? - 30h
		DB 56 		; ?? - 38h
