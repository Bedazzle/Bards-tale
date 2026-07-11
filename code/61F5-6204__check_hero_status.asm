; --- check_hero_status ------------------------------------
; @done
; Test a hero's CHAR_STATUS. A status below STATUS_DEAD returns
; "ok" (carry set, zero set). Otherwise (dead / possessed / worse)
; it returns carry reflecting the hero's usability, from the
; comparison with STATUS_POSSESSED.
; In:  ix = hero record
; Out: carry / zero flags encode the hero's status
; Note: exact dead-vs-possessed flag encoding partially inferred.
check_hero_status:
		ld	a,(ix+CHAR_STATUS)

		cp	STATUS_DEAD
		jr	c,is_alive_and_ok

		cp	STATUS_POSSESSED
		inc	a
		dec	a
		ccf

		ret

is_alive_and_ok:
		cp	a
		scf

		ret
