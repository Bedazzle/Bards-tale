; --- print_msg_cellars -------------------------------------
; @done
; This level's text-decoder clone (3 entries), hard-wired to the level's text pool.
; print_msg_cellars: clear the info panel + print message A. print_cellars_flag0/1:
; set the AF' capitalise flag (0/1) then print. Jump to the shared printers.
print_msg_cellars:
		PUSH_REGS
		ld	de,MESSAGES_TEXTS
		ld	hl,MESSAGES_TABLE
		jp	clear_prnt_param

print_cellars_flag0:
		ex	af,af'
		xor	a
		jr	flip_and_print

print_cellars_flag1:
		ex	af,af'
		ld	a,1
flip_and_print:
		ex	af,af'
		PUSH_REGS
		ld	de,MESSAGES_TEXTS
		ld	hl,MESSAGES_TABLE
		jp	print_msg_A
