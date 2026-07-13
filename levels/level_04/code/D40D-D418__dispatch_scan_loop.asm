; --- dispatch_scan_loop ($D40D-$D418) ----------------------------------
; @done
; Scan-loop continuation of dispatch_special_location: advance to the next
; special_dispatch_table entry / event type, or fall through to event-done.

dispatch_scan_loop:
		inc	hl
		djnz	dispatch_special_location.skip2
		pop	bc
		inc	b
		ld	a,b
		cp	11
		jr	c,dispatch_special_location.skip
		jr	process_cell_features.done
