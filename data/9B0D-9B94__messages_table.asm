; --- messages_table -------------------------------------------
; @done
; Per-message length table for the 5-bit packed-text decoder. Byte [0]
; = $41 (message count, compared by print_msg_A `cp (hl)`); bytes [1..]
; give each message's length in 5-bit symbols. To reach message N the
; decoder sums earlier lengths, doing len*5/8 to convert symbol counts
; to a byte offset into the words_table stream.
; Referenced by: print_msg_A / print_msg_no_cp (hl=messages_table,
;               paired with de=words_table).
messages_table:	DB $41,$30,$0B,$0E,8,$0F,8,$0D,$15,$16,7,$14,$23,4,$14,$27 ; ...
		DB $19,2,$15,$0E,7,$16,$0D,9,$0A,$13,$0C,$0A,$0B,6,$29,9
		DB $0A,$2E,7,$19,9,$51,9,9,7,5,$18,$18,3,$25,7,8
		DB 8,5,7,7,$14,$12,$0C,6,$12,5,$0C,$12,$1F,$12,$14,$1E
		DB $20,$49,$0C,$0A,$21,7,7,9,$0A,$12,$10,$0F,$0D,$14,$0F,5
		DB 9,6,$0D,$0E,$0B,$0F,$26,2,$0B,4,$19,$0F,$0E,$0F,7,8
		DB $10,8,$0A,$0A,5,$14,3,$13,5,$0D,5,$1B,$1E,8,8,9
		DB 9,9,9,$14,$0A,$11,$12,$13,$1A,$33,$12,8,5,$0A,$17,6
		DB $13,9,5,4,$0E,$0E,$0D,7
