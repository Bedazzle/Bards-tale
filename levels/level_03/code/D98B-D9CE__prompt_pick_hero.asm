; --- prompt_pick_hero ($D98B-$D9CE) ----------------------------
; @done
; Prompt the player to pick a party member (1-6); returns the chosen hero.
; Out: b = chosen hero, carry set if cancelled

prompt_pick_hero:
		push	af
		PRINT_MESSAGE $1E
		pop	af
		PRINT2_A_WITH_FLAG_0
		PRINT_MESSAGE2 $07
		call	enter_1_to_6
		ret	c
		ld	b,a
		FIND_HERO_BY_B
		ret	z
		CHECK_HERO_STATUS
		ccf
		ret	c
		ld	a,1
		or	a
		ret

		DB $CD,$AE,$D9,$C0,$3E,$FB,$C3,$8C	; ....>...
		DB $D3,$32,$90,$FB,$3E,$01,$32,$98	; .2..>.2.
		DB $FB,$32,$06,$60,$FD,$36,$4D,$00	; .2.`.6M.
		DB $CD,$4B,$6D,$D7,$19,$51,$C9,$F5	; .Km..Q..
		DB $CD,$34,$67,$F1,$CD,$D1,$C2,$C3	; .4g.....
		DB $AA,$62	; .b
