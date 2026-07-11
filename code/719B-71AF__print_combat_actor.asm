; --- print_combat_actor (print_combat_actor) ------------------------
; @done
; Print the name of the current combat actor/target (VAR_TARGET_ID).
; If the id refers to a party member, the hero's name is printed; if
; it is a monster (carry set), prints "A" plus the monster name via
; set_combat_target. Dispatch handler $53.
; In:  VAR_TARGET_ID = target actor id
print_combat_actor:				; PRINT_ACTOR_NAME
		PUSH_REGS

		GET_GAME_VARIABLE	VAR_TARGET_ID		; ???

		ld	b,a
		jr	c,.monster

		FIND_HERO_BY_B

		jp	print_IX_heroname

.monster:
		PRINT_MESSAGE	$10		; "A"

		res	7,b

		jp	set_combat_target
