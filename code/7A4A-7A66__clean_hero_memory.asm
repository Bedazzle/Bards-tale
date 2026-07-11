; --- clean_hero_memory ---------------------------------------
; @done
; Wipes a single character record (hero or ally) at ix: clears the
; leading "alive" byte, fills the name field with spaces up to the
; name terminator, then zeroes the remaining 83 attribute bytes, and
; finally stamps CHAR_NAME_TERM with $FF to mark the slot empty.
; In:  ix = character record to erase
; Note: also invoked engine-wide via the CLEAN_HERO_MEMORY macro (RST 10h id $12).
clean_hero_memory:
		PUSH_REGS

		push	ix
		pop	hl
		ld	(hl),0			; kill hero
		inc	hl
		ld	(hl),$20 ; ' '
		ld	d,h
		ld	e,l
		inc	de
		ld	bc,CHAR_NAME_TERM
		ldir				; clean name

		ld	(hl),0
		ld	c,$53 			; 83 = 100 (total bytes) - 15 (name) - 1 (name terminator) - 1 (pos in party)
		ldir				; clean hero attributes

		ld	(ix+CHAR_NAME_TERM),$FF

		ret
