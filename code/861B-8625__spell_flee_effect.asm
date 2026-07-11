; --- spell_flee_effect --------------------------------------
; @done
; Word-of-Fear style spell handler: try to make the enemy group
; flee. On a successful flee check, falls through into
; spell_ac_modifier (which applies the follow-on effect). On
; failure prints "but it had no effect!" and hands off to
; change_combat_speed.
; In:  iy = game variables
; Note: success path deliberately falls through to spell_ac_modifier.
spell_flee_effect:
		call	combat_flee_check
		jr	c,spell_ac_modifier

		PRINT_MESSAGE	$6A			; "but it had no effect!"

		jp	change_combat_speed
