; --- do_print2_in_loop ------------------------------------
; @done
; Print a $FF-terminated list of message ids taken from the parameter
; stream, using the print_msg_param_2 handler (id $0B, the capitalising
; variant). Patches the SMC dispatch id then loops (enter_loop).
do_print2_in_loop:
		ld	a,$0B

		jr	enter_loop
; -------------------------------------

; --- print_in_loop ----------------------------------------
; @done
; Print a $FF-terminated list of message ids from the parameter stream,
; using the plain print_msg handler (id 7). Shares the enter_loop body
; with do_print2_in_loop.
print_in_loop:
		ld	a,7		; PRINT_MESSAGE

enter_loop:
		ld	(function_to_use+1),a

loop_by_param:
		call	get_param_to_A

		cp	$FF
		ret	z

		ld	(function_to_use+2),a		; PARAM_TO_USE

function_to_use:
		rst	$10
		DB $0B
		DB $40

		jr	loop_by_param
; -------------------------------------

; --- print_crlf_msg ---------------------------------------
; @done
; Emit a newline, then print the message whose id is the next parameter
; (falls into print_msg_param).
print_crlf_msg:
		PRINT_NEWLINE

; --- print_msg_param --------------------------------------
; @done
; Print the message whose id is the next parameter. Sets up the words
; and messages table pointers, clears the AF' capitalise flag, fetches
; the id, and hands off to the packed-text decoder (print_msg_A).
print_msg_param:
		PUSH_REGS

		ld	de,words_table
		ld	hl,messages_table

clear_prnt_param:
		xor	a
		ex	af,af'
		call	get_param_to_A

		jr	print_msg_A
