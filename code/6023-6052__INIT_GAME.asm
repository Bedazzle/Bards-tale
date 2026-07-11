; --- INIT_GAME --------------------------------------------
; @done
; Cold game start. Clears the game-variable block (from
; VAR_XP_TOTAL_HI, $6F bytes) and sets the default combat speed,
; then falls into set_vars_and_IM to install the runtime and enter
; the main city loop.
INIT_GAME:
		ld	iy,GAME_VARIABLES
		ld	hl,GAME_VARIABLES + VAR_XP_TOTAL_HI
		ld	b,$6F
		call	nullify_buffer
		xor	a
		ld	(iy+VAR_COMBAT_SPEED),5

; --- set_vars_and_IM --------------------------------------
; @done
; (Re)install the runtime and enter the game: reset the stack, seed
; key game variables (portrait counter, pause off, info-panel
; column), point I at the IM 2 vector page ($2B00), enable
; interrupts, then jp game_cycle. Reached after a party load/save
; to resume play.
set_vars_and_IM:
		di
		ld	sp,STACK
		ld	iy,GAME_VARIABLES
		ld	(iy+VAR_PORTRAIT_CTR),$18
		ld	(iy+VAR_PAUSE),0			; pause off
		ld	(iy+VAR_INFO_COL_POS),$15	; 21

		di
		ld	a,$2B
		ld	i,a
		im	2
		ei

jmp_main_loop:
		jp	game_cycle
