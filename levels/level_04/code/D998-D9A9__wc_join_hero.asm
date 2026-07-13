; --- wc_join_hero ($D998-$D9A9) ----------------------------
; @done

wc_join_hero:
		ld	($D9A6),a
		ld	a,b
		call	wc_join_scan
		PRINT_IX_HERO_NAME
		PRINT_MESSAGE $7A
		PRINT_MESSAGE2 $00
		jp	change_speed_8
