; --- (unlabeled special-location table @ $6460) --------------
; @wip
; No label (included inline between load_save_file and push_pop_regs).
; Two parts:
;  1) 5 x 4-byte fixed-location records {DB x, DB y, DB facing, DB ?}
;     for named spots (Scarlet bard start, Guild, Mangar tower,
;     teleport target, and one more).
;  2) A trailing 1-byte-per-entry column ($21/$2B/$23/$24/$26/$40 …)
;     — a per-location tile/attribute code list.
; Note: record meaning of byte 4 and the trailing column not fully
; reverse-engineered.
FIXED_LOCATIONS:
		; Scarlet bard
		DB $1C		; X
		DB 5		; Y
		DB 1		; facing east
		DB 0		; ??? ground ???

		; Guild
		DB $18		; X
		DB $0F		; Y
		DB 3		; facing west
		DB 0		; ??? ground ???

		; Mangar tower
		DB 1
		DB 1
		DB 0
		DB 0

		; teleport
		DB $1C
		DB $1C
		DB 3
		DB 0

		; ?
		DB 0
		DB 0
		DB 0
		DB 1

LOCATION_TILE_COL:
		DB $21
		DB $21
		DB $21
		DB $21
		DB $21
		DB $21
		DB $21
		DB $21
		DB $21
		DB $2B
		DB $2B
		DB $2B
		DB $2B
		DB $21
		DB $21
		DB $23
		DB $23
		DB $23
		DB $23
		DB $21
		DB $21
		DB $24
		DB $24
		DB $24
		DB $24
		DB $21
		DB $21
		DB $26
		DB $26
		DB $26
		DB $26
		DB $21
		DB $21
		DB $40
		DB $40
		DB $40
		DB $40
		DB $21
		DB $24
		DB $40
