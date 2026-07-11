; --- spell_breath_attack --------------------------------------
; @done
; Resolve a breath / area-effect attack spell (dragon breath, arc
; fire, incinerate, ...). Walks over the chosen target set - either
; the whole party (6 slots) or a monster group - rolling damage
; against each live target, printing the "breathes at ... is <hurt>
; for N" combat messages and honouring flee / spell-repelled
; results. Groups are advanced until the terminator id ($84) or an
; exhausted breath value is reached.
; In:  iy = game variables base; VAR_ACTIVE_HERO / VAR_TARGET_ID
;      select attacker side and initial target
; Out: damage applied to targets; VAR_BREATH_VALUE cleared on exit
; Note: the per-target loop end value is self-modifying code -
;       breath_target_loop.target_stop+1 is patched to 0 (stop at
;       one) or $FF (whole party).
spell_breath_attack:
		xor     a
		ld      (GAME_VARIABLES + VAR_BREATH_COUNT),a
		ld      (breath_target_loop.target_stop+1),a	; SMC: loop terminator = 0
		inc     a
		ld      (GAME_VARIABLES + VAR_BREATH_VALUE),a
		ld      (iy+VAR_TARGET_ID),$80
		jr      breath_target_loop

; --- breath_message -------------------------------------------------
; @done
; Monster-breath entry point (called from combat_foes). Prints
; "breathes" then falls into the shared targeting loop with the
; breath value reset to 0 - i.e. resolves a breath attack without
; the spell-cast setup that spell_breath_attack does above.
; In:  iy = game variables base; VAR_TARGET_ID selects the target
; Note: purpose partially inferred.
breath_message:
		PRINT_MESSAGE	$73			; "breathes"

breath_attack_run:
		xor	a
		ld	(GAME_VARIABLES + VAR_BREATH_VALUE),a
		ld	(breath_target_loop.target_stop+1),a	; SMC: loop terminator = 0

breath_target_loop:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	nz,.check_party_target

		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		jr	c,.target_group

		jr	.target_party
; -------------------------------------

.check_party_target:
		jr	nc,.target_group

		ld	a,$FF				; whole party targeted
		ld	(.target_stop+1),a		; SMC: loop terminator = $FF (all 6)

.target_party:
		ld	e,6

		PRINT_MESSAGE	$66			; "at the party..."

		jr	.hit_loop
; -------------------------------------

.target_group:
		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		and	$7F

		GET_A_FROM_TABLE	$36

		jr	nz,.target_named

		GET_GAME_VARIABLE	VAR_BREATH_VALUE		; ???

		jp	z,print_ellipsis

		jp	.next_group
; -------------------------------------

.target_named:
		ld	e,a
		inc	(iy+VAR_BREATH_COUNT)

		PRINT_MESSAGE	$65			; "at"

		ld	a,e

		cp	2
		jr	nc,.target_some

		PRINT_ACTOR_NAME

		PRINT_MESSAGE	$86			; "..."

		jr	.hit_loop
; -------------------------------------

.target_some:
		PRINT_MESSAGE	$67			; "some"

		ld	(iy+VAR_DISPLAY_COUNT),1
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		and	$7F

		GET_A_FROM_TABLE	$41

		PRINT_WORD

		PRINT_MESSAGE	$86			; "..."

.hit_loop:
		call	get_hero_class
		ld	b,a

		RESET_DAMAGE

		ROLL_DAMAGE

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c,.hit_hero

		jr	nz,.hit_one

		bit	7,(iy+VAR_TARGET_ID)
		jr	nz,.hit_monster

.hit_hero:
		ld	b,e

		FIND_HERO_BY_B

		jr	z,.next_target

		CHECK_HERO_STATUS

		jr	nc,.next_target

		PRINT_IX_HERO_NAME

		ld	(iy+VAR_TARGET_ID),e

		jr	.resolve_hit
; -------------------------------------

.hit_monster:
		PRINT_ACTOR_NAME

.resolve_hit:
		CHECK_FLEE_RESULT

		jr	c,.apply_damage

		jr	z,.repelled

		srl	h
		rr	l

		jr	.apply_damage
; -------------------------------------

.repelled:
		PRINT_IN_LOOP
		DB $68,$47,$FF			; "repelled the"
									; "spell!"

		PRINT_NEWLINE

		CHANGE_COMBAT_SPEED

		jr	.next_target
; -------------------------------------

.hit_one:
		PRINT_MESSAGE	$2B			; "One"

		jr	.resolve_hit
; -------------------------------------

.apply_damage:
		PRINT_MESSAGE	$82			; "is"

		call	get_top3_bits
		add	a,$B3

		PRINT_WORD

		PRINT_MESSAGE	$81			; "for"

		SHOW_DAMAGE

		jr	c,.slain

		PRINT_MESSAGE	$63			; ===empty message===

		jr	.after_damage
; -------------------------------------

.slain:
		ld	a,$A4

		PRINT_WORD

		PRINT_MESSAGE	$62			; "him!"

.after_damage:
		CHANGE_COMBAT_SPEED

.next_target:
		dec	e
		ld	a,e

.target_stop:
		cp	0				; !!! SMC operand patched to 0 or $FF
		jr	nz,.hit_loop

.next_group:
		GET_GAME_VARIABLE	VAR_BREATH_VALUE

		jr	z,.done

		inc	(iy+VAR_TARGET_ID)
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)

		cp	$84 ; '„'
		jr	z,.done

		and	$7F

		GET_A_FROM_TABLE	$36

		jr	z,.next_group

		GET_GAME_VARIABLE	VAR_BREATH_COUNT

		jr	z,.continue_group

		PRINT_NEWLINE

		PRINT_MESSAGE	$69			; "and"

.continue_group:
		jp	.target_group
; -------------------------------------

.done:
		xor	a
		ld	(GAME_VARIABLES + VAR_BREATH_VALUE),a

		ret
