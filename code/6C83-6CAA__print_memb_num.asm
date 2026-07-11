; --- print_memb_num ---------------------------------------
; @done
; Print the 'member [1-N]' party-member prompt: count the active
; heroes, store the top index ('1'+count) in VAR_MEMBER_NUM and
; print the range digit.
; In:  iy = game variables base
; Out: prompt printed; VAR_MEMBER_NUM = highest selectable digit
print_memb_num:
		PUSH_REGS

		call	clear_target_select

		PRINT_MESSAGE	$54			; "member   [1-"

		call	count_heroes
		push	af
		add	a,'1'
		ld	(GAME_VARIABLES + VAR_MEMBER_NUM),a
		pop	af

		PRINT_DIGIT

		ret
; -------------------------------------

; --- print_s_bracket --------------------------------------
; @done
; Close a party-member prompt with the correct bracket: if more
; than one hero is active print 'S]' and set the plural flag,
; otherwise fall through to print a plain ']'.
; In:  iy = game variables base
; Out: closing bracket printed; VAR_PLURAL_FLAG = 'S' if plural
print_s_bracket:
		PUSH_REGS

		call	count_heroes
		jr	nc,print_r_bracket

		ld	(iy+VAR_PLURAL_FLAG),'S'

		PRINT_MESSAGE	$38			; "S]"

		ret
; -------------------------------------

print_r_bracket:
		PRINT_MESSAGE	$56			; "]"

		ret
