; --- drop_item -----------------------------------------------
; @done
; The (D)rop action: prompt "(1-8)" for an inventory slot and delete
; that item (via delete_hero_item). Refuses to drop an equipped item with
; "That's equipped!". Dispatch handler for 'D'.
drop_item:
		PRINT_SPACE_LINE

		PRINT_IN_LOOP
		DB $17,$45,$FF			; "Drop Item"
									; "(1-8)"

		ENTER_1_TO_8

		ret	c

		cp	1
		jr	z,thats_equipped

		jp	delete_hero_item

; --- thats_equipped ------------------------------------------
; @done
; Shared message block: print "That's equipped!" then fall into
; go_change_speed. Reached from drop_item and trade_gold.
thats_equipped:
		PRINT_SPACE_LINE

		PRINT_MESSAGE	$18			; "That's equipped!"

; --- go_change_speed -----------------------------------------
; @done
; Restore the normal (slow) text speed (CHANGE_SPEED $0A) and return.
; Shared exit tail for the inventory actions.
go_change_speed:
		CHANGE_SPEED $0A

		ret
