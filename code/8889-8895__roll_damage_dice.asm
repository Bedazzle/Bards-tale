; --- roll_damage_dice ---------------------------------------
; @done
; Core damage randomiser: roll B four-sided dice and add the total
; to HL. Each die yields 1..4 (a random 0..3, +1).
; In:  b = number of dice, hl = running total
; Out: hl = hl + sum of B d4 rolls
roll_damage_dice:				; ROLL_DAMAGE
		push	de

.init:
		ld	d,0			; de high byte = 0 for the add

.roll:
		GET_RND_BY_PARAM	3		; a = 0..3

.accumulate:
		ld	e,a
		inc	e			; die value 1..4
		add	hl,de
		djnz	.roll

		pop	de

		ret
