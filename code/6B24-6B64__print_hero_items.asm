; --- print_hero_items -------------------------------------
; @done
; List a hero's inventory. For each of the 8 item slots of the
; hero at ix, print the slot number, ')', a status-marker glyph
; (equipped / broken / normal) and the item's name; items whose
; id has bit 7 set are shown as an unidentified type.
; In:  ix = hero record, iy = game variables base
; Out: item list drawn in the info panel
print_hero_items:
		CLEAR_INFO_PANEL

		PRINT_IX_HERO_NAME

		PRINT_NEWLINE

		ld	b,0

loop_item_list:
		ld	a,b

		PRINT_NEXT_DIGIT	; item position in list

		ld	a,')'

		PRINT_WITH_CODES

		ld	a,b
		add	a,a			; two byte per item, x2
		add	a,$50 			; items start from index 50h in hero table

		GET_ATTR_BY_A

		ld	d,a
		ld	e,a
		or	a
		jp	p,get_item_status

		and	$0F
		ld	e,a
		jr	nz,get_item_status

		ld	e,3

get_item_status:
		GET_E_FROM_TABLE	$3F

		PRINT_WITH_CODES

		inc	hl
		ld	a,(hl)
		or	a
		jr	z,next_item_in_list

		bit	7,d
		jr	z,print_list_item

print_unknown_type:
		CHECK_ITEM_MASK	$6B,$0F

		or	$80

print_list_item:
		PRINT_ITEM_NAME

next_item_in_list:
		PRINT_NEWLINE

		inc	b
		ld	a,b

		cp	8
		jr	c,loop_item_list

		ret
