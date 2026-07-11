; --- apply_anti_magic ----------------------------------------
; @done
; Per-turn tick handler for the "anti-magic" active spell effect
; (dispatched from PROCS_2). Reads the effect's active-hero slot;
; while the countdown byte in b has not yet wrapped it simply stores
; it back to VAR_ANTIMAGIC and shows an ellipsis, and when it wraps
; ($FF -> 0) it sweeps the party marking every hero that has an
; active negation flag with a '*'. Always ends by printing an
; ellipsis as turn feedback.
; In:  iy = game variables base
; Note: purpose partially inferred (exact meaning of the GET_GAME_VARIABLE
;       carry/counter semantics is not fully proven).
apply_anti_magic:
		GET_GAME_VARIABLE	VAR_ACTIVE_HERO			; ???

		jr	nc,.active
		inc	(iy+VAR_ALLY_COUNTER)

.print_ellipsis:
		jp	print_ellipsis

.active:
		ld	(iy+VAR_ANTIMAGIC),b
		inc	b
		jr	nz,.print_ellipsis

		EXEC_FOR_HEROES	.mark_neg_hero

		jr	.print_ellipsis

.mark_neg_hero:
		ld	(iy+VAR_DISPLAY_COUNT),0

		GET_ATTR_BY_PARAM_SAVE_HL	CHAR_NEG_FLAG	; get hero active spell for neg

		ret	z

		ld	a,$2A ; '*'

		jp	print_empty
