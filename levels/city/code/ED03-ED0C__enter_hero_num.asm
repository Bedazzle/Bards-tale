; --- enter_hero_num -------------------------------------------
; @done
; Prompt for a party slot (1-6) and resolve it to a hero record.
; Reads a digit via ENTER_1_TO_6, then FIND_HERO_BY_A points ix at
; that hero's attribute block. Shared by every city location that
; acts on a chosen hero (temple, Roscoe's, shoppe, the inn, etc.).
; Out: CF set = user cancelled (a = key pressed);
;      ZF set = slot empty; else NC/NZ and ix = hero record.
enter_hero_num:
		ENTER_1_TO_6

		ret	c

		push	bc

		FIND_HERO_BY_A

		pop	bc
		ret	z

		and	a

		ret
