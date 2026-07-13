

; --- (unlabeled length table @ $9C15) ------------------------
; @wip
; No label; sits at $9C15 immediately after items_lengths ($9B95-$9C14,
; 128 bytes) and just before INDEX_MONSTER_LENGTHS ($9C20). 11 bytes of
; small counts (4,6,6,5,4,6,$0A,8,4,4,$0B) in the same "length in 5-bit
; symbols" units as the neighbouring length tables - i.e. an 11-entry
; length index for some short 5-bit text pool, walked by the print-msg
; setup like its siblings. EXHAUSTIVELY searched: no code in the shared
; engine, level 1 or level 2 references $9C15 or an 11-entry loop over it,
; and it is not one of the four codec pools (messages/items/monsters/city).
; So it is either read only by an un-carved dungeon level (3-17) or is a
; small vestigial/padding length table. (Filename corrected 9C0D -> 9C15.)
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
