GAME_VARIABLES:	
		db 5	; 00h
		dw GUILD_COORDS
		db FACE_WEST
		db 0Ah	; 04h
		db 1Fh	; day outer
		db 1	; 06h
		db 0
		db 50h	; 08h
		db 0
		db 0
		db 0
		db 20h	; 0Ch
		db 0Ah	; day inner

		ds 25, 0

		db 5	; 27h

		ds 5, 0

		db 6	; 2Dh

		ds 30, 0

		db 0FFh	; 4Ch

		ds 43, 0
