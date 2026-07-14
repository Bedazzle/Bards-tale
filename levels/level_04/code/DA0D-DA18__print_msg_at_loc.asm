; --- print_msg_at_loc ($DA0D-$DA18) ----------------------------------
; @done
; SMC-reached tail: print a message then the location name. The lone ret is the
; not-taken path; the code-as-DB body (push af; clear_txt_buffer; print; jp
; print_loc_name) runs when entered via the patched dispatch.

print_msg_at_loc:
		ret

		db $F5,$CD,$34,$67,$F1,$CD,$D1,$C2	; ..4g....
		db $C3,$AA,$62	; ..b
