; --- start_spell_or_song --------------------------------------
; @done
; Begin a SPELL effect. Takes the spell id in a, looks its duration
; up in duration table $23 (indexed by id*2, a 16-bit little-endian
; entry) and hands off to activate_effect, which records the
; duration, the casting hero and sets the "effect active" flag. The
; per-round countdown is then done by tick_spell_duration.
; In:  a  = spell id
;      iy = game variables base
; Out: active spell recorded (see activate_effect)
start_spell_or_song:
		ld	d,a			; d = effect id (stored to VAR_CAST_HERO)
		ld	e,0			; e = 0 -> spell variant
		ld	b,a
		sla	b			; b = id*2 (word index into table)

		GET_B_FROM_TABLE	$23

		jr	activate_effect

; --- start_song_effect -------------------------------------------------
; @done
; Begin a SONG effect (bard). The song variant of start_spell_or_song:
; duration comes from table $24, e = 1 marks it as a song, then it
; falls through to activate_effect. Called from process_bard_song.
; In:  a  = song id
;      iy = game variables base
; Out: active song recorded (see activate_effect)
start_song_effect:
		ld	d,a			; d = effect id (stored to VAR_CAST_HERO)
		ld	e,1			; e = 1 -> song variant
		ld	b,a
		sla	b			; b = id*2 (word index into table)

		GET_B_FROM_TABLE	$24

; --- activate_effect ------------------------------------------
; @done
; Shared tail for start_spell_or_song / start_song_effect. Reads the 16-bit
; duration for the effect (low byte already in a, high byte the next
; table entry), stores it in VAR_SPELL_DURATION, records the casting
; hero id (d) in VAR_CAST_HERO, and raises VAR_SPELL_ACTIVE so that
; tick_spell_duration begins counting the effect down.
; In:  a  = duration low byte, hl' = table entry ptr, d = effect id
;      iy = game variables base
; Out: VAR_SPELL_DURATION, VAR_CAST_HERO set; VAR_SPELL_ACTIVE = 1
activate_effect:
		ld	l,a
		exx
		inc	hl
		ld	a,(hl)
		exx
		ld	h,a
		ld	(GAME_VARIABLES + VAR_SPELL_DURATION),hl
		ld	(iy+VAR_CAST_HERO),d
		ld	(iy+VAR_SPELL_ACTIVE),1

		ret
