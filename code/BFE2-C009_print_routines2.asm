do_print2_in_loop:
		ld	a, 0Bh

		jr	enter_loop
; -------------------------------------

print_in_loop:
		ld	a, 7		; PRINT_MESSAGE

enter_loop:
		ld	(function_to_use+1), a

loop_by_param:
		call	get_param_to_A

		cp	0FFh
		ret	z

		ld	(function_to_use+2),	a		; PARAM_TO_USE

function_to_use:
		rst	10h
		db 0Bh
		db 40h

		jr	loop_by_param
; -------------------------------------

print_crlf_msg:
		PRINT_NEWLINE

print_msg_param:
		PUSH_REGS

		ld	de, words_table
		ld	hl, messages_table

clear_prnt_param:
		xor	a
		ex	af, af'
		call	get_param_to_A

		jr	print_msg_A
