print_and_wait:
		PRINT_CRLF_AND_MESSAGE	33h			; "Press Any Key..."

		jp	wait_key_down
