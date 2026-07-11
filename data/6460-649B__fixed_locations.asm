; --- FIXED_LOCATIONS ------------------------------------------
; @done
; Dungeon-entry positions, one 4-byte record per tape/level, read by
; insert_skara_tape when you descend into a dungeon. It indexes
; FIXED_LOCATIONS + tape_id*4 (capped at +$10 = record 4) and loads:
;   byte 0 -> VAR_COORD_WE_EA  (X, west/east)
;   byte 1 -> VAR_COORD_SO_NO  (Y, south/north)
;   byte 2 -> VAR_FACE_DIRECTION (0-3)
;   byte 3 -> VAR_UNDERGROUND   (0 = surface, 1 = dungeon)
; (5 records: Scarlet-bard/Cellars start, Guild, Mangar tower, teleport
; target, + one surface entry.) LOCATION_TILE_COL below is a parallel
; per-level table read via the set_level_name SMC (LOCATION_TILE_COL +
; level*2): its 2 bytes are copied to TEXT_BUFFER as the level's display
; /tile code pair before the name buffer is cleared.
FIXED_LOCATIONS:
		; Scarlet bard
		DB $1C		; X
		DB 5		; Y
		DB 1		; facing east
		DB 0		; underground flag (0=surface)

		; Guild
		DB $18		; X
		DB $0F		; Y
		DB 3		; facing west
		DB 0		; underground flag (0=surface)

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
