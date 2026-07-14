; --- party_has_effect_item ($D85D-$D879) ----------------------------------
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

		db $6F,$26,$00,$FD,$36,$50,$00,$06	; o&..6P..
		db $06,$78,$CD,$4E,$7C,$05,$F2,$71	; .x.N|..q
		db $D8,$C9	; ..
