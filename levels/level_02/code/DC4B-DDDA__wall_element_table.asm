; --- wall_element_table ------------------------------------
; @done
; 16 elements x 5 depth positions, each: DB dim : DW screen_pos : DW sprite.
; Indexed by draw_wall_element as (wall_element_table-$1E)+(pos+1)*5+(elem+1)*$19.
wall_element_table:
	; element 0
		DB $10 : DW $0000 : DW sprite_DDDB
		DB $10 : DW $0600 : DW sprite_DE36
		DB $20 : DW $1400 : DW sprite_DF1D
		DB $28 : DW $1E00 : DW sprite_DF80
		DB $30 : DW $2600 : DW sprite_DFBB
	; element 1
		DB $10 : DW $0000 : DW sprite_DDDB
		DB $10 : DW $0600 : DW sprite_E714
		DB $20 : DW $1400 : DW sprite_E7FB
		DB $28 : DW $1E00 : DW sprite_E85E
		DB $30 : DW $2600 : DW sprite_E899
	; element 2
		DB $60 : DW $0001 : DW sprite_DDDB
		DB $60 : DW $0601 : DW sprite_DE36
		DB $50 : DW $1401 : DW sprite_DF1D
		DB $48 : DW $1E01 : DW sprite_DF80
		DB $40 : DW $2601 : DW sprite_DFBB
	; element 3
		DB $60 : DW $0001 : DW sprite_DDDB
		DB $60 : DW $0601 : DW sprite_E714
		DB $50 : DW $1401 : DW sprite_E7FB
		DB $48 : DW $1E01 : DW sprite_E85E
		DB $40 : DW $2601 : DW sprite_E899
	; element 4
		DB $10 : DW $0600 : DW sprite_DFCA
		DB $10 : DW $1400 : DW sprite_E019
		DB $20 : DW $1E00 : DW sprite_E0AC
		DB $28 : DW $2600 : DW sprite_E0E7
		DB $30 : DW $2A00 : DW sprite_E102
	; element 5
		DB $10 : DW $0600 : DW sprite_DFCA
		DB $10 : DW $1400 : DW sprite_E8A8
		DB $20 : DW $1E00 : DW sprite_E93B
		DB $28 : DW $2600 : DW sprite_E976
		DB $30 : DW $2A00 : DW sprite_E991
	; element 6
		DB $60 : DW $0601 : DW sprite_DFCA
		DB $60 : DW $1401 : DW sprite_E019
		DB $50 : DW $1E01 : DW sprite_E0AC
		DB $48 : DW $2601 : DW sprite_E0E7
		DB $40 : DW $2A01 : DW sprite_E102
	; element 7
		DB $60 : DW $0601 : DW sprite_DFCA
		DB $60 : DW $1401 : DW sprite_E8A8
		DB $50 : DW $1E01 : DW sprite_E93B
		DB $48 : DW $2601 : DW sprite_E976
		DB $40 : DW $2A01 : DW sprite_E991
	; element 8
		DB $10 : DW $1400 : DW sprite_E109
		DB $10 : DW $1400 : DW sprite_E109
		DB $10 : DW $1E00 : DW sprite_E13C
		DB $20 : DW $2600 : DW sprite_E19B
		DB $30 : DW $2A00 : DW sprite_E1B6
	; element 9
		DB $10 : DW $1400 : DW sprite_E998
		DB $10 : DW $1400 : DW sprite_E998
		DB $10 : DW $1E00 : DW sprite_E9CB
		DB $20 : DW $2600 : DW sprite_EA22
		DB $30 : DW $2A00 : DW sprite_EA3D
	; element 10
		DB $60 : DW $1401 : DW sprite_E109
		DB $60 : DW $1401 : DW sprite_E109
		DB $60 : DW $1E01 : DW sprite_E13C
		DB $50 : DW $2601 : DW sprite_E19B
		DB $40 : DW $2A01 : DW sprite_E1B6
	; element 11
		DB $60 : DW $1401 : DW sprite_E998
		DB $60 : DW $1401 : DW sprite_E998
		DB $60 : DW $1E01 : DW sprite_E9CB
		DB $50 : DW $2601 : DW sprite_EA22
		DB $40 : DW $2A01 : DW sprite_EA3D
	; element 12
		DB $10 : DW $0600 : DW sprite_E1BD
		DB $20 : DW $1400 : DW sprite_E504
		DB $28 : DW $1E00 : DW sprite_E657
		DB $30 : DW $2600 : DW sprite_E6E6
		DB $38 : DW $2A00 : DW sprite_E70D
	; element 13
		DB $10 : DW $0600 : DW sprite_EA44
		DB $20 : DW $1400 : DW sprite_ED8B
		DB $28 : DW $1E00 : DW sprite_EEDE
		DB $30 : DW $2600 : DW sprite_EF6D
		DB $38 : DW $2A00 : DW sprite_EF94
	; element 14
		DB $20 : DW $0000 : DW sprite_EF9B
		DB $20 : DW $0B00 : DW sprite_EFB3
		DB $30 : DW $1800 : DW sprite_EFEE
		DB $30 : DW $2100 : DW sprite_F000
		DB $38 : DW $2700 : DW sprite_F00C
	; element 15
		DB $20 : DW $5500 : DW sprite_F011
		DB $20 : DW $4500 : DW sprite_F029
		DB $30 : DW $3B00 : DW sprite_F064
		DB $30 : DW $3400 : DW sprite_F076
		DB $38 : DW $3000 : DW sprite_F00C
