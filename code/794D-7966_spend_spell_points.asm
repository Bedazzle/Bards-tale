loc_794D:
		ld	b, (iy+VAR_ACTIVE_HERO)

		FIND_HERO_BY_B

		RST_10_42

		ret	c

		ld	c, a

		CHECK_EQUIPPED	4

		jr	c, decrease_spell_points

		srl	c

decrease_spell_points:
		GET_ATTR_BY_PARAM	CHAR_SPPT_LO

		sub	c
		ld	(hl), a
		dec	hl
		ret	nc

		dec	(hl)
		and	a

		ret
