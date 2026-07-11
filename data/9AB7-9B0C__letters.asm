; --- lower_letters --------------------------------------------
; @done
; Alphabet row 0 (lowercase) for the packed-text decoder. A 5-bit
; letter-code (0..$1C) indexes one of the three 29-byte parallel rows
; here; the current shift/case state selects lower / UPPER / digits.
; This label is the base the decoder adds the code to (ld hl,lower_letters
; / add hl,bc). Row 0 = a-z then '\' (end-of-line), '.', ' '.
; Referenced by: print_msg_no_cp (.decode_letter, code/C06A print_msg_A).
lower_letters:
		DB "abcdefghijklmnopqrstuvwxyz\\. "
; --- upper_letters --------------------------------------------
; @done
; Alphabet row 1 (uppercase + punctuation) for the packed-text decoder,
; reached at lower_letters+29. A-Z then ',', '!', CR ($0D).
; Referenced by: print_msg_no_cp (.decode_letter), selected by shift state.
upper_letters:
		DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ,!",$0D
; --- digits_more ----------------------------------------------
; @done
; Alphabet row 2 (digits + symbols) for the packed-text decoder, reached
; at lower_letters+58. '0'-'9' then assorted punctuation.
; Referenced by: print_msg_no_cp (.decode_letter), selected by shift state.
digits_more:
		DB "0123456789-#()<[].+!':?> ,**"
