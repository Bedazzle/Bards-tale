; --- INDEX_MONSTER_LENGTHS ------------------------------------
; @done
; Monster-name length table for the 5-bit packed-text decoder, parallel
; to INDEX_MONSTER_NAMES. [0]=$93 (header/base byte); the rest give each
; monster name's length in 5-bit symbols (same len*5/8 skip as
; messages_table). Zero entries mark unused ids. Trailing comments name
; each monster id; entries $B9-$BC are the compass words north/east/
; south/west.
; Referenced by: print_msg_setup (BT_game) -> print_msg_no_cp
;               (hl=INDEX_MONSTER_LENGTHS, de=INDEX_MONSTER_NAMES).
INDEX_MONSTER_LENGTHS:
		DB $93	; 00 = Kobold

		DB 9
		DB 9
		DB 8
		DB $0A
		DB $0A
		DB $0C
		DB 0
		DB 0
		DB 6
		DB $0B
		DB 8
		DB 9
		DB $0A
		DB $0C
		DB $0E
		DB 9
		DB $0C
		DB $0B
		DB $0D
		DB 9
		DB $0B
		DB $0B
		DB $0B
		DB 9
		DB 7
		DB $0E
		DB $0B
		DB $0D
		DB 7
		DB 8
		DB 9
		DB $0D
		DB $0E
		DB $11
		DB 0
		DB 0
		DB 0
		DB 0
		DB 8
		DB $0A
		DB $0F
		DB $0F
		DB $0E
		DB 9
		DB $0D
		DB $12
		DB $0E
		DB 9
		DB $0D
		DB $0F
		DB 8
		DB 0
		DB 0
		DB 0
		DB 0
		DB $0D
		DB $0C
		DB 8
		DB $0F
		DB 9
		DB 9
		DB $0D
		DB $10
		DB $0D
		DB 9
		DB $0C
		DB 0
		DB 0
		DB 0
		DB 0
		DB $0F
		DB $0C
		DB $0C
		DB $0C
		DB $10
		DB 7
		DB $0A
		DB $0F
		DB 7
		DB 0
		DB 0
		DB 0
		DB 0
		DB $0F
		DB $0C
		DB $16
		DB $0F
		DB 8
		DB $0E
		DB $0B
		DB $0B
		DB 8
		DB 8
		DB $0A
		DB 8
		DB $10
		DB $0F
		DB 8
		DB $0F
		DB 7
		DB $0D
		DB 8
		DB $12
		DB $12
		DB $12
		DB $0E
		DB $0A
		DB $0E
		DB $0B
		DB $0F
		DB $10
		DB $10
		DB $0B
		DB $0E
		DB $10
		DB $0D
		DB $0F
		DB 6
		DB $11
		DB $0E
		DB $0E
		DB $12
		DB 9
		DB 8
		DB $0B
		DB $0D			; 7F = Old Man
		DB $0B			; 80 = Human
		DB 5
		DB 3
		DB 5
		DB 6
		DB $0B
		DB $0B			; 85 = Gnome
		DB 5			; 86 = Warrior
		DB 7
		DB 6
		DB 8
		DB 8
		DB 8
		DB 5
		DB 4
		DB 7
		DB 6			; 8F = Monk
		DB 4
		DB 5
		DB $0A
		DB $0E
		DB 7
		DB 7
		DB 5
		DB 7
		DB 5
		DB 5
		DB 5
		DB 9
		DB 5
		DB 6
		DB 6
		DB 7
		DB 6
		DB $0F
		DB 5
		DB 6
		DB $0A
		DB 7
		DB $13
		DB $14
		DB 7
		DB 9
		DB 6
		DB $0F
		DB 5
		DB 5
		DB 6
		DB 6
		DB 5
		DB 6
		DB 6
		DB 5
		DB 6
		DB 7
		DB 7
		DB 5
		DB 6
		DB 7			; B9 = north,
		DB 8			; BA = east,
		DB 7			; BB = south,
		DB 8			; BC = west,
