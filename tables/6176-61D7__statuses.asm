; --- STATUSES -------------------------------------------------
; @done
; Flat pool of 2-char ASCII display strings, addressed by byte index.
; print_letter_pair loads C=index and prints the pair at [index] and
; [index+1] via prnt_with_codes, so each logical entry is 2 bytes
; (a 4-char condition name spans two consecutive pair slots).
; Three concatenated sub-tables:
;   +$00: 21 stat/level readouts "10".." 0".."-9","LO"
;   +$2A: 12 class/race codes "Wa".."Mo","??","--"
;   +$42:  8 condition names ("  Ok","Psnd"," Old","Dead", ...) - 4 chars each
; Referenced by: ADDR_TABLE index $66 (INX_STATUSES) - print_letter_pair
STATUSES:
		DB "10"
		DB " 9"
		DB " 8"
		DB " 7"
		DB " 6"
		DB " 5"
		DB " 4"
		DB " 3"
		DB " 2"
		DB " 1"
		DB " 0"
		DB "-1"
		DB "-2"
		DB "-3"
		DB "-4"
		DB "-5"
		DB "-6"
		DB "-7"
		DB "-8"
		DB "-9"
		DB "LO"

		DB "Wa"	; Warrior
		DB "Wi"	; Wizard
		DB "So"	; Sorcerer
		DB "Co"	; Conjurer
		DB "Ma"	; Magician
		DB "Ro"	; Rogue
		DB "Ba"	; Bard
		DB "Pa"	; Paladin
		DB "Hu"	; Human
		DB "Mo"	; Monk
		DB "??"
		DB "--"

		DB "  Ok"
		DB "Psnd"
		DB " Old"
		DB "Dead"
		DB "Ston"
		DB "Para"
		DB "Poss"
		DB "Nuts"
