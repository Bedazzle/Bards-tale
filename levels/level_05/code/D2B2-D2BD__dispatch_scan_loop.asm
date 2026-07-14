; --- dispatch_scan_loop ($D2B2-$D2BD) ----------------------------------
; @done
; Scan-loop continuation of dispatch_special_location: advance to the next
; special_dispatch_table entry / event type, or fall through to event-done.

dispatch_scan_loop:
		inc	hl
		djnz	mask_cell_byte.skip3
		pop	bc
		inc	b
		ld	a,b
		cp	11
		jr	c,mask_cell_byte.skip2
		jr	process_cell_features.done
