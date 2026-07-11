; --- print_ellipsis -----------------------------------------
; @done
; Print the "..." message (id $86). Shared tail used by many spell
; and action handlers to close their on-screen feedback.
print_ellipsis:
		PRINT_MESSAGE	$86			; "..."

		ret
