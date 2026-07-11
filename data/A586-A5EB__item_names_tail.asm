; --- INDEX_ITEM_NAMES (tail) @ $A586 -------------------------
; @done
; Continuation of the item-names 5-bit bitstream (INDEX_ITEM_NAMES in
; the previous file, $9CDE-A585): the item-name stream spills past the
; $A585 boundary into these 102 bytes. Confirmed by decoding - without
; them the last ~12 names decode as garbage; with them they resolve to
; 'master Key','wizWand','silvr Square/Circle/Triang','thor Fgn',
; 'old Man Fgn','spectre Snare', etc. Not a separate pool.
; No label (the stream is continuous); INDEX_MONSTER_NAMES starts at the
; next block ($A5EC). Decoded strings are in the items companion:
; data/9B95-9C14__items.decoded.txt (codec dump-pool . items).
		DB $33	; 3
		DB $EB	; л
		DB 1
		DB $A3	; Ј
		DB $92	; ’
		DB $17
		DB $58	; X
		DB $F3	; у
		DB $D2	; Т
		DB $85	; …
		DB 1
		DB $12
		DB 0
		DB $92	; ’
		DB $17
		DB $58	; X
		DB $F3	; у
		DB $C2	; В
		DB $44	; D
		DB $44	; D
		DB $B2	; І
		DB 0
		DB $92	; ’
		DB $17
		DB $58	; X
		DB $F3	; у
		DB $D3	; У
		DB $8A	; Љ
		DB 0
		DB $D3	; У
		DB 0
		DB $99	; ™
		DB $DD	; Э
		DB $1E
		DB $78	; x
		DB $A6	; ¦
		DB $68	; h
		DB $72	; r
		DB $C7	; З
		DB $CF	; П
		DB $30	; 0
		DB $0D
		DB $E7	; з
		DB $8A	; Љ
		DB $66	; f
		DB $80	; Ђ
		DB $93	; “
		DB $C8	; И
		DB $29	; )
		DB $C4	; Д
		DB $9C	; њ
		DB $F4	; ф
		DB $9A	; љ
		DB 8
		DB $90	; ђ
		DB $44	; D
		DB $C8	; И
		DB $C0	; А
		DB $B1	; ±
		DB 0
		DB $F7	; ч
		DB $34	; 4
		DB $91	; ‘
		DB $D0	; Р
		DB $45	; E
		DB $8C	; Њ
		DB 4
		DB $58	; X
		DB $E8	; и
		DB $80	; Ђ
		DB $39	; 9
		DB $16
		DB $C0	; А
		DB $32	; 2
		DB $DD	; Э
		DB $52	; R
		DB $48	; H
		DB $43	; C
		DB $65	; e
		DB $38	; 8
		DB $D1	; С
		DB $84	; „
		DB $6C	; l
		DB $C0	; А
		DB $2A	; *
		DB $0D
		DB $48	; H
		DB $A1	; Ў
		DB $A4	; ¤
		DB $8A	; Љ
		DB $1A
		DB $60	; `
		DB $B0	; °
		DB $1A
		DB $30	; 0
		DB $62	; b
		DB $24	; $
		DB $2D	; -
		DB $F3	; у
		DB $C8	; И
		DB $99	; ™
		DB $18
