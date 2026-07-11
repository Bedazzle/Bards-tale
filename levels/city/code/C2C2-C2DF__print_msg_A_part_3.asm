; --- print_msg_param_2 -------------------------------------
; @done
; Print one of the City's numbered messages. Loads this level's text
; pool-2 pointers (messages_texts_2 / messages_table_2) and tail-calls
; the shared decoder, which reads the message index from the byte that
; follows the RST 10h,$0B call.
; In:  message-index byte follows the PRINT_MESSAGE2 call (0-145)
print_msg_param_2:
		PUSH_REGS

		ld	de,messages_texts_2
		ld	hl,messages_table_2

		jp	clear_prnt_param

; -------------------------------------

; --- print2_flag_0 -----------------------------------------
; @done
; Print message A with the leading-capital flag CLEARED. Stashes a=0 in
; AF' (the decoder's capitalise flag) via flip_and_print, then prints
; through the City's pool-2 pointers.
print2_flag_0:
		ex	af,af'
		xor	a

		jr	flip_and_print

; --- print2_flag_1 -----------------------------------------
; @done
; Print message A with the leading-capital flag SET. Stashes a=1 in AF'
; (the decoder's capitalise flag) via flip_and_print, then prints
; through the City's pool-2 pointers.
print2_flag_1:
		ex	af,af'
		ld	a,1

flip_and_print:
		ex	af,af'

		PUSH_REGS

		ld	de,messages_texts_2
		ld	hl,messages_table_2

		jp	print_msg_A
