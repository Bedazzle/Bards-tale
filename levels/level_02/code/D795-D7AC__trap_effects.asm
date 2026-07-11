; --- trap_effects ------------------------------------------
; @done
; Per-trap effect attributes for the 8 dungeon traps (index 0..7), as three 8-byte
; columns; spring_trap reads the third column at trap_effects+16.
trap_effects:
		DB $00,$00,$00,$01,$01,$00,$00,$06
		DB $01,$01,$01,$01,$00,$00,$01,$00
		DB $01,$02,$02,$01,$02,$04,$03,$01
