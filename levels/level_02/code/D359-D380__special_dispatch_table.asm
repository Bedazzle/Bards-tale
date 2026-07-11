; --- special_dispatch_table --------------------------------
; @done
; Per-cell special-event dispatch (scanned by dispatch_special_location, base-4).
; Each record: DB type, loc-table-param : DW event handler.
special_dispatch_table:
		DB $08,$20 : DW ev_portal
		DB $10,$40 : DW ev_set_flags
		DB $08,$60 : DW ev_teleport
		DB $08,$80 : DW ev_spin_facing
		DB $08,$90 : DW ev_message
		DB $10,$A0 : DW ev_redraw_status
		DB $08,$C0 : DW ev_inc_2f
		DB $08,$D0 : DW ev_inc_3e
		DB $08,$E0 : DW ev_show_locnum
		DB $08,$F0 : DW ev_guardian
