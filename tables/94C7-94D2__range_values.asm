; --- RANGE_VALUES ---------------------------------------------
; @done
; Light-source visible distance (VAR_LIGHT_DIST), 1 DB byte per source,
; indexed in parallel with LIGHT_DURAT / REVEAL_DURAT: light spells
; MAFL,LERE,GRRE,CAEY,STLI,STSI then Torch,Lamp and 4 further sources.
; Direct byte lookup by light-source index.
; Referenced by: ADDR_TABLE index $5F (INX_RANGE_VALUES) - light_the_light
RANGE_VALUES:		;___table_24:
		DB 3		; MAFL
		DB 4		; LERE
		DB 5		; GRRE
		DB 5		; CAEY
		DB 3		; STLI
		DB 5		; STSI
		DB 2		; Torch
		DB 2		; Lamp
		DB 2
		DB 3
		DB 4
		DB 5
