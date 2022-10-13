		di

;loop_iter:
;		rst	10h
;		db 21h			; clear	info panel
;
;		ld a, (param+2)
;		inc a
;		ld (param+2), a
;
;		ld e, a
;		PRINT_NUM_FROM_E
;
;		and %111
;		out (254), a
;
;		ld a, 0Dh
;		call print_newline
;
;param:
;		rst	10h
;		db 7	; print print_msg  , 0-255
;		;db 0Bh	; print_msg_param_2	, 0-145
;		;db 02h	; show_pic_by_param , 0-27
;		;db 50h	; find_inn , 0-22
;		db 0-1
;
;;param:
;;		ld a, 0-1
;;
;;		;ld	de, messages_texts_2
;;		;ld	hl, messages_table_2
;;
;;		ld	de, words_table
;;		ld	hl, messages_table
;;
;;		call print_msg_A
;
;		call wait_space_down
;
;		jr	loop_iter

;loop_iter:
;		call wait_space_down
;
;		ld a, (param+2)
;		inc a
;		ld (param+2), a
;
;param:
;		rst	10h
;		db 50h	; find_inn , 0-22
;		db 0-1
;
;		jr	loop_iter



;loop_iter:
;		call wait_space_down
;
;		;rst	10h
;		;db 21h			; clear	info panel
;
;		ld a, (param)
;		inc a
;		ld (param), a
;
;		;ld e, a
;		;PRINT_NUM_FROM_E
;
;		ld a, (param)
;		ld	de, INDEX_ITEM_NAMES	; 0A23Fh	; items
;		ld	hl, INDEX_ITEM_LENGTHS	; 09B95h	; items
;		;scf
;		call	print_msg_no_cp
;
;		;ld	de, 0A5ECh	; monsters
;		;ld	hl, 09C20h	; monsters
;		;
;		;call	print_msg_no_cp
;
;		;call print_item_name
;
;		;call print_word
;
;		jr	loop_iter
;
;param:
;		db 0-1

;		ld hl, 16384
;		ld de, 16385
;		ld bc, 6911
;		ld a, 1
;		ld (hl), a
;		ldir
;
;		ld	iy, 5FABh
;		ld	hl, 5FB2h + 6Fh		;6021h
;		ld	b, 6Fh
;		call	nullify_buffer
;		xor	a
;		ld	(iy+VAR_58), 5
;
;		ld	sp, 0FFFFh
;		ld	iy, 5FABh		; game variables
;		ld	(iy+VAR_48), 18h
;		ld	(iy+VAR_PAUSE), 0
;		ld	(iy+VAR_INFO_COL_POS), 15h
;
;		ZERO_BUFFERS
;
;		;call dyn_proc_07
;		call print_stats_table
;
;		call wait_space_down
;		jp 0
;


;loop_iter:
;		rst	10h
;		db 21h			; clear	info panel
;
;		ld a, (param+2)
;		inc a
;		ld (param+2), a
;
;		ld e, a
;		PRINT_NUM_FROM_E
;
;		and %111
;		out (254), a
;
;
;		ld a, 0Dh
;		call print_newline
;
;		ld a, (param+2)
;		ld e, a
;param:
;		rst	10h
;		db 3Dh
;		db 0-1
;
;		and	0Fh
;		or	80h
;
;		PRINT_ITEM_NAME
;
;		call wait_space_down
;
;		jr	loop_iter

; 11: 34241 85C1 (D7,3D,42,D9,34)	Wand
; 12: 58544 E4B0 (D7,3D,16,28,F7)	Item
; 13: 58552 E4B8 (D7,3D,13,D5,1E)	Gloves
; 14: 58664 E528 (D7,3D,6B,E6,0F)	Item
; 15: 58678 E536 (D7,3D,13,CD,B0)
; 16: 59310 E7AE (D7,3D,11,32,90)
; 17: 59316 E7B4 (D7,3D,10,FD,BE)
; 18: 59422 E81E (D7,3D,10,FD,BE)
; 19: 59438 E82E (D7,3D,11,F5,FE)
; 20: 59952 EA30 (D7,3D,48,FE,12)
; 21: 60057 EA99 (D7,3D,0C,1E,24)

;loop_iter:
;		ld	b, 92h
;		ld	a, 19h
;
;		SHOW_NAME_PIC_AB
;		jr loop_iter

;;		;ld	de, messages_texts_2
;;		;ld	hl, messages_table_2
;;
;		call print_N_enemies
;		call wait_space_down


		CLEAR_INFO_PANEL

		ld	b, 31h 	; '1'

;loop_iter:
;		ld	a, b
;		call	print_A_in_braces	; number inside braces
;		ld	a, b
;		add	a, 4Fh 					; get race
;
;		push af
;		ld e, a
;		PRINT_NUM_FROM_E
;		pop af
;
;		PRINT_WORD
;
;		PRINT_NEWLINE
;
;		inc	b
;
;		cp	38h 	; '8'
;		jp	nc, 0
;
;		push bc
;		call wait_space_down
;		pop bc
;
;		jr loop_iter

;;		ld b, 0A4h
;;		ld b, 0B6h
;;loop_iter:
;;		ld	a, b
;;
;;		push af
;;		ld e, a
;;		PRINT_NUM_FROM_E
;;		pop af
;;
;;		PRINT_WORD
;;
;;		PRINT_NEWLINE
;;
;;		inc	b
;;
;;		push bc
;;		call wait_space_down
;;		pop bc
;;
;;		jr loop_iter

;loop_iter:
;		rst	10h
;		db 21h			; clear	info panel
;		call wait_space_down
;
;		display $
;		ld	a, 0B6h
;
;		PRINT_WORD
;
;		display $
;
;		call wait_space_down
;
;		jr	loop_iter

;;loop_iter:
;;		rst	10h
;;		db 21h			; clear	info panel
;;
;;		call wait_space_down
;;
;;		display $
;;
;;		ld a, 0
;;
;;		ld	de, 0A5ECh	; monsters
;;		ld	hl, 09C20h	; monsters
;;		
;;		call	print_msg_no_cp
;;
;;		display $
;;
;;		call wait_space_down
;;
;;		jr	loop_iter

looper:
		ld	de, 32h			; duration
		ld	hl, 15h			; pitch

		;ld	de, 2		; duration
		;ld	hl, 1		; pitch
		call	ROM_BEEPER
		jr looper

		include "hack_tools.asm"	; FC38-FCE1_partial_font.asm
