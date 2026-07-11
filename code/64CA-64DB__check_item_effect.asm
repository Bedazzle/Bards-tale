; --- check_item_effect (CHECK_ITEM_MASK) ----------------------------
; @done
; Look up an item/monster effect byte and mask it. Reads two inline
; params: the first selects the effect table (patched into the
; GET_D_FROM_TABLE index at .lookup_effect), the second is an AND mask.
; A on entry indexes the chosen table; the fetched byte is ANDed with
; the mask.
; In:  a = table index; two inline params = effect-table id, AND mask
; Out: a = effects[index] & mask
; Note: self-modifies the table-id operand of the lookup. Preserves DE.
check_item_effect:			; CHECK_ITEM_MASK
		push	de
		ld	d,a
		call	get_param_to_A
		ld	(.lookup_effect+2),a
		call	get_param_to_A
		ld	e,a

.lookup_effect:
		GET_D_FROM_TABLE	INX_ITEM_EFFECTS

		and	e
		pop	de

		ret
