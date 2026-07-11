; --- process_bard_song ----------------------------------------
; @done
; Plays the selected bard song. Requires an equipped instrument and a
; remaining song charge (otherwise the bard "lost his voice"). It
; consumes one charge, prints "plays a tune...", runs the tune
; (start_song_effect) and waits for it to finish, then applies the song's
; combat effect by dispatching on the song id (from table $51):
; base-damage boost, damage penalty, per-party stat set, a repeated
; effect, an armour-class bonus, or the default +2 defence bonus.
; In:  ix = casting bard, iy = game variables; song id from table $51
; Out: a = 0, NC (song handled)
process_bard_song:
		GET_B_FROM_TABLE	$51

		ld	c,a

		PRINT_IX_HERO_NAME

		CHECK_EQUIPPED	5

		jr	nc,.play

		GET_ATTR_BY_PARAM	CHAR_BARD_SONGS

		jr	z,bard_lost_voice

		dec	(hl)

.play:
		PRINT_MESSAGE	$75			; "plays a tune..."

		inc	(iy+VAR_EVENT_DEPTH)
		ld	a,c
		call	start_song_effect
		dec	(iy+VAR_EVENT_DEPTH)

.wait_song:
		GET_GAME_VARIABLE	VAR_SPELL_ACTIVE		; ???

		jr	nz,.wait_song

		GET_IY_A_FROM_TABLE	$54,$43

		dec	c
		jp	m,.song_damage
		jr	z,.song_penalty

		dec	c
		jr	z,.song_party

		dec	c
		jr	z,.song_repeat

		dec	c
		jr	z,.song_ac

		ld	hl,GAME_VARIABLES + VAR_DEFENSE_BONUS
		ld	a,2

		jr	apply_song_bonus
; -------------------------------------

.song_ac:
		ld	hl,GAME_VARIABLES + VAR_SONG_MODIFIER
		call	apply_song_bonus

		RECALC_ALL_AC

		and	a

		ret
; -------------------------------------

.song_repeat:
		push	af
		ld	e,$30 ; '0'
		call	regen_all_stats
		pop	af
		dec	a

		jr	nz,.song_repeat

		and	a

		ret
; -------------------------------------

.song_party:
		ld	b,3
		ld	c,a

.party_loop:
		GET_B_FROM_TABLE	$55

		add	a,c
		exx
		ld	(hl),a
		exx
		dec	b
		jp	p,.party_loop

		and	a

		ret
; -------------------------------------

.song_penalty:
		ld	hl,GAME_VARIABLES + VAR_DAMAGE_PENALTY
		jr	apply_song_bonus

.song_damage:
		ld	hl,GAME_VARIABLES + VAR_BASE_DAMAGE

; --- apply_song_bonus -----------------------------------------
; @done
; Shared tail for the bard-song effects that bump a combat modifier:
; adds a to the game-variable byte at hl and stores the result back.
; In:  a = amount, hl = game-variable address
; Out: (hl) += a, a = new value, NC
apply_song_bonus:
		add	a,(hl)
		ld	(hl),a
		and	a

		ret

; --- bard_lost_voice ------------------------------------------
; @done
; Failure tail for process_bard_song: prints "lost his voice!" when
; the bard has no instrument equipped or no songs remaining.
bard_lost_voice:
		PRINT_MESSAGE	$76			; "lost his voice!"

		ret
