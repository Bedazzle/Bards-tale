; --- ev_show_number ($D416-$D428) ------------------------------
; @wip
; Special event: compute a number (hl-$FB20)/2+$22 and print it.

ev_show_number:
		ld	de,$fb20
		and	a
		sbc	hl,de
		ld	a,l
		srl	a
		add	a,$22
		push	af
		CLEAR_INFO_PANEL
		pop	af
		PRINT2_A_WITH_FLAG_0
		jr	event_done
