; --- spell_stat_modifiers -------------------------------------
; @done
; Combat stat / defence spell handler (one of several effect
; handlers in this file, each dispatched by address from
; procs_buffer2). Rolls a resist check (combat_flee_check); on
; failure prints "but it had no effect!" and returns. On success, if
; an ENEMY cast it (bit 7 of VAR_ACTIVE_HERO set) the party loses an
; attack this round; otherwise the effect is applied to the targeted
; foe. Exits through stat_spell_done.
; In:  iy = game variables base; VAR_ACTIVE_HERO, VAR_TARGET_ID
; Note: exact per-foe effect (table 1) partially inferred.
spell_stat_modifiers:
		call	combat_flee_check
		jr	nc,.no_effect

		bit	7,(iy+VAR_ACTIVE_HERO)
		jr	z,.affect_target

		inc	(iy+VAR_INITIATIVE_FLAG)

		PRINT_MESSAGE	$6B			; "and the party misses an attack"

		jr	stat_spell_done

.affect_target:
		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		and	$7F

		GET_A_FROM_TABLE	1

		exx
		inc	(hl)
		exx

		jr	stat_spell_done

.no_effect:
		PRINT_MESSAGE	$6A			; "but it had no effect!"

		ret

; -------------------------------------

; --- mod_stat_22 -------------------------------------------------
; @done
; Armour-class modifier spell handler. Reads the modifier amount
; from table $22. Cast by the party it adds the amount to
; VAR_STAT_MODIFIER and recalculates AC (.buff_party_ac); cast at a
; foe it applies the effect to the target group via add_attack_bonus.
; In:  b = spell id; iy = game variables base
; Note: purpose partially inferred.
mod_stat_22:
		GET_B_FROM_TABLE	$22

		ld	c,a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c,.buff_party_ac

		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)
		and	$7F

		GET_A_FROM_TABLE	$2E

		jp	add_attack_bonus

.buff_party_ac:
		ld	hl,GAME_VARIABLES + VAR_STAT_MODIFIER
		ld	a,c
		add	a,(hl)
		ld	(hl),a

		RECALC_ALL_AC

stat_spell_done:
		jp	print_ellipsis

; -------------------------------------

; --- mod_stat_21 -------------------------------------------------
; @done
; Party defence-buff spell handler. Reads the buff amount from table
; $21, applies it through add_attack_bonus and rebuilds the whole party's
; armour class (recalc_party_ac).
; In:  b = spell id; iy = game variables base
; Note: purpose partially inferred.
mod_stat_21:
		GET_B_FROM_TABLE	$21

		ld	c,a

		GET_IY_A_FROM_TABLE	$52,$45

		call	add_attack_bonus

		jp	recalc_party_ac

; -------------------------------------

; --- mod_stat_5D -------------------------------------------------
; @done
; Song-based stat modifier handler. Reads the amount from table $5D.
; Cast by the party it adds to VAR_SONG_MODIFIER and recalculates
; AC; cast at a foe it subtracts the amount from the target's stat
; (.debuff_target). Exits through stat_spell_done.
; In:  b = spell id; iy = game variables base
; Note: purpose partially inferred.
mod_stat_5D:
		GET_B_FROM_TABLE	$5D

		ld	c,a

		GET_GAME_VARIABLE	VAR_ACTIVE_HERO		; ???

		jr	c,.debuff_target
		ld	a,c
		ld	hl,GAME_VARIABLES + VAR_SONG_MODIFIER
		add	a,(hl)
		ld	(hl),a

		RECALC_ALL_AC

		jr	stat_spell_done
; -------------------------------------

.debuff_target:
		and	$7F

		GET_A_FROM_TABLE	$2E

		sub	c
		exx
		ld	(hl),a
		exx

		jr	stat_spell_done
; -------------------------------------

; --- heal_or_cure -------------------------------------------------
; @done
; Healing-spell dispatcher. With carry set the spell heals the whole
; party (.heal_party loops slots 6..0 through spell_heal_and_cure);
; otherwise it heals the single current target. Exits through
; stat_spell_done.
; In:  carry = heal-all flag; iy = game variables base
heal_or_cure:
		jr	c,.heal_party

		call	spell_heal_and_cure

		jr	stat_spell_done
; -------------------------------------

.heal_party:
		ld	b,6

.heal_next:
		ld	(iy+VAR_TARGET_ID),b
		call	spell_heal_and_cure
		dec	b
		jp	p,.heal_next

		jr	stat_spell_done
