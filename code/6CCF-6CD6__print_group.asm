; --- print_group ------------------------------------------
; @done
; Print the word 'group' followed by a '-' separator, tail-calling
; prnt_with_codes to emit the dash so the caller can append the
; group letter. Used by the combat target-selection prompts.
; Out: 'group-' printed to the info panel
print_group:
		PRINT_MESSAGE	$57			; "group"

		ld	a,$2D 		; '-'

		jp	prnt_with_codes
