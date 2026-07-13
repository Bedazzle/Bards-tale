; --- dispatch_special_location ($D394-$D3CE) -------------------
; @done
; Scan the special-location list ($FA40) for the party cell and SMC-dispatch its event handler (jp slot $D3C0).
; In:  party cell (iy+1/iy+2); fires that cell's special event via the SMC jp

dispatch_special_location:
		ld	b,1			; dispatch-table entry 1..10
.entry_loop:
		push	bc
		ld	hl,special_dispatch_table-4
.index:
		inc	hl			; hl += 4*b -> this entry (4-byte records)
		inc	hl
		inc	hl
		inc	hl
		djnz	.index
		ld	b,(hl)			; cells in this partition
		inc	hl
		ld	c,(hl)			; cell_offset into special_loc_list
		inc	hl
		ld	e,(hl)			; the partition's event handler
		inc	hl
		ld	d,(hl)
		ld	(.portal_op),de		; patch the portal jump below
		ld	hl,special_loc_list
		ld	e,c
		ld	d,0
		add	hl,de			; -> this partition's cell list
.scan:
		ld	a,(hl)
		inc	hl
		cp	(iy+1)			; party N/S?
		jr	nz,.no_match
		ld	a,(hl)
		cp	(iy+2)			; party W/E?
		jr	nz,.no_match
		pop	bc
.portal:
		jp	.portal			; SMC: jump to the matched cell's handler

.portal_op EQU $-2
.no_match:
		inc	hl
		djnz	.scan
		pop	bc
		inc	b
		ld	a,b
		cp	11			; 10 dispatch entries
		jr	c,.entry_loop
		jr	process_cell_features.next
