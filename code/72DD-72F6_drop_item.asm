drop_item:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		db  17h, 45h, 0FFh			; "Drop Item"
									; "(1-8)"

		ENTER_1_TO_8

		ret	c

		cp	1
		jr	z, thats_equipped

		jp	loc_72A4

thats_equipped:
		PRINT_SPACE_LINE

		PRINT_MESSAGE	18h			; "That's equipped!"

go_change_speed:
		CHANGE_SPEED 0Ah

		ret
