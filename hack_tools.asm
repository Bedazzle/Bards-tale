	MACRO SET_BORDER color
		ld a, color
		out ($FE), a
	ENDM

	IFUSED space_down
space_down:
		ld a,$7F
		in a,($FE)		; SP, SS, m, n, b
		bit 0, a
		ret
	ENDIF

	IFUSED wait_space_down
wait_space_down:
		SET_BORDER 1

		call	space_down
		jr	z, wait_space_down

wait_space_up:
		SET_BORDER 2

		call	space_down
		jr	nz, wait_space_up

		ret
	ENDIF

	IFUSED dummy_pause
hack_pause:
		ld c, $02
hack_loop:
		djnz $

		dec c
		jr nz, hack_loop

		ret
	ENDIF