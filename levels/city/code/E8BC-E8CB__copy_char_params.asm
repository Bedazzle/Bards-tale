; --- copy_char_params -----------------------------------------------
; @done
; Restore a hero's packed parameters from their backup: copy the
; 4-byte CHAR_BACKUP_PARAMS block over the live CHAR_PARAMS_HI block.
; Reverses the params backup taken during a class change / possession.
; In:  ix = hero record
copy_char_params:
		ld	b,4

		FIND_ATTR_AND_ADDRESS	CHAR_PARAMS_HI

		ex	de,hl			; de = live params (dest)

		FIND_ATTR_AND_ADDRESS	CHAR_BACKUP_PARAMS

.copy:
		ld	a,(hl)			; src = backup
		ld	(de),a
		inc	hl
		inc	de
		djnz	.copy

		ret
