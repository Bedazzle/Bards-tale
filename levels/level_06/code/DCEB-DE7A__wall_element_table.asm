; --- wall_element_table ($DCEB-$DE7A) ------------------------
; @done
; 16 view slots x 5 records {DB dim, DW screen_pos, DW sprite}. draw_wall_element:
; base+$19*e+5*b (nominal base $DCCD=table-$1E). DW sprite -> the Catacombs bitmaps.
wall_element_table:
	; --- view slot 0 ---
		DB $10 : DW $0000,sprite_DE7B
		DB $10 : DW $0600,sprite_DED6
		DB $20 : DW $1400,sprite_DFBD
		DB $28 : DW $1E00,sprite_E020
		DB $30 : DW $2600,sprite_E05B
	; --- view slot 1 ---
		DB $10 : DW $0000,sprite_DE7B
		DB $10 : DW $0600,sprite_E7AD
		DB $20 : DW $1400,sprite_E894
		DB $28 : DW $1E00,sprite_E8F7
		DB $30 : DW $2600,sprite_E932
	; --- view slot 2 ---
		DB $60 : DW $0001,sprite_DE7B
		DB $60 : DW $0601,sprite_DED6
		DB $50 : DW $1401,sprite_DFBD
		DB $48 : DW $1E01,sprite_E020
		DB $40 : DW $2601,sprite_E05B
	; --- view slot 3 ---
		DB $60 : DW $0001,sprite_DE7B
		DB $60 : DW $0601,sprite_E7AD
		DB $50 : DW $1401,sprite_E894
		DB $48 : DW $1E01,sprite_E8F7
		DB $40 : DW $2601,sprite_E932
	; --- view slot 4 ---
		DB $10 : DW $0600,sprite_E06B
		DB $10 : DW $1400,sprite_E0BA
		DB $20 : DW $1E00,sprite_E14D
		DB $28 : DW $2600,sprite_E188
		DB $30 : DW $2A00,sprite_E1A3
	; --- view slot 5 ---
		DB $10 : DW $0600,sprite_E06B
		DB $10 : DW $1400,sprite_E941
		DB $20 : DW $1E00,sprite_E9D4
		DB $28 : DW $2600,sprite_EA0F
		DB $30 : DW $2A00,sprite_EA2A
	; --- view slot 6 ---
		DB $60 : DW $0601,sprite_E06B
		DB $60 : DW $1401,sprite_E0BA
		DB $50 : DW $1E01,sprite_E14D
		DB $48 : DW $2601,sprite_E188
		DB $40 : DW $2A01,sprite_E1A3
	; --- view slot 7 ---
		DB $60 : DW $0601,sprite_E06B
		DB $60 : DW $1401,sprite_E941
		DB $50 : DW $1E01,sprite_E9D4
		DB $48 : DW $2601,sprite_EA0F
		DB $40 : DW $2A01,sprite_EA2A
	; --- view slot 8 ---
		DB $10 : DW $1400,sprite_E1AA
		DB $10 : DW $1400,sprite_E1AA
		DB $10 : DW $1E00,sprite_E1DD
		DB $20 : DW $2600,sprite_E234
		DB $30 : DW $2A00,sprite_E24F
	; --- view slot 9 ---
		DB $10 : DW $1400,sprite_EA31
		DB $10 : DW $1400,sprite_EA31
		DB $10 : DW $1E00,sprite_EA64
		DB $20 : DW $2600,sprite_EABB
		DB $30 : DW $2A00,sprite_EAE3
	; --- view slot 10 ---
		DB $60 : DW $1401,sprite_E1AA
		DB $60 : DW $1401,sprite_E1AA
		DB $60 : DW $1E01,sprite_E1DD
		DB $50 : DW $2601,sprite_E234
		DB $40 : DW $2A01,sprite_E24F
	; --- view slot 11 ---
		DB $60 : DW $1401,sprite_EA31
		DB $60 : DW $1401,sprite_EA31
		DB $60 : DW $1E01,sprite_EA64
		DB $50 : DW $2601,sprite_EABB
		DB $40 : DW $2A01,sprite_EAE3
	; --- view slot 12 ---
		DB $10 : DW $0600,sprite_E256
		DB $20 : DW $1400,sprite_E59D
		DB $28 : DW $1E00,sprite_E6F0
		DB $30 : DW $2600,sprite_E77F
		DB $38 : DW $2A00,sprite_E7A6
	; --- view slot 13 ---
		DB $10 : DW $0600,sprite_EAEA
		DB $20 : DW $1400,sprite_EE31
		DB $28 : DW $1E00,sprite_EF84
		DB $30 : DW $2600,sprite_F013
		DB $38 : DW $2A00,sprite_F03A
	; --- view slot 14 ---
		DB $20 : DW $0000,sprite_F041
		DB $20 : DW $0D00,sprite_F059
		DB $30 : DW $1800,sprite_F094
		DB $30 : DW $2100,sprite_F0A6
		DB $38 : DW $2700,sprite_F0B2
	; --- view slot 15 ---
		DB $20 : DW $5500,sprite_F0B7
		DB $20 : DW $4300,sprite_F0CF
		DB $30 : DW $3B00,sprite_F10A
		DB $30 : DW $3400,sprite_F11C
		DB $38 : DW $3000,sprite_F0B2
