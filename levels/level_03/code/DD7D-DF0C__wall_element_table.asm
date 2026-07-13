; --- wall_element_table ($DD7D-$DF0C) ------------------------
; @done
; The 3D-view element table: 16 rows (view slot / depth e=0..15) x 5 records,
; each 5 bytes {DB dim, DW screen_pos, DW sprite}. draw_wall_element indexes it
; as wall_element_table + $19*e + 5*b (nominal base $DD5F = table-$1E, so its
; +$19*(e+1)+5*(b+1) addressing lands the first record here). dim>>3-1 = width;
; the DW sprite points at one of the labelled bitmaps in sprites.asm.
wall_element_table:
	; --- view slot 0 ---
		DB $10 : DW $0000,sprite_DF0D
		DB $10 : DW $0600,sprite_DFDC
		DB $20 : DW $1400,sprite_DF68
		DB $28 : DW $1E00,sprite_E0C3
		DB $30 : DW $2600,sprite_DFCD
	; --- view slot 1 ---
		DB $10 : DW $0000,sprite_DF0D
		DB $10 : DW $0600,sprite_E847
		DB $20 : DW $1400,sprite_E92E
		DB $28 : DW $1E00,sprite_E991
		DB $30 : DW $2600,sprite_E9CC
	; --- view slot 2 ---
		DB $60 : DW $0001,sprite_DF0D
		DB $60 : DW $0601,sprite_DFDC
		DB $50 : DW $1401,sprite_DF68
		DB $48 : DW $1E01,sprite_E0C3
		DB $40 : DW $2601,sprite_DFCD
	; --- view slot 3 ---
		DB $60 : DW $0001,sprite_DF0D
		DB $60 : DW $0601,sprite_E847
		DB $50 : DW $1401,sprite_E92E
		DB $48 : DW $1E01,sprite_E991
		DB $40 : DW $2601,sprite_E9CC
	; --- view slot 4 ---
		DB $10 : DW $0600,sprite_E0FE
		DB $10 : DW $1400,sprite_E14D
		DB $20 : DW $1E00,sprite_E1E0
		DB $28 : DW $2600,sprite_E21B
		DB $30 : DW $2A00,sprite_E236
	; --- view slot 5 ---
		DB $10 : DW $0600,sprite_E0FE
		DB $10 : DW $1400,sprite_E9DB
		DB $20 : DW $1E00,sprite_EA6E
		DB $28 : DW $2600,sprite_EAA9
		DB $30 : DW $2A00,sprite_EAC4
	; --- view slot 6 ---
		DB $60 : DW $0601,sprite_E0FE
		DB $60 : DW $1401,sprite_E14D
		DB $50 : DW $1E01,sprite_E1E0
		DB $48 : DW $2601,sprite_E21B
		DB $40 : DW $2A01,sprite_E236
	; --- view slot 7 ---
		DB $60 : DW $0601,sprite_E0FE
		DB $60 : DW $1401,sprite_E9DB
		DB $50 : DW $1E01,sprite_EA6E
		DB $48 : DW $2601,sprite_EAA9
		DB $40 : DW $2A01,sprite_EAC4
	; --- view slot 8 ---
		DB $10 : DW $1400,sprite_E23D
		DB $10 : DW $1400,sprite_E23D
		DB $10 : DW $1E00,sprite_E270
		DB $20 : DW $2600,sprite_E2C7
		DB $30 : DW $2A00,sprite_E2E2
	; --- view slot 9 ---
		DB $10 : DW $1400,sprite_EACB
		DB $10 : DW $1400,sprite_EACB
		DB $10 : DW $1E00,sprite_EAFE
		DB $20 : DW $2600,sprite_EB55
		DB $30 : DW $2A00,sprite_EB70
	; --- view slot 10 ---
		DB $60 : DW $1401,sprite_E23D
		DB $60 : DW $1401,sprite_E23D
		DB $60 : DW $1E01,sprite_E270
		DB $50 : DW $2601,sprite_E2C7
		DB $40 : DW $2A01,sprite_E2E2
	; --- view slot 11 ---
		DB $60 : DW $1401,sprite_EACB
		DB $60 : DW $1401,sprite_EACB
		DB $60 : DW $1E01,sprite_EAFE
		DB $50 : DW $2601,sprite_EB55
		DB $40 : DW $2A01,sprite_EB70
	; --- view slot 12 ---
		DB $10 : DW $0600,sprite_E2E9
		DB $20 : DW $1400,sprite_E630
		DB $28 : DW $1E00,sprite_E78A
		DB $30 : DW $2600,sprite_E819
		DB $38 : DW $2A00,sprite_E840
	; --- view slot 13 ---
		DB $10 : DW $0600,sprite_EB77
		DB $20 : DW $1400,sprite_EEBE
		DB $28 : DW $1E00,sprite_F011
		DB $30 : DW $2600,sprite_F0A0
		DB $38 : DW $2A00,sprite_F0C7
	; --- view slot 14 ---
		DB $20 : DW $0000,sprite_F0CE
		DB $20 : DW $0B00,sprite_F0E6
		DB $30 : DW $1800,sprite_F121
		DB $30 : DW $2100,sprite_F133
		DB $38 : DW $2700,sprite_F13F
	; --- view slot 15 ---
		DB $20 : DW $5500,sprite_F144
		DB $20 : DW $4500,sprite_F15C
		DB $30 : DW $3B00,sprite_F197
		DB $30 : DW $3400,sprite_F1A9
		DB $38 : DW $3000,sprite_F13F
