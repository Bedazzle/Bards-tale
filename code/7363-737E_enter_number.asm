enter_1_to_6:
		WAIT_KEY_DOWN

		cp	'7'
		ccf
		ret	c

		sub	'1'
		ret	c

		inc	a

		ret

; -------------------------------------

enter_1_to_8:
		WAIT_KEY_DOWN

		cp	'9'
		ccf
		ret	c

		sub	'1'
		ret	c

		add	a, a
		add	a, CHAR_INVENTORY

		GET_ATTR_BY_A

		and	0Fh

		ret
