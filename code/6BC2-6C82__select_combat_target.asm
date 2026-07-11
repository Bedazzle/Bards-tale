; --- select_combat_target  (SELECT_TARGET) -------------------------
; @done
; Combat target-selection UI (dynamic proc #30). Depending on the
; selection mode in a (0..>=4) it prints the appropriate prompt --
; a single member, a member list, a group, or 'group A/B' -- then
; waits for the player to pick a party-member number or a group
; letter, or [ext] to abort.
; In:  a = target-selection mode, iy = game variables base
; Out: a = chosen target (bit 7 set = a group/letter, else member
;      index); carry set if aborted
; Note: purpose of the individual prompt modes partially inferred
select_combat_target:						; SELECT_TARGET
		PUSH_REGS

		ld	b,a
		dec	b
		jp	m,prompt_member_simple
		jr	z,prompt_member_list

		dec	b
		jr	z,check_group_target

		dec	b
		jr	z,prompt_target_group

		ld	a,(byte_FB99)
		or	a
		jr	nz,.select_group_ab

		and	a
		ld	a,$80

		ret

.select_group_ab:
		call	print_group
		ld	a,'B'

		PRINT_WITH_CODES

		PRINT_MESSAGE	$56		; "]"

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort"

loop_for_action:
		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jp	z,abort_action

		sub	'A'
		jr	c,loop_for_action

		cp	2
		jr	nc,loop_for_action

		or	$80

		ret

prompt_target_group:
		PRINT_MEMBERS_COUNT

		call	print_s_bracket

		CHECK_THREE_HEROES

		jr	c,input_after_group

		ld	a,b
		call	set_target_select

		PRINT_MESSAGE	$58			; "or"

		ld	a,b
		or	a
		jr	nz,print_group_letter

		PRINT_IN_LOOP
		DB $57,$56,$FF			; "group [A"
									; "]"

		jr	input_after_group

print_group_letter:
		call	print_group
		ld	a,(GAME_VARIABLES + VAR_TARGET_SELECT)
		dec	a

		PRINT_WITH_CODES

		PRINT_MESSAGE	$56			; "]"

input_after_group:
		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort"

		jr	read_target_input

check_group_target:
		call	clear_target_select

		CHECK_THREE_HEROES

		jr	c,auto_target_group

		ld	a,b
		or	a
		jr	nz,prompt_group_only

auto_target_group:
		ld	a,$80
		and	a

		ret

prompt_group_only:
		call	set_target_select
		call	print_group
		ld	a,(GAME_VARIABLES + VAR_TARGET_SELECT)
		dec	a

		PRINT_WITH_CODES

		PRINT_MESSAGE	$56		; "]"

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort

		jr	read_target_input

prompt_member_list:
		PRINT_MEMBERS_COUNT

		call	print_s_bracket

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort

		jr	read_target_input

prompt_member_simple:
		PRINT_MEMBERS_COUNT

		PRINT_MESSAGE	$56		; "]"

		PRINT_CRLF_AND_MESSAGE	$48			; "[ext] to abort

read_target_input:
		ld	hl,GAME_VARIABLES + VAR_MEMBER_NUM

		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	z,abort_action

		cp	'1'
		jr	c,read_target_input

		cp	(hl)
		jr	c,return_member_index

		inc	hl

		cp	(hl)
		jr	z,select_all_members

		cp	'A'
		jr	c,read_target_input

		inc	hl

		cp	(hl)
		jr	nc,read_target_input

		sub	'A'
		or	$80

		ret

select_all_members:
		ld	a,'0'

return_member_index:
		sub	'0'

		ret

abort_action:
		scf

		ret
