

; --- (unlabeled length table @ $9C15) ------------------------
; @wip
; No label; sits at $9C15 immediately after items_lengths ($9B95-$9C14,
; 128 bytes) and just before INDEX_MONSTER_LENGTHS ($9C20). 11 bytes of
; small counts (4,6,6,5,4,6,$0A,8,4,4,$0B) in the same "length in 5-bit
; symbols" units as the neighbouring length tables - i.e. an 11-entry
; length index for some short 5-bit text pool, walked by the print-msg
; setup like its siblings. Not reached via ADDR_TABLE (no label).
; Note: which 11-entry text pool it lengths is not yet identified.
;       (Filename corrected from 9C0D to the true 9C15 range.)
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
