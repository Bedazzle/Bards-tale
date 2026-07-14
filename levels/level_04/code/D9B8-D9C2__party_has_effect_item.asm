; --- party_has_effect_item ($D9B8-$D9C2) ----------------------------------
; @done
; Scan all 6 party members for an equipped item granting effect A (calls
; check_equipped+3 per hero slot). Used by the dungeon logic to test for a
; light/compass/etc item.
; In:  a = effect-id.  Out: carry CLEAR if any hero has it, SET if none.

party_has_effect_item:
		ld	b,6
		ld	c,a
.loop:
		ld	a,c
		call	var_6CDA
		ret	nc
		djnz	.loop
		ret
