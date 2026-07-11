; --- print_and_wait ------------------------------------------
; @done
; Print "Press Any Key..." on a new line and wait for a keypress.
; Out: a = key pressed (from wait_key_down)
print_and_wait:
		PRINT_CRLF_AND_MESSAGE	$33			; "Press Any Key..."

		jp	wait_key_down
