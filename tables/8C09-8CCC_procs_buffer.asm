procs_buffer:
		dw get_attr_by_param_save_IX ; 00 (one param)
		dw show_pic_by_A				; - 01 (no param)
		dw show_pic_by_param			; - 02 (one param)
		dw show_name_pic_AB				; - 03 (no param)
		dw show_name_and_pic			; - 04 (two params)
		dw print_2newlines				; - 05 (no param)
		dw zero_buffers					; - 06 (no param)
		dw print_msg_param				; - 07 (one param)
		dw print_crlf_msg				; - 08 (one param)
		dw reset_col					; - 09 (no param)
		dw reset_row_col				; - 0A (no param)
		dw print_msg_param_2			; - 0B (one param)
		dw do_print2_in_loop			; - 0C (variable list, FF	terminated)
		dw print_in_loop				; - 0D (variable list, FF	terminated)
		dw print2_flag_0				; - 0E (no param)
		dw print2_flag_1				; - 0F (no param)
		dw print_item_name				; - 10 (no param)
		dw print_word					; - 11 (no param)
		dw clean_hero_memory			; - 12 (no param)
		dw print_IX_heroname			; - 13 (no param)
		dw print_empty					; - 14 (no param)
		dw find_hero_by_B				; - 15 (no param)
		dw find_hero_by_A				; - 16 (no param)
		dw get_attr_by_param			; - 17 (one param)
		dw get_attr_by_param_save_HL	; - 18 (one param)
		dw get_game_variable			; - 19 (one param)
		dw find_attr_and_address		; - 1A (one param)
		dw get_B_from_list				; - 1B (one param)
		dw get_C_from_list				; - 1C (one param)
		dw get_E_from_list				; - 1D (one param)
		dw prnt_with_codes				; - 1E (no param)
		dw print_digit					; - 1F (no param)
		dw prnt_next_digit				; - 20 (no param)
		dw clear_info_panl				; - 21 (no param)
		dw print_who_will				; - 22 (no param)
		dw wait_key_down				; - 23 (no param)
		dw print_and_wait				; - 24 (no param)
		dw get_rnd_numbers				; - 25 (no param)
		dw print_num_from_DE			; - 26 (no param)
		dw print_num_from_E				; - 27 (no param)
		dw check_hero_status			; - 28 (no param)
		dw dyn_proc_54		; 29 (no param)
		dw dyn_proc_55		; 2A (no param)
		dw print_yesno_wait				; - 2B (no param)
		dw yesno_wait					; - 2C (no param)
		dw print_stats_table			; - 2D (no param)
		dw dyn_proc_59		; 2E (no param)
		dw dyn_proc_60		; 2F (no param)
		dw dyn_proc_61		; 30 (no param)
		dw show_icon					; 31 (one param)
		dw calc_in_FB7D		; 32 (no param)
		dw change_speed					; - 33 (one param)
		dw change_speed_8				; - 34 (no param)
		dw print_space					; - 35 (no param)
		dw print_newline				; - 36 (no param)
		dw prnt_space_line				; - 37 clear 15	hor cells (no param)
		dw push_regs					; - 38 (no param)
		dw get_A_from_table				; - 39 (one param)
		dw get_B_from_table				; 3A (one param)
		dw get_C_from_table				; - 3B (one param)
		dw get_D_from_table				; 3C (one param)
		dw get_E_from_table				; 3D (one param)
		dw get_H_from_table				; 3E (one param)
		dw get_L_from_table				; 3F (one param)
		dw get_IY_A_from_table			; 40 (two params)
		dw convert_12_digits			; 41 (no param)
		dw dyn_proc_74		; 42
		dw check_equipped				; 43 (one param)
		dw get_attr_by_A				; - 44 (no param)
		dw dyn_proc_76		; 45 (no param)
		dw add_rnd_number				; 46 (no param)
		dw a_plus_c_to_hl				; - 47 (no param)
		dw dyn_proc_79		; 48 (no param)
		dw dyn_proc_80		; 49 (no param)
		dw dyn_proc_07		; 4A (no param)
		dw dyn_proc_81		; 4B (no param)
		dw enter_1_to_8					; - 4C (no param)
		dw enter_1_to_6					; - 4D (no param)
		dw choose_hero					; - 4E (no param)
		dw clean_ally_memory			; - 4F (no param)
		dw find_inn						; - 50 (one param)
		dw dyn_proc_87		; 51 (no param)
		dw print_loc_name				; - 52 (no param)
		dw dyn_proc_89		; 53 (no param)
		dw show_damage					; 54 (no param)
		dw attack_and_result			; - 55 (no param)
		dw print_memb_num				; - 56 (no param)
		dw calc_in_FD7A		; 57 (no param)
		dw clear_txt_buffer				; 58 (no param)
		dw print_letter_pair			; 59 (no param)
		dw print_hero_attr				; - 5A (no param)
		dw nullify_FB5B					; - 5B (no param)
		dw dyn_proc_94		; 5C (no param)
		dw dyn_proc_95		; 5D (no param)
		dw exec_for_heroes				; - 5E (two params = address)
		dw if_FB98_is_zero	; - 5F (no param)
		dw get_rnd_by_param				; - 60 (one param)
		dw dyn_proc_08		; 61 (two params)