; --- trap_name_table ($D725-$D777) ----------------------------------
; @done

trap_name_table:
		ld	bc,$402
		ex	af,af'
		djnz	.loop
		ld	b,b
		add	a,b
		dec	a
		GET_E_FROM_TABLE $D7
		ld	c,e
		PICK_RANDOM_HERO
		PRINT_MEMBERS_COUNT
		CALC_MONSTER_HP
		rst	$10 : db $64
		rst	$10 : db $6F
		FIND_INN $4F
		ld	c,c
		ld	d,e
		ld	c,a
		ld	c,(hl)
		jr	nz,$D793
		ld	b,l
		ld	b,l
		ld	b,h
		ld	c,h
		ld	b,l
		rst	$38
.loop:
		ld	b,d
		ld	c,h
		ld	b,c
		ld	b,h
		ld	b,l
		rst	$38
		ld	b,h
		ld	b,c
		ld	d,d
		ld	d,h
		rst	$38
		ld	b,d
		ld	c,h
		ld	b,c
		ld	b,h
		ld	b,l
		rst	$38
		ld	d,e
		ld	c,b
		ld	c,a
		ld	b,e
		ld	c,e
		ld	b,l
		ld	d,d
		rst	$38
		ld	b,e
		ld	d,d
		ld	b,c
		ld	e,d
		ld	e,c
		ld	b,e
		ld	c,h
		ld	c,a
		ld	d,l
		ld	b,h
		rst	$38
		ld	c,l
		ld	c,c
		ld	c,(hl)
		ld	b,h
		ld	d,h
		ld	d,d
		ld	b,c
		ld	d,b
		rst	$38
