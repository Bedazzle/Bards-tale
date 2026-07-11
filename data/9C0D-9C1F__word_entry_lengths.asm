

; --- (unlabeled byte table @ $9C0D) --------------------------
; @wip
; No label (included inline between items_lengths and the words
; block). 11 bytes of small counts (4,6,6,5,4,6,$0A,8,4,4,$0B) —
; looks like a per-entry length/count list for the adjacent word or
; item data. Not reached via ADDR_TABLE (no label).
; Note: format not yet reverse-engineered.
		DB 4
		DB 6
		DB 6
		DB 5
		DB 4
		DB 6
		DB $0A
		DB 8
		DB 4
		DB 4
		DB $0B
