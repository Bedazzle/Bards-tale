; --- use_item ------------------------------------------------
; @done
; The (U)se-an-item action: pick a hero and an item (use_which_item),
; validate it can be used now (not combat-only, not junk), then apply
; its spell/effect - prompting "Use on" + target for single-target
; effects.
use_item:
		PRINT_WHO_WILL

		PRINT_MESSAGE	$51			; "use an item?"

		CHOOSE_HERO

		ret	c

		call	use_which_item
		ret	z

		jr	c,cant_use_that

		or	a
		jp	p,for_combat_only

		and	$7F

		cp	$10
		jr	c,cant_use_that

		call	break_item

		GET_A_FROM_TABLE	$6A

		ld	(GAME_VARIABLES + VAR_CURRENT_SPELL),a

		CHECK_ITEM_MASK	$69,7

		cp	4
		jr	nc,.cast_effect

		push	af

		CLEAR_INFO_PANEL

		ld	(iy+VAR_CURSOR_ROW),$0B

		PRINT_MESSAGE	$21			; "Use on"

		pop	af

		SELECT_TARGET

		ret	c

		ld	(GAME_VARIABLES + VAR_TARGET_ID),a

.cast_effect:
		CLEAR_INFO_PANEL

		call	spell_casting
		scf

		ret
; -------------------------------------

cant_use_that:
		PRINT_MESSAGE	$11			; "You can't use that."

		jr	change_speed_8

for_combat_only:
		PRINT_MESSAGE	$22			; "That's for combat only."

; --- change_speed_8 ------------------------------------------
; @done
; Set text speed to fast (CHANGE_SPEED 8) and return. Shared tail and
; dispatch handler $34.
change_speed_8:
		CHANGE_SPEED 8

		ret
; -------------------------------------

; --- use_which_item ------------------------------------------
; @done
; List the hero's items, prompt "Use item (1-8)", and return the
; chosen item's effect id.
; Out: a = item effect id; h and flags signal the result: h=1 (nz) a
;      usable item was chosen, else no item / aborted.
use_which_item:
		call	print_hero_items

		PRINT_MESSAGE	3			; "Use item"

		PRINT_MESSAGE	$45			; "(1-8)"

		ENTER_1_TO_8

		jr	c,.no_item

		sub	2
		ccf
		jr	z,.found_item

		inc	hl
		ld	a,(hl)
		or	a
		ret	z

		dec	hl
		push	ix
		pop	de
		and	a
		sbc	hl,de

		GET_A_FROM_TABLE	INX_ITEM_EFFECTS

		and	a

.found_item:
		ld	h,0
		inc	h

		ret

.no_item:
		xor	a

		ret
