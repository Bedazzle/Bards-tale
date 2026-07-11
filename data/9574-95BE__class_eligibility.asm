; --- CLASS_ELIGIBILITY ----------------------------------------
; @done
; Per-race class-availability: for each race, 10 entries (classes 0-9,
; Warrior..Monk); a ZERO entry means that class is not offered to the
; race. list_classes lists only eligible classes; calculate_class
; rejects an ineligible pick (jr z). Indexed 10*(race-1)+class.
; RLE-compressed ($FC,count,value) since index $6F >= $67, decoded by
; lookup_addr_table.
; Referenced by: list_classes, calculate_class (ADDR_TABLE index $6F)
		debug "CLASS_ELIGIBILITY: "
CLASS_ELIGIBILITY:
		DB 1
		DB 0
		DB 0
		DB $FC
		DB 8
		DB 1
		DB 0
		DB 0
		DB $FC
		DB 5
		DB 1
		DB 0
		DB 1
		DB 1
		DB $FC
		DB 4
		DB 0
		DB $FC
		DB 6
		DB 1
		DB 0
		DB 0
		DB $FC
		DB 4
		DB 1
		DB 0
		DB 0
		DB 1
		DB 1
		DB 0
		DB 0
		DB $FC
		DB 4
		DB 1
		DB 0
		DB 0
		DB 1
		DB 1
		DB 0
		DB 0
		DB 1
		DB 1
		DB 1
		DB 0
		DB 0
		DB 1
		DB 0
		DB 1
		DB 0
		DB 0
		DB 1
		DB 1
		DB 1
		DB 0
		DB 0
		DB 1
		DB 1

; --- ICON_SCREEN_POS ------------------------------------------
; @done
; Screen-address per icon: 9 x DW (low,high) in the screen bitmap
; ($400D,$406D,$482D,$488D,$48CD…). show_icon_A doubles the icon code
; and reads the pair as the destination address where that spell/status
; icon is blitted (extended_sprites uses code-8 for the second bank).
; Note: absolute screen addresses (fixed hardware anchor, do not relocate).
; Referenced by: show_icon_A, extended_sprites (ADDR_TABLE index $06)
		debug "ICON_SCREEN_POS: "
ICON_SCREEN_POS:
		DB 0
		DB 0
		DB $0D
		DB $40
		DB $6D
		DB $40
		DB $2D
		DB $48
		DB $8D
		DB $48
		DB $CD
		DB $40
		DB $CD
		DB $40
		DB $CD
		DB $40
		DB $CD
		DB $40

		debug "   tables end: "
