; --- select_spell_target (select spell target) -------------------------
; @done
; Prepares to cast the current spell at a target. Checks the spell's
; area/target mask (item mask $69 bit 7): a mask value >= 4 means the
; spell hits everyone, so it returns success with carry set without
; prompting. Otherwise it shows the enemy groups, prints "Cast at" and
; lets the player pick an enemy target (SELECT_TARGET).
; In:  a = spell/target descriptor, iy = game variables base
; Out: carry set = target chosen / area spell; carry clear = cancelled
select_spell_target:
		CHECK_ITEM_MASK	$69,7

		cp	4
		ccf
		ret	c

		call	print_enemy_group
		ret	c

		ld	c,a

		PRINT_MESSAGE	5			; "Cast at"

		ld	a,c

		SELECT_TARGET

		ccf

		ret

; --- print_enemy_group --------------------------------------
; @done
; Clears the info panel and lists the current enemy groups
; (print_N_enemies), then parks the text cursor at row/col $150B ready
; for the target prompt. Preserves the caller's A and returns with the
; flags reflecting it (and a set to logical-AND result / NZ).
; In:  a = value to preserve, iy = game variables base
; Out: a, flags = caller's A restored
print_enemy_group:
		push	af

		CLEAR_INFO_PANEL

		call	print_N_enemies
		ld	hl,$150B
		ld	(GAME_VARIABLES + VAR_CURSOR_ROW),hl
		pop	af
		and	a

		ret
