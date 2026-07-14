; --- wall_element_table ($DC6C-$DDFB) ------------------------
; @done
; The 3D-view element table: 16 rows (view slot / depth e=0..15) x 5 records,
; each 5 bytes {DB dim, DW screen_pos, DW sprite}. draw_wall_element indexes it
; as wall_element_table + $19*e + 5*b (nominal base $DD5F = table-$1E, so its
; +$19*(e+1)+5*(b+1) addressing lands the first record here). dim>>3-1 = width;
; the DW sprite points at one of the labelled bitmaps in sprites.asm.

wall_element_table:
	; --- view slot 0 ---
		DB $10 : DW $0000,sprite_00
		DB $10 : DW $0600,sprite_03
		DB $20 : DW $1400,sprite_01
		DB $28 : DW $1E00,sprite_04
		DB $30 : DW $2600,sprite_02
	; --- view slot 1 ---
		DB $10 : DW $0000,sprite_00
		DB $10 : DW $0600,sprite_19
		DB $20 : DW $1400,sprite_20
		DB $28 : DW $1E00,sprite_21
		DB $30 : DW $2600,sprite_22
	; --- view slot 2 ---
		DB $60 : DW $0001,sprite_00
		DB $60 : DW $0601,sprite_03
		DB $50 : DW $1401,sprite_01
		DB $48 : DW $1E01,sprite_04
		DB $40 : DW $2601,sprite_02
	; --- view slot 3 ---
		DB $60 : DW $0001,sprite_00
		DB $60 : DW $0601,sprite_19
		DB $50 : DW $1401,sprite_20
		DB $48 : DW $1E01,sprite_21
		DB $40 : DW $2601,sprite_22
	; --- view slot 4 ---
		DB $10 : DW $0600,sprite_05
		DB $10 : DW $1400,sprite_06
		DB $20 : DW $1E00,sprite_07
		DB $28 : DW $2600,sprite_08
		DB $30 : DW $2A00,sprite_09
	; --- view slot 5 ---
		DB $10 : DW $0600,sprite_05
		DB $10 : DW $1400,sprite_23
		DB $20 : DW $1E00,sprite_24
		DB $28 : DW $2600,sprite_25
		DB $30 : DW $2A00,sprite_26
	; --- view slot 6 ---
		DB $60 : DW $0601,sprite_05
		DB $60 : DW $1401,sprite_06
		DB $50 : DW $1E01,sprite_07
		DB $48 : DW $2601,sprite_08
		DB $40 : DW $2A01,sprite_09
	; --- view slot 7 ---
		DB $60 : DW $0601,sprite_05
		DB $60 : DW $1401,sprite_23
		DB $50 : DW $1E01,sprite_24
		DB $48 : DW $2601,sprite_25
		DB $40 : DW $2A01,sprite_26
	; --- view slot 8 ---
		DB $10 : DW $1400,sprite_10
		DB $10 : DW $1400,sprite_10
		DB $10 : DW $1E00,sprite_11
		DB $20 : DW $2600,sprite_12
		DB $30 : DW $2A00,sprite_13
	; --- view slot 9 ---
		DB $10 : DW $1400,sprite_27
		DB $10 : DW $1400,sprite_27
		DB $10 : DW $1E00,sprite_28
		DB $20 : DW $2600,sprite_29
		DB $30 : DW $2A00,sprite_30
	; --- view slot 10 ---
		DB $60 : DW $1401,sprite_10
		DB $60 : DW $1401,sprite_10
		DB $60 : DW $1E01,sprite_11
		DB $50 : DW $2601,sprite_12
		DB $40 : DW $2A01,sprite_13
	; --- view slot 11 ---
		DB $60 : DW $1401,sprite_27
		DB $60 : DW $1401,sprite_27
		DB $60 : DW $1E01,sprite_28
		DB $50 : DW $2601,sprite_29
		DB $40 : DW $2A01,sprite_30
	; --- view slot 12 ---
		DB $10 : DW $0600,sprite_14
		DB $20 : DW $1400,sprite_15
		DB $28 : DW $1E00,sprite_16
		DB $30 : DW $2600,sprite_17
		DB $38 : DW $2A00,sprite_18
	; --- view slot 13 ---
		DB $10 : DW $0600,sprite_31
		DB $20 : DW $1400,sprite_32
		DB $28 : DW $1E00,sprite_33
		DB $30 : DW $2600,sprite_34
		DB $38 : DW $2A00,sprite_35
	; --- view slot 14 ---
		DB $20 : DW $0000,sprite_36
		DB $20 : DW $0B00,sprite_37
		DB $30 : DW $1800,sprite_38
		DB $30 : DW $2100,sprite_39
		DB $38 : DW $2700,sprite_40
	; --- view slot 15 ---
		DB $20 : DW $5500,sprite_41
		DB $20 : DW $4500,sprite_42
		DB $30 : DW $3B00,sprite_43
		DB $30 : DW $3400,sprite_44
		DB $38 : DW $3000,sprite_40
