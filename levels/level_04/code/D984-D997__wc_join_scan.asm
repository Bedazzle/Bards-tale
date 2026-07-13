; --- wc_join_scan ($D984-$D997) ----------------------------
; @done

wc_join_scan:
		ld	e,a
		ld	d,0
		ld	b,1
.loop:
		ld	a,b
		call	add_item_to_hero
		jp	nc,find_hero_by_B
		inc	b
		ld	a,b
		cp	7
		jr	c,.loop
		pop	bc
		ret
