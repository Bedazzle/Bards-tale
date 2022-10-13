		; procs_buffer

		MACRO SHOW_PIC_BY_A
			rst	10h
			db 1			; show_pic_by_A
		ENDM

		MACRO SHOW_PIC_BY_PARAM param
			rst	10h
			db 2			; show_pic_by_param
			db param
		ENDM

		MACRO SHOW_NAME_PIC_AB
			rst	10h
			db 3			; show_name_pic_AB
		ENDM

		MACRO SHOW_NAME_AND_PICTURE object, picture
			rst	10h
			db 4			; show_name_and_pic
			db object
			db picture
		ENDM

		MACRO PRINT_2_NEWLINES
			rst	10h
			db 5			; print_2newlines
		ENDM

		MACRO ZERO_BUFFERS
			rst	10h
			db 6			; zero_buffers
		ENDM

		MACRO PRINT_MESSAGE param
			rst	10h
			db 7			; print_msg
			db param
		ENDM

		MACRO PRINT_CRLF_AND_MESSAGE param
			rst	10h
			db 8			; print_crlf_msg
			db param
		ENDM

		MACRO RESET_COL
			rst	10h
			db 9			; reset_col
		ENDM

		MACRO RESET_ROW_COL
			rst	10h
			db 0Ah			; reset_row_col
		ENDM

		MACRO PRINT_MESSAGE2 param	; set/clear AF' flag ??? capitalize ???
			rst	10h
			db 0Bh			; print_msg_param_2
			db param
		ENDM

		MACRO PRINT2_IN_LOOP
			rst	10h
			db 0Ch			; print2_in_loop
		ENDM

		MACRO PRINT_IN_LOOP
			rst	10h
			db 0Dh			; print_in_loop
		ENDM

		MACRO PRINT2_A_WITH_FLAG_0
			rst	10h
			db 0Eh			; print2_flag_0
		ENDM

		MACRO PRINT2_A_WITH_FLAG_1
			rst	10h
			db 0Fh			; print2_flag_1
		ENDM

		MACRO PRINT_ITEM_NAME
			rst	10h
			db 10h			; print_item_name
		ENDM

		MACRO PRINT_WORD
			rst	10h
			db 11h			; print_word
		ENDM

		MACRO CLEAN_HERO_MEMORY
			rst	10h
			db 12h			; clean_hero_memory
		ENDM

		MACRO PRINT_IX_HERO_NAME
			rst	10h
			db 13h			; print_IX_heroname
		ENDM

		MACRO PRINT_EMPTY
			rst	10h
			db 14h			; print_empty
		ENDM

		MACRO FIND_HERO_BY_B
			rst	10h
			db 15h			; find_hero_by_B
		ENDM

		MACRO FIND_HERO_BY_A
			rst	10h
			db 16h			; find_hero_by_A
		ENDM

		MACRO GET_ATTR_BY_PARAM param
			rst	10h
			db 17h			; get_attr_by_param
			db param
		ENDM

		MACRO GET_ATTR_BY_PARAM_SAVE_HL param
			rst	10h
			db 18h			; get_attr_by_param_save_HL
			db param
		ENDM

		MACRO GET_GAME_VARIABLE param
			rst	10h
			db 19h			; get_game_variable
			db param
		ENDM

		MACRO GET_B_FROM_LIST param
			rst	10h
			db 1Bh			; get_B_from_list
			db param
		ENDM

		MACRO GET_C_FROM_LIST param
			rst	10h
			db 1Ch			; get_C_from_list
			db param
		ENDM

		MACRO GET_E_FROM_LIST param
			rst	10h
			db 1Dh			; get_E_from_list
			db param
		ENDM

		MACRO PRINT_WITH_CODES
			rst	10h
			db 1Eh			; prnt_with_codes
		ENDM

		MACRO PRINT_DIGIT
			rst	10h
			db 1Fh			; print_digit
		ENDM

		MACRO PRINT_NEXT_DIGIT
			rst	10h
			db 20h			; prnt_next_digit
		ENDM

		MACRO CLEAR_INFO_PANEL
			rst	10h
			db 21h			; clear	info panel
		ENDM

		MACRO PRINT_WHO_WILL
			rst	10h
			db 22h			; print_who_will
		ENDM

		MACRO WAIT_KEY_DOWN
			rst	10h
			db 23h			; wait_key_down
		ENDM

		MACRO PRINT_AND_WAIT
			rst	10h
			db 24h			; print_and_wait
		ENDM

		MACRO GET_RND_NUMBERS
			rst	10h
			db 25h			; get_rnd_numbers
		ENDM

		MACRO PRINT_NUM_FROM_DE
			rst	10h
			db 26h			; print_num_from_DE
		ENDM

		MACRO PRINT_NUM_FROM_E
			rst	10h
			db 27h			; print_num_from_E
		ENDM

		MACRO CHECK_HERO_STATUS
			rst	10h
			db 28h			; check_hero_status

			; Z is set if OK
			; C is set if OK
		ENDM

		MACRO PRINT_YES_NO_WAIT
			rst	10h
			db 2Bh			; print_yesno_wait
		ENDM

		MACRO PRINT_STATS_TABLE
			rst	10h
			db 2Dh			; print_stats_table
		ENDM

		MACRO SHOW_ICON param
			rst	10h
			db 31h			; show_icon
			db param
		ENDM

		MACRO CALC_IN_FB7D
			rst	10h
			db 32h			; calc_in_FB7D
		ENDM

		MACRO CHANGE_SPEED param
			rst	10h
			db 33h			; change_speed
			db param
		ENDM

		MACRO CHANGE_SPEED_TO_8
			rst	10h
			db 34h			; change_speed_8
		ENDM

		MACRO PRINT_SPACE
			rst	10h
			db 35h			; print_space
		ENDM

		MACRO PRINT_NEWLINE
			rst	10h
			db 36h			; print_newline
		ENDM

		MACRO PRINT_SPACE_LINE
			rst	10h			; --clear 15 horizontal	cells--
			db 37h			; prnt_space_line
		ENDM

		MACRO PUSH_REGS
			rst	10h
			db 38h			; push_regs
		ENDM

		MACRO GET_A_FROM_TABLE param
			rst	10h
			db 39h			; get_A_from_table
			db param
		ENDM

		MACRO GET_B_FROM_TABLE param
			rst	10h
			db 3Ah			; get_B_from_table
			db param
		ENDM

		MACRO GET_C_FROM_TABLE param
			rst	10h
			db 3Bh			; get_C_from_table
			db param
		ENDM

		MACRO GET_D_FROM_TABLE param
			rst	10h
			db 3Ch			; get_D_from_table
			db param
		ENDM

		MACRO GET_E_FROM_TABLE param
			rst	10h
			db 3Dh			; get_E_from_table
			db param
		ENDM

		MACRO GET_H_FROM_TABLE param
			rst	10h
			db 3Eh			; get_H_from_table
			db param
		ENDM

		MACRO GET_L_FROM_TABLE param
			rst	10h
			db 3Fh			; get_L_from_table
			db param
		ENDM

		MACRO GET_IY_A_FROM_TABLE param1, param2
			rst	10h
			db 40h			; get_IY_A_from_table
			db param1
			db param2
		ENDM

		MACRO CONVERT_12_DIGITS
			rst	10h
			db 41h			; convert_12_digits
		ENDM

		MACRO CHECK_EQUIPPED param
			rst	10h
			db 43h			; check_equipped
			db param
		ENDM

		MACRO GET_ATTR_BY_A
			rst	10h
			db 44h			; get_attr_by_A
		ENDM

		MACRO ADD_RND_NUMBER
			rst	10h
			db 46h			; add_rnd_number
		ENDM

		MACRO A_PLUS_C_TO_HL
			rst	10h
			db 47h			; a_plus_c_to_hl
		ENDM

		MACRO ENTER_1_TO_8
			rst	10h
			db 4Ch			; enter_1_to_8
		ENDM

		MACRO CHOOSE_HERO
			rst	10h
			db 4Eh			; choose_hero
		ENDM

		MACRO ENTER_1_TO_6
			rst	10h
			db 4Dh			; enter_1_to_6
		ENDM

		MACRO CLEAN_ALLY_MEMORY
			rst	10h
			db 4Fh			; clean_ally_memory
		ENDM

		MACRO FIND_INN param
			rst	10h
			db 50h			; find_inn
			db param
		ENDM

		MACRO PRINT_LOCATION_NAME
			rst	10h
			db 52h			; print_loc_name
		ENDM

		MACRO SHOW_DAMAGE
			rst	10h
			db 54h			; show_damage
		ENDM

		MACRO ATTACK_AND_RESULT
			rst	10h
			db 55h			; attack_and_result
		ENDM

		MACRO PRINT_MEMBERS_COUNT
			rst	10h
			db 56h			; print_memb_num
		ENDM

		MACRO CLEAR_TXT_BUFFER
			rst	10h
			db 58h			; clear_txt_buffer
		ENDM

		MACRO PRINT_LETTER_PAIR
			rst	10h
			db 59h			; print_letter_pair
		ENDM

		MACRO PRINT_HERO_ATTR
			rst	10h
			db 5Ah			; print_hero_attr
		ENDM

		MACRO NULLIFY_FB5B
			rst	10h
			db 5Bh			; nullify_FB5B
		ENDM

		MACRO EXEC_FOR_HEROES param
			rst	10h
			db 5Eh			; exec_for_heroes
			dw param
		ENDM

		MACRO IF_FB98_IS_ZERO
			rst	10h
			db 5Fh			; if_FB98_is_zero
		ENDM

		MACRO GET_RND_BY_PARAM param
			rst	10h
			db 60h			; get_rnd_by_param
			db param
		ENDM


		; ---------------------------


		MACRO RST_10_00 param
			rst	10h
			db 0
			db param
		ENDM

		MACRO FIND_ATTR_AND_ADDRESS param
			rst	10h
			db 1Ah			; find_attr_and_address
			db param
		ENDM

		MACRO RST_10_29
			rst	10h
			db 29h
		ENDM

		MACRO RST_10_2A
			rst	10h
			db 2Ah
		ENDM

		MACRO RST_10_2E
			rst	10h
			db 2Eh
		ENDM

		MACRO RST_10_2F
			rst	10h
			db 2Fh
		ENDM

		MACRO RST_10_30
			rst	10h
			db 30h
		ENDM

		MACRO RST_10_42
			rst	10h
			db 42h
		ENDM

		MACRO RST_10_45
			rst	10h
			db 45h
		ENDM

		MACRO RST_10_48
			rst	10h
			db 48h
		ENDM

		MACRO RST_10_49
			rst	10h
			db 49h
		ENDM

		MACRO RST_10_4A
			rst	10h
			db 4Ah
		ENDM

		MACRO RST_10_4B
			rst	10h
			db 4Bh
		ENDM

		MACRO RST_10_51
			rst	10h
			db 51h
		ENDM

		MACRO RST_10_53
			rst	10h
			db 53h
		ENDM

		MACRO RST_10_57
			rst	10h
			db 57h
		ENDM

		MACRO RST_10_5C
			rst	10h
			db 5Ch
		ENDM

		MACRO RST_10_5D
			rst	10h
			db 5Dh
		ENDM

		MACRO RST_10_61 param1, param2
			rst	10h
			db 61h
			db param1
			db param2
		ENDM

		; --------------------

		MACRO debug txt
			IFDEF DEBUG_MSG
				display txt, /A, $
			ENDIF
		ENDM