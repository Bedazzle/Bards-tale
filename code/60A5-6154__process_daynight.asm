; --- process_daynight -------------------------------------
; @done
; Tick the game clock each turn. Counts down the nested inner / mid
; / outer day counters, toggles the day/night flag (VAR_DAY_PART)
; at each boundary, and ages the party's timed effect durations
; (character attribute slots $1F-$23,$28): as each expires it shows
; the matching status icon and clears the related state (e.g. light
; distance / secret reveal). Periodic sub-counters fire recurring
; events (call to $7DF9, daybreak regenerate_hp_sp) and, on the inner
; boundary, apply poison (process_poison).
; In:  iy = game variables base
; Note: which effect each attribute slot holds is inferred from the
;       icon shown on expiry.
process_daynight:
		ld	hl,GAME_VARIABLES + VAR_DAY_INNER
		dec	(hl)
		ret	nz

		ld	(hl),$0A		; 10
		dec	(iy+VAR_DAY_OUTER_CTR)
		jp	nz,tick_mid_counter

		ld	hl,GAME_VARIABLES + VAR_DAY_OUTER
		dec	(hl)
		jr	z,reset_day_outer

		ld	a,(hl)

		cp	$0F				; 15
		jr	z,day_change_night
		jr	nz,age_effect_1F

reset_day_outer:
		ld	(hl),$1F		; 31

day_change_night:
		ld	hl,GAME_VARIABLES + VAR_DAY_PART
		ld	a,(hl)
		xor	1
		ld	(hl),a
		ex	af,af'

		GET_GAME_VARIABLE	VAR_UNDERGROUND

		jr	nz,age_effect_1F

		ex	af,af'
		ld	(GAME_VARIABLES + VAR_COPY_DAYPART),a

age_effect_1F:
		GET_ATTR_SAVE_IX	$1F

		jr	z,age_effect_20

		inc	a
		jr	z,age_effect_20

		dec	(hl)
		jr	nz,age_effect_20

		SHOW_ICON	ICON_SPACE

		xor	a
		ld	(GAME_VARIABLES + VAR_LIGHT_DIST),a
		ld	(GAME_VARIABLES + VAR_REVEAL_SECRET),a

age_effect_20:
		GET_ATTR_SAVE_IX	$20

		jr	z,age_effect_28

		inc	a
		jr	z,age_effect_28

		dec	(hl)
		jr	nz,age_effect_28

		SHOW_ICON	$0A

age_effect_28:
		GET_ATTR_SAVE_IX	$28

		jr	z,age_effect_21

		dec	(hl)

age_effect_21:
		GET_ATTR_SAVE_IX	$21

		jr	z,age_effect_22

		inc	a
		jr	z,age_effect_22

		dec	(hl)
		jr	nz,age_effect_22

		SHOW_ICON	$0D

age_effect_22:
		GET_ATTR_SAVE_IX	$22

		jr	z,age_effect_23

		inc	a
		jr	z,age_effect_23

		dec	(hl)
		jr	nz,age_effect_23

		SHOW_ICON	$0B

age_effect_23:
		GET_ATTR_SAVE_IX	$23

		jr	z,tick_mid_counter

		inc	a
		jr	z,tick_mid_counter

		dec	(hl)
		jr	nz,tick_mid_counter

		SHOW_ICON	$0C

tick_mid_counter:
		ld	hl,GAME_VARIABLES + VAR_DAY_MID_CTR
		dec	(hl)
		jr	nz,tick_inner_counter

		ld	(hl),$50

		GET_GAME_VARIABLE	VAR_DAY_TIMER_CHK			; ???

		jr	nz,tick_inner_counter
		call	regen_equipped_effects

		GET_GAME_VARIABLE	VAR_NIGHT_TIMER			; ???

		jr	nz,do_daybreak

		GET_GAME_VARIABLE	VAR_UNDERGROUND

         jr      nz,tick_inner_counter

		GET_GAME_VARIABLE	VAR_DAY_PART

		jr	nz,tick_inner_counter

do_daybreak:
		call	regenerate_hp_sp

tick_inner_counter:
		ld	hl,GAME_VARIABLES+VAR_DAY_INNER_CTR
		dec	(hl)
		ret	nz

		ld	(hl),$20 ; ' '

		GET_GAME_VARIABLE	VAR_DAY_TIMER_CHK			; ???

		call	z,process_poison

		ret
