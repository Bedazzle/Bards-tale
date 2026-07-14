; --- handle_wandering_creature ($D84D-$D88F) ----------------------------------
; @done
; Dispatch[3]: wandering-creature encounter (offer join / fight / leave).

handle_wandering_creature:
		GET_RND_NUMBERS
		push	af
		GET_IY_A_FROM_TABLE $54,$4F
		ld	c,a
		GET_IY_A_FROM_TABLE $54,$50
		ld	b,a
		cp	$50
		jr	nz,.skip
		inc	b
.skip:
		pop	af
		and	c
		add	a,b
		jr	nz,.skip2
		inc	a
.skip2:
		ld	(ACTIVE_GUARDIAN),a
		ld	a,1
		ld	(COMBAT_ACTIVE_FLAG),a
		call	show_some_pictext
		CLEAR_INFO_PANEL
		PRINT_MESSAGE2 $12
.loop:
		WAIT_KEY_DOWN
		cp	$4C
		jr	z,.done
		cp	$41
		jr	z,wc_show_joiner
		sub	$46
		jr	nz,.loop
		ld	(enemy_count),a
		inc	(iy+$5B)
		call	combat_foes
.done:
		CLEAR_INFO_PANEL
		and	a
		ret
