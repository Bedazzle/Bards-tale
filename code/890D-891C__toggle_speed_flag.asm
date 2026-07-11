; --- toggle_speed_flag --------------------------------------
; @done
; Flip the animation-speed flag VAR_ANIM_SPEED_FLAG between 0 and
; $FF. If it was $FF (inc -> 0) it becomes 0, otherwise $FF.
; In:  iy = game variables
toggle_speed_flag:
		ld	a,(GAME_VARIABLES + VAR_ANIM_SPEED_FLAG)
		inc	a
		jr	nz,.set_ff

		ld	(GAME_VARIABLES + VAR_ANIM_SPEED_FLAG),a

		ret

.set_ff:
		ld	a,$FF
		ld	(GAME_VARIABLES + VAR_ANIM_SPEED_FLAG),a

		ret
;***************************
; can be optimized (4 bytes) to
;
;toggle_speed_flag:
;		ld	a, (GAME_VARIABLES + VAR_ANIM_SPEED_FLAG)
;		inc	a
;		jr	z, put_a_back
;
;		ld	a, 0FFh
;put_a_back:
;		ld	(GAME_VARIABLES + VAR_ANIM_SPEED_FLAG), a
;
;		ret
;***************************