; --- create_char ---------------------------------------------
; @done
; Guild command: roll up and add a new character to the roster.
; Rejects if the roster is full, then prompts for a race (1-7)
; and rolls the six attributes (race base + random, capped at
; 18) and hit points; prompts for a class and seeds its
; class-specific fields (spell levels, rogue skills, bard songs,
; hunter chance), starting gold and spell points; finally reads a
; name, rejects a duplicate, and copies it into the slot before
; bumping the party size.
; In:  ix = new hero slot memory, iy = game vars
; Out: returns to proc_guild
create_char:
		CLEAR_INFO_PANEL

		call	is_roster_full
		jr	nc,do_create_char

		PRINT_MESSAGE2	$2E			; "The roster's full."

		PRINT_AND_WAIT

abort_race_select:
		jp	proc_guild

; -------------------------------------

do_create_char:
		CLEAN_HERO_MEMORY

		PRINT_MESSAGE2	$2C			; "Select a race for your character:"

		ld	b,$31 					; '1'

list_races:
		ld	a,b
		call	print_A_in_braces	; number inside braces
		ld	a,b
		add	a,$4F 					; get race 1-7, 80h-86h

		PRINT_WORD

		PRINT_NEWLINE

		inc	b
		ld	a,b

		cp	'8'
		jr	c,list_races

		dec	(iy+VAR_CURSOR_ROW)

		PRINT_CRLF_AND_MESSAGE	$48	; "[ext] to abort"

select_race:
		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	z,abort_race_select

		cp	'8'
		jr	nc,select_race

		sub	'1'
		jr	c,select_race

		ld	(ix+CHAR_RACE),a
		inc	a
		push	af
		ld	b,a
		ld	a,$FF

calculate_race:
		add	a,5
		djnz	calculate_race

		ld	c,a
		ld	e,4

.roll_stat:
		GET_C_FROM_TABLE	4

		ld	d,a

		GET_RND_BY_PARAM	7


		add	a,d
		cp	$13
		jr	c,.store_stat

		ld	a,$12					; maximum 18

.store_stat:
		GET_E_FROM_LIST	$48

		dec	c
		dec	e
		jp	p,.roll_stat

		GET_RND_BY_PARAM	$0F

		add	a,4
		ld	(ix+CHAR_HITS_LO),a
		ld	(ix+CHAR_COND_LO),a
		ld	(PARTY_HEADER),a

		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$2D			; "Character X"

		call	print_hero_attrib
		pop	bc
		ld	a,$F6

.class_base:
		add	a,$0A
		djnz	.class_base

		ld	b,a
		ld	e,a

		PRINT_NEWLINE

		ld	d,'0'

list_classes:
		GET_B_FROM_TABLE	$6F

		jr      z,skip_class

		ld      a,d
		call	print_A_in_braces
		inc	(iy+VAR_CURSOR_COL)
		ld	a,d
		add	a,$57					; get class, 0-9, 87h-90h

		PRINT_WORD

		PRINT_NEWLINE

skip_class:
		inc	d
		inc	b
		ld	a,d

		cp	$3A						; ':'
		jr	c,list_classes

		dec	(iy+VAR_CURSOR_ROW)

		PRINT_CRLF_AND_MESSAGE	$48	; "[ext] to abort"

select_class:
		WAIT_KEY_DOWN

		cp	CODE_ABORT
		jr	nz,calculate_class

		CLEAN_HERO_MEMORY

		jp	create_char
; -------------------------------------

calculate_class:
		sub	'0'
		jr	c,select_class

		cp	$0A
		jr	nc,select_class

		ld	(ix+CHAR_CLASS),a
		ld	d,a
		add	a,e

		GET_A_FROM_TABLE	$6F

		jr	z,select_class

		ld	a,1
		ld	(ix+CHAR_LEVEL_LO),a
		ld	(ix+CHAR_MAXLEVEL_LO),a
		dec	d
		dec	d
		dec	d
		jr	z,init_conjuror

		dec	d
		jr	z,init_magician

		dec	d
		jr	z,init_rogue

		dec	d
		jr	z,init_bard

		dec	d
		dec	d
		jr	nz,init_remaining

init_hunter:
		ld	(ix+CHAR_HUNTER_CHANCE),5
		jr	init_remaining

init_conjuror:
		ld	(ix+CHAR_CONJ_LEVEL),a
		jr	init_remaining

init_magician:
		ld	(ix+CHAR_MAGI_LEVEL),a
		jr	init_remaining

init_rogue:
		ld	a,$14						; 20
		ld	(ix+CHAR_ROGUE_DISARM),a
		ld	(ix+CHAR_ROGUE_DETECT),a
		ld	(ix+CHAR_ROGUE_HIDE),a
		jr	init_remaining

init_bard:
		ld	(ix+CHAR_BARD_SONGS),a

init_remaining:
		call	pack_hero_attrs

		GET_RND_BY_PARAM	$7F

		add	a,$46					; 70 decimal
		ld	e,a
		ld	d,0
		call	binary_to_decimal
		ld	e,$24 					; gold
		call	increas_12_digits

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_CLASS

		cp	CLASS_CONJURER
		jr	c,enter_new_name

		cp	CLASS_ROGUE
		jr	nc,enter_new_name

		GET_RND_BY_PARAM	$0F

		add	a,8
		ld	(ix+CHAR_SPPT_LO),a
		ld	(ix+CHAR_SPPT_MAX_LO),a

enter_new_name:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE2	$30			; "Enter the name of the character:"

		call	enter_text
		jr	c,free_hero_slot

		push	ix
		call	find_hero_by_name
		pop	de
		push	de
		pop	ix
		jr	nc,copy_hero_name

		PRINT_MESSAGE2	$2F			; "There's already a character of that name in the roster."

		PRINT_AND_WAIT

		jr	enter_new_name
; -------------------------------------

copy_hero_name:
		ld	bc,$0F
		ld	hl,TEXT_BUFFER
		ldir

		inc	(iy+VAR_PARTY_SIZE)

		PRINT_STATS_TABLE

		jp	proc_guild

; -------------------------------------

; --- print_A_in_braces ---------------------------------------
; @done
; Print the character in A wrapped in parentheses, e.g. "(3)",
; used to label the numbered race/class menu entries.
; In:  a = character to bracket
; Note: tail-jumps to prnt_with_codes to emit the closing ')'
print_A_in_braces:
		push	af
		ld	a,'('

		PRINT_WITH_CODES

		pop	af

		PRINT_WITH_CODES

		ld	a,')'

		jp	prnt_with_codes
