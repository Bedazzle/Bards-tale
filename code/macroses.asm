; --- RST 10h macro library ------------------------------------
; @done
; Macros that emit the RST 10h dispatch sequence "rst $10 : DB id [: params]".
; At run time RST 10h enters run_dynamic, which looks the id up in the
; procs/ADDR_TABLE and calls the target routine. The DB id is that table index.
; This file only DEFINEs macros; it emits no bytes on its own.

		; procs_buffer

		MACRO SHOW_PIC_BY_A
			rst	$10
			DB 1			; show_pic_by_A
		ENDM

		MACRO SHOW_PIC_BY_PARAM param
			rst	$10
			DB 2			; show_pic_by_param
			DB param
		ENDM

		MACRO SHOW_NAME_PIC_AB
			rst	$10
			DB 3			; show_name_pic_AB
		ENDM

		MACRO SHOW_NAME_AND_PICTURE object,picture
			rst	$10
			DB 4			; show_name_and_pic
			DB object
			DB picture
		ENDM

		MACRO PRINT_2_NEWLINES
			rst	$10
			DB 5			; print_2newlines
		ENDM

		MACRO ZERO_BUFFERS
			rst	$10
			DB 6			; zero_buffers
		ENDM

		MACRO PRINT_MESSAGE param
			rst	$10
			DB 7			; print_msg
			DB param
		ENDM

		MACRO PRINT_CRLF_AND_MESSAGE param
			rst	$10
			DB 8			; print_crlf_msg
			DB param
		ENDM

		MACRO RESET_COL
			rst	$10
			DB 9			; reset_col
		ENDM

		MACRO RESET_ROW_COL
			rst	$10
			DB $0A			; reset_row_col
		ENDM

		MACRO PRINT_MESSAGE2 param	; set/clear AF' flag ??? capitalize ???
			rst	$10
			DB $0B			; print_msg_param_2
			DB param
		ENDM

		MACRO PRINT2_IN_LOOP
			rst	$10
			DB $0C			; print2_in_loop
		ENDM

		MACRO PRINT_IN_LOOP
			rst	$10
			DB $0D			; print_in_loop
		ENDM

		MACRO PRINT2_A_WITH_FLAG_0
			rst	$10
			DB $0E			; print2_flag_0
		ENDM

		MACRO PRINT2_A_WITH_FLAG_1
			rst	$10
			DB $0F			; print2_flag_1
		ENDM

		MACRO PRINT_ITEM_NAME
			rst	$10
			DB $10			; print_item_name
		ENDM

		MACRO PRINT_WORD
			rst	$10
			DB $11			; print_word
		ENDM

		MACRO CLEAN_HERO_MEMORY
			rst	$10
			DB $12			; clean_hero_memory
		ENDM

		MACRO PRINT_IX_HERO_NAME
			rst	$10
			DB $13			; print_IX_heroname
		ENDM

		MACRO PRINT_EMPTY
			rst	$10
			DB $14			; print_empty
		ENDM

		MACRO FIND_HERO_BY_B
			rst	$10
			DB $15			; find_hero_by_B
		ENDM

		MACRO FIND_HERO_BY_A
			rst	$10
			DB $16			; find_hero_by_A
		ENDM

		MACRO GET_ATTR_BY_PARAM param
			rst	$10
			DB $17			; get_attr_by_param
			DB param
		ENDM

		MACRO GET_ATTR_BY_PARAM_SAVE_HL param
			rst	$10
			DB $18			; get_attr_by_param_save_HL
			DB param
		ENDM

		MACRO GET_GAME_VARIABLE param
			rst	$10
			DB $19			; get_game_variable
			DB param
		ENDM

		MACRO GET_B_FROM_LIST param
			rst	$10
			DB $1B			; get_B_from_list
			DB param
		ENDM

		MACRO GET_C_FROM_LIST param
			rst	$10
			DB $1C			; get_C_from_list
			DB param
		ENDM

		MACRO GET_E_FROM_LIST param
			rst	$10
			DB $1D			; get_E_from_list
			DB param
		ENDM

		MACRO PRINT_WITH_CODES
			rst	$10
			DB $1E			; prnt_with_codes
		ENDM

		MACRO PRINT_DIGIT
			rst	$10
			DB $1F			; print_digit
		ENDM

		MACRO PRINT_NEXT_DIGIT
			rst	$10
			DB $20			; prnt_next_digit
		ENDM

		MACRO CLEAR_INFO_PANEL
			rst	$10
			DB $21			; clear	info panel
		ENDM

		MACRO PRINT_WHO_WILL
			rst	$10
			DB $22			; print_who_will
		ENDM

		MACRO WAIT_KEY_DOWN
			rst	$10
			DB $23			; wait_key_down
		ENDM

		MACRO PRINT_AND_WAIT
			rst	$10
			DB $24			; print_and_wait
		ENDM

		MACRO GET_RND_NUMBERS
			rst	$10
			DB $25			; get_rnd_numbers
		ENDM

		MACRO PRINT_NUM_FROM_DE
			rst	$10
			DB $26			; print_num_from_DE
		ENDM

		MACRO PRINT_NUM_FROM_E
			rst	$10
			DB $27			; print_num_from_E
		ENDM

		MACRO CHECK_HERO_STATUS
			rst	$10
			DB $28			; check_hero_status

			; Z is set if OK
			; C is set if OK
		ENDM

		MACRO PRINT_YES_NO_WAIT
			rst	$10
			DB $2B			; print_yesno_wait
		ENDM

		MACRO PRINT_STATS_TABLE
			rst	$10
			DB $2D			; print_stats_table
		ENDM

		MACRO SHOW_ICON param
			rst	$10
			DB $31			; show_icon
			DB param
		ENDM

		MACRO CALC_IN_FB7D
			rst	$10
			DB $32			; calc_in_FB7D
		ENDM

		MACRO CHANGE_SPEED param
			rst	$10
			DB $33			; change_speed
			DB param
		ENDM

		MACRO CHANGE_SPEED_TO_8
			rst	$10
			DB $34			; change_speed_8
		ENDM

		MACRO PRINT_SPACE
			rst	$10
			DB $35			; print_space
		ENDM

		MACRO PRINT_NEWLINE
			rst	$10
			DB $36			; print_newline
		ENDM

		MACRO PRINT_SPACE_LINE
			rst	$10			; --clear 15 horizontal	cells--
			DB $37			; prnt_space_line
		ENDM

		MACRO PUSH_REGS
			rst	$10
			DB $38			; push_regs
		ENDM

		MACRO GET_A_FROM_TABLE param
			rst	$10
			DB $39			; get_A_from_table
			DB param
		ENDM

		MACRO GET_B_FROM_TABLE param
			rst	$10
			DB $3A			; get_B_from_table
			DB param
		ENDM

		MACRO GET_C_FROM_TABLE param
			rst	$10
			DB $3B			; get_C_from_table
			DB param
		ENDM

		MACRO GET_D_FROM_TABLE param
			rst	$10
			DB $3C			; get_D_from_table
			DB param
		ENDM

		MACRO GET_E_FROM_TABLE param
			rst	$10
			DB $3D			; get_E_from_table
			DB param
		ENDM

		MACRO GET_H_FROM_TABLE param
			rst	$10
			DB $3E			; get_H_from_table
			DB param
		ENDM

		MACRO GET_L_FROM_TABLE param
			rst	$10
			DB $3F			; get_L_from_table
			DB param
		ENDM

		MACRO GET_IY_A_FROM_TABLE param1,param2
			rst	$10
			DB $40			; get_IY_A_from_table
			DB param1
			DB param2
		ENDM

		MACRO CONVERT_12_DIGITS
			rst	$10
			DB $41			; convert_12_digits
		ENDM

		MACRO CHECK_EQUIPPED param
			rst	$10
			DB $43			; check_equipped
			DB param
		ENDM

		MACRO GET_ATTR_BY_A
			rst	$10
			DB $44			; get_attr_by_A
		ENDM

		MACRO ADD_RND_NUMBER
			rst	$10
			DB $46			; add_rnd_number
		ENDM

		MACRO A_PLUS_C_TO_HL
			rst	$10
			DB $47			; a_plus_c_to_hl
		ENDM

		MACRO ENTER_1_TO_8
			rst	$10
			DB $4C			; enter_1_to_8
		ENDM

		MACRO CHOOSE_HERO
			rst	$10
			DB $4E			; choose_hero
		ENDM

		MACRO ENTER_1_TO_6
			rst	$10
			DB $4D			; enter_1_to_6
		ENDM

		MACRO CLEAN_ALLY_MEMORY
			rst	$10
			DB $4F			; clean_ally_memory
		ENDM

		MACRO FIND_INN param
			rst	$10
			DB $50			; find_inn
			DB param
		ENDM

		MACRO PRINT_LOCATION_NAME
			rst	$10
			DB $52			; print_loc_name
		ENDM

		MACRO SHOW_DAMAGE
			rst	$10
			DB $54			; show_damage
		ENDM

		MACRO ATTACK_AND_RESULT
			rst	$10
			DB $55			; attack_and_result
		ENDM

		MACRO PRINT_MEMBERS_COUNT
			rst	$10
			DB $56			; print_memb_num
		ENDM

		MACRO CLEAR_TXT_BUFFER
			rst	$10
			DB $58			; clear_txt_buffer
		ENDM

		MACRO PRINT_LETTER_PAIR
			rst	$10
			DB $59			; print_letter_pair
		ENDM

		MACRO PRINT_HERO_ATTR
			rst	$10
			DB $5A			; print_hero_attr
		ENDM

		MACRO NULLIFY_FB5B
			rst	$10
			DB $5B			; nullify_FB5B
		ENDM

		MACRO EXEC_FOR_HEROES param
			rst	$10
			DB $5E			; exec_for_heroes
			DW param
		ENDM

		MACRO IF_FB98_IS_ZERO
			rst	$10
			DB $5F			; if_FB98_is_zero
		ENDM

		MACRO GET_RND_BY_PARAM param
			rst	$10
			DB $60			; get_rnd_by_param
			DB param
		ENDM


		; ---------------------------


		MACRO GET_ATTR_SAVE_IX param
			rst	$10
			DB 0
			DB param
		ENDM

		MACRO FIND_ATTR_AND_ADDRESS param
			rst	$10
			DB $1A			; find_attr_and_address
			DB param
		ENDM

		MACRO CHANGE_COMBAT_SPEED
			rst	$10
			DB $29
		ENDM

		MACRO CHECK_FLEE_RESULT
			rst	$10
			DB $2A
		ENDM

		MACRO CHECK_ALL_HEROES
			rst	$10
			DB $2E
		ENDM

		MACRO FIND_ALIVE_HERO
			rst	$10
			DB $2F
		ENDM

		MACRO SELECT_TARGET
			rst	$10
			DB $30
		ENDM

		MACRO CHECK_SPELL_COST
			rst	$10
			DB $42
		ENDM

		MACRO ADJUST_VALUE
			rst	$10
			DB $45
		ENDM

		MACRO ROLL_DAMAGE
			rst	$10
			DB $48
		ENDM

		MACRO RESET_DAMAGE
			rst	$10
			DB $49
		ENDM

		MACRO RECALC_ALL_AC
			rst	$10
			DB $4A
		ENDM

		MACRO DISPATCH_MOVEMENT
			rst	$10
			DB $4B
		ENDM

		MACRO PICK_RANDOM_HERO
			rst	$10
			DB $51
		ENDM

		MACRO PRINT_ACTOR_NAME
			rst	$10
			DB $53
		ENDM

		MACRO CALC_SPELL_FX
			rst	$10
			DB $57
		ENDM

		MACRO CALC_MONSTER_HP
			rst	$10
			DB $5C
		ENDM

		MACRO CHECK_THREE_HEROES
			rst	$10
			DB $5D
		ENDM

		MACRO CHECK_ITEM_MASK param1,param2
			rst	$10
			DB $61
			DB param1
			DB param2
		ENDM

		; --------------------

		MACRO debug txt
			IFDEF DEBUG_MSG
				display txt,/A,$
			ENDIF
		ENDM