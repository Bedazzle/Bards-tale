; --- ev_show_number ($D384-$D396) ----------------------------------
; @done
; Special event: compute a number (hl-$FB20)/2+$22 and print it.

ev_show_number:
		ld	de,$FB20
		and	a
		sbc	hl,de
		ld	a,l
		srl	a
		add	a,$22
		push	af
		CLEAR_INFO_PANEL
		pop	af
		PRINT2_A_WITH_FLAG_0
		jr	ev_spin_facing.skip
