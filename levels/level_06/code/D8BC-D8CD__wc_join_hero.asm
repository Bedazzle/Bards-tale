; --- wc_join_hero ($D8BC-$D8CD) ----------------------------------
; @done

wc_join_hero:
		ld	($D8CA),a
		ld	a,b
		call	wc_join_scan
		PRINT_IX_HERO_NAME
		PRINT_MESSAGE $7A
		PRINT_MESSAGE2 $00
		jp	change_speed_8
