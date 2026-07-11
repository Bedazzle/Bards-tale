; --- attack_and_result ---------------------------------------
; @done
; Print the attack-outcome phrase during combat. Reads the effect
; type from VAR_DAMAGE_TYPE: when it is non-zero it prefixes the word
; with "and" (falling into print_attack_result); the effect word is then printed
; (word index = type + $A4) and the current target id is returned in
; A for the caller. Dispatch handler $55.
; In:  VAR_DAMAGE_TYPE = effect type, VAR_TARGET_ID = target
; Out: a = VAR_TARGET_ID
attack_and_result:
		GET_GAME_VARIABLE	VAR_DAMAGE_TYPE		; ???

		jr	z,print_attack_result.print_word

; --- print_attack_result ------------------------------------------------
; @done
; Print "and" followed by an effect word (word index = A + $A4),
; preserving A across the connective, then load the current target id
; into A. attack_and_result skips the "and" by jumping to .print_word;
; resolve_spell_effect calls here directly.
; In:  a = effect word offset
; Out: a = VAR_TARGET_ID
print_attack_result:
		push	af

		PRINT_MESSAGE	$69			; "and"

		pop	af

.print_word:
		add	a,$A4

		PRINT_WORD

		ld	a,(GAME_VARIABLES + VAR_TARGET_ID)

		ret
