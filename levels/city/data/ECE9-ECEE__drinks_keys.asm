; --- DRINKS_KEYS -----------------------------------------------
; @done
; Tavern drink hotkeys: 6 ASCII letters (A,B,M,F,G,W) for Ale, Beer, Mead,
; Foul spirits, Ginger Ale and Wine. order_drink matches the pressed key
; against this list (DRINKS_KEYS+4 down to base) to pick the drink.
; Referenced by: order_drink (ld hl,DRINKS_KEYS+4).
DRINKS_KEYS:
		DB 'A'		; 1 (A)le
		DB 'B'		; 2 (B)err
		DB 'M'		; 3 (M)rad
		DB 'F'		; 4 (F)oul spirits
		DB 'G'		; 5 (G)inger Ale
		DB 'W'		; 6 (W)ine
