; --- copy_hero_money ----------------------------------------
; @done
; Copies a hero's 12-digit BCD gold field into the scratch buffer
; (LEVEL_STOP+$A), most-significant digit downward.
; In:  ix -> hero record
copy_hero_money:
		PUSH_REGS

		ld	hl,LEVEL_STOP+$A

; --- copy_12_digits -----------------------------------------
; @done
; Shared tail: copies 12 consecutive BCD digits from (ix+CHAR_GOLD_
; END) downward into the buffer at hl. Reused for gold and
; experience copies in either direction.
; In:  hl -> destination (high byte), ix -> source base
copy_12_digits:
		ld	b,CHAR_GOLD_END - CHAR_GOLD_START +1

loop_copy_money:
		ld	a,(ix+CHAR_GOLD_END)
		ld	(hl),a
		dec	hl
		dec	ix
		djnz	loop_copy_money

		ret

; --- copy_hero_gold -----------------------------------------------
; @done
; Writes the 12-digit number in SCRATCH_BUFFER+$91 into the hero's experience
; field (via copy_12_digits).
; In:  ix = hero record
copy_hero_gold:
		PUSH_REGS

		FIND_ATTR_AND_ADDRESS	CHAR_EXP_END

		ld	ix,SCRATCH_BUFFER+$91

		jr	copy_12_digits
