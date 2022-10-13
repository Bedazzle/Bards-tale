print_msg_param_2:
		PUSH_REGS

		ld	de, messages_texts_2
		ld	hl, messages_table_2

		jp	clear_prnt_param

; -------------------------------------

print2_flag_0:
		ex	af, af'
		xor	a

		jr	flip_and_print

print2_flag_1:
		ex	af, af'
		ld	a, 1

flip_and_print:
		ex	af, af'

		PUSH_REGS

		ld	de, messages_texts_2
		ld	hl, messages_table_2

		jp	print_msg_A
