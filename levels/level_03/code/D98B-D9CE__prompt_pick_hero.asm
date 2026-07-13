; --- prompt_pick_hero ($D98B-$D9CE) ----------------------------
; @wip
; Prompt the player to pick a party member (1-6); returns the chosen hero.

prompt_pick_hero:
		push	af
		PRINT_MESSAGE $1e
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
		db $cd,$ae,$d9,$c0,$3e,$fb,$c3,$8c	; ....>...
		db $d3,$32,$90,$fb,$3e,$01,$32,$98	; .2..>.2.
		db $fb,$32,$06,$60,$fd,$36,$4d,$00	; .2.`.6M.
		db $cd,$4b,$6d,$d7,$19,$51,$c9,$f5	; .Km..Q..
		db $cd,$34,$67,$f1,$cd,$d1,$c2,$c3	; .4g.....
		db $aa,$62	; .b
