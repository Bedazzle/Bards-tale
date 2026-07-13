; --- ev_show_number ($D416-$D428) ------------------------------
; @done
; Special event: compute a number (hl-$FB20)/2+$22 and print it.

ev_show_number:
		ld	de,special_loc_list+$E0
		and	a
		sbc	hl,de			; entry offset within the list
		ld	a,l
		srl	a			; / 2 (word entries)
		add	a,$22			; -> displayed number
		push	af
		CLEAR_INFO_PANEL
		pop	af
		PRINT2_A_WITH_FLAG_0
		jr	event_done
