; --- combat_flee_check (party flee check driver) ---------------------
; @done
; Decides whether the party can break away from the enemy. Runs the
; flee resolution (CHECK_FLEE_RESULT) once per enemy group present
; (target id 1, and 2 as well when a second group EL_CID+1 is active),
; returning carry as soon as any group blocks the escape.
; In:  iy = game variables base
; Out: carry set = flee blocked by an enemy group; a=0 / NC = clear
combat_flee_check:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc,check_flee_result

		ld	(iy+VAR_TARGET_ID),1

		CHECK_FLEE_RESULT

		ret	c

		ld	a,(EL_CID+1)
		or	a
		jr	z,.all_failed

		inc	(iy+VAR_TARGET_ID)

		CHECK_FLEE_RESULT

		ret	c

.all_failed:
		xor	a

		ret
; -------------------------------------

; --- check_flee_result (check_flee_result / dispatch $2A) ---------
; @done
; Resolves one flee attempt of the party against the current enemy
; group. Computes a speed/agility rating for each side (calc_flee_speed
; for the party, calc_defense_rating for the enemy - the order swapped
; per VAR_ACTIVE_HERO), both jittered by the RNG, then compares them
; with a small bonus margin to decide the outcome.
; In:  VAR_TARGET_ID = enemy group, iy = game variables base
; Out: a = 1 flee succeeds / 0 fails; carry set on the early block case
; Note: exact comparison margin math partially inferred.
check_flee_result:							; CHECK_FLEE_RESULT
		GET_RND_NUMBERS

		PUSH_REGS

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc,.swap_sides

		call	calc_flee_speed
		ld	l,a
		ld	a,(iy+VAR_TARGET_ID)
		push	hl
		call	calc_defense_rating

		jr	.compare

.swap_sides:
		call	calc_defense_rating
		ld	l,a
		ld	a,(iy+VAR_TARGET_ID)
		push	hl
		call	calc_flee_speed

.compare:
		pop	hl

		cp	l
		ret	c

		sub	4
		jr	nc,.after_bonus

		xor	a

.after_bonus:
		cp	l
		jr	nc,.no_flee

		ld	a,1
		or	a

		ret

.no_flee:
		xor	a

		ret

; --- calc_flee_speed ----------------------------------------
; @done
; Returns the party's flee/speed rating for the flee comparison. Looks
; up a base value for the active hero from table $41 (defaulting to $20
; when none), divides it by 8, and adds a 0-7 random jitter from the
; RNG high byte.
; In:  a = hero/attack descriptor, iy = game variables base
; Out: a = flee speed rating
calc_flee_speed:
		and	$7F

		GET_A_FROM_TABLE	$41

		jr	nz,.have_val
		ld	a,$20 ; ' '

.have_val:
		call	divide_A_by_8
		ld	c,a
		ld	a,(GAME_VARIABLES + VAR_RND_HI)
		and	7
		add	a,c

		ret
