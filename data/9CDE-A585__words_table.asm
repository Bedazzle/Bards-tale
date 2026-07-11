; --- words_table ----------------------------------------------
; @done
; 5-bit packed text pool for the 135 main game messages. Each message is
; a bit-packed stream read 5 bits at a time: a code $00-$1C is a letter
; index into the letters rows (lower_letters/upper_letters/digits_more);
; codes $1D/$1E/$1F are SHIFT codes that select the active row
; (lower/upper/digits), $1E being a one-shot upper-case shift (reverts
; after one letter). messages_table gives each message's length in 5-bit symbols
; (offset = sum of earlier lengths * 5/8). Because it is a bitstream the
; messages are NOT byte-aligned, so only the first few carry an inline
; `; NN = text` sample below.
; **All 135 decoded strings: data/9CDE-A585__words_table.decoded.txt**
; (regenerate with `python docs/bardstale_textcodec.py dump-pool . messages`;
; the item-name pool INDEX_ITEM_NAMES continues in this same file below).
; Referenced by: print_msg_A / print_msg_no_cp (de=words_table).
words_table:	DB $B2	; І
		DB $16,$BE,$61,$D4,$8F,$25,$30,$2E,$C0,$8C,$F8,$10,$34,$7C,$FB,$3C,$56,$F5,6,$3C,$F8,$E8,$F3,$EC,$F4,$5B,$DA,$37,$F6 ; 00 = Will	you stalwart
					; band (F)ight or
					; (R)un?
		DB $E7	; з
		DB $9E,$B0,$63,$93,$A3,$48 ; 01 =	Play tune
		DB $91	; ‘
		DB $16,$41,$4F,$8E,$7C,$D0,$E6,$EC ; 02	= Select option.
		DB $A4	; ¤
		DB $89,$C4,$4C,$8C	; 03 = Use item
		DB $93	; “
		DB $C8,$B5,$F2,$6E,$E0,$81,$29,$FE,$A0	; 04 = Spell to	cast:
		DB $10,$25,$3E,2,$7C,$9C ; 05 =	Cast at
		DB $71	; q
		DB $C0	; А
		DB $18
		DB 8
		DB $6F	; o
		DB $B7	; ·
		DB $EE	; о
		DB 0
		DB $99	; ™
		DB $DD	; Э
		DB $4E	; N
		DB $29	; )
		DB $AE	; ®
		DB $B1	; ±
		DB $25	; %
		DB $3E	; >
		DB $35	; 5
		DB $D3	; У
		DB $E4	; д
		DB $CE	; О
		DB 9
		DB $80	; Ђ
		DB $6B	; k
		DB $A7	; §
		DB $C0	; А
		DB $70	; p
		DB $4E	; N
		DB $60	; `
		DB $41	; A
		DB $3E	; >
		DB $49	; I
		DB $E4	; д
		DB $5A	; Z
		DB $FD	; э
		DB $BF	; ї
		DB $70	; p
		DB 4
		DB $E6	; ж
		DB 1
		DB $2B	; +
		DB $80	; Ђ
		DB $A4	; ¤
		DB $89	; ‰
		DB $C9	; Й
		DB $9C	; њ
		DB $92	; ’
		DB $27	; '
		DB 4
		DB $E6	; ж
		DB $30	; 0
		DB $0D
		DB $1C
		DB $BF	; ї
		DB $60	; `
		DB $99	; ™
		DB $C9	; Й
		DB $12
		DB $71	; q
		DB $12
		DB $E0	; а
		DB $D1	; С
		DB $29	; )
		DB $11
		DB $B3	; і
		DB $43	; C
		DB $9B	; ›
		DB $C4	; Д
		DB $37	; 7
		DB $98	; 
		DB $75	; u
		DB $23	; #
		DB $C8	; И
		DB $81	; Ѓ
		DB $AA	; Є
		DB $96	; –
		DB $F6	; ц
		DB $99	; ™
		DB $C9	; Й
		DB $C0	; А
		DB $E7	; з
		DB $B0	; °
		DB $EA	; к
		DB $72	; r
		DB $53	; S
		DB $42	; B
		DB $D7	; Ч
		DB $C2	; В
		DB $80	; Ђ
		DB $44	; D
		DB $FD	; э
		DB $7D	; }
		DB $C0	; А
		DB $C3	; Г
		DB $A9	; ©
		DB $1E
		DB $15
		DB $C4	; Д
		DB $97	; —
		DB $24	; $
		DB $42	; B
		DB $72	; r
		DB $67	; g
		DB $8B	; ‹
		DB $A8	; Ё
		DB $63	; c
		DB $F3	; у
		DB $0E
		DB $A4	; ¤
		DB $78	; x
		DB $85	; …
		DB $AE	; ®
		DB $92	; ’
		DB $43	; C
		DB $9B	; ›
		DB $ED	; н
		DB $FB	; ы
		DB $80	; Ђ
		DB $1B
		DB $B9	; №
		DB $87	; ‡
		DB $53	; S
		DB $96	; –
		DB $44	; D
		DB $8F	; Џ
		DB $C9	; Й
		DB $BB	; »
		DB $82	; ‚
		DB $73	; s
		DB $66	; f
		DB $86	; †
		DB $D0	; Р
		DB $9F	; џ
		DB $B0	; °
		DB 7
		DB 0
		DB $C3	; Г
		DB $A9	; ©
		DB $C1	; Б
		DB 1
		DB $BF	; ї
		DB $A7	; §
		DB $67	; g
		DB $CA	; К
		DB $48	; H
		DB $9C	; њ
		DB $99	; ™
		DB $C1	; Б
		DB $3D	; =
		DB $80	; Ђ
		DB $69	; i
		DB $2D	; -
		DB $CF	; П
		DB $3A	; :
		DB $23	; #
		DB $24	; $
		DB $7F	; 
		DB $5F	; _
		DB $70	; p
		DB $93	; “
		DB $FC	; ь
		DB $F9	; щ
		DB $FE	; ю
		DB $A0	;  
		DB $11
		DB $DC	; Ь
		DB $E9	; й
		DB $13
		DB $F5	; х
		DB $C3	; Г
		DB $FC	; ь
		DB $4C	; L
		DB $FA	; ъ
		DB $79	; y
		DB $F0	; р
		DB $F3	; у
		DB $E7	; з
		DB $C0	; А
		DB $9C	; њ
		DB $40	; @
		DB $32	; 2
		DB $73	; s
		DB $C6	; Ж
		DB $72	; r
		DB $C7	; З
		DB $ED	; н
		DB 0
		DB $9B	; ›
		DB $B9	; №
		DB $EB	; л
		DB $1D
		DB $DF	; Я
		DB $B0	; °
		DB $1C
		DB $5C	; \
		DB $FE	; ю
		DB $79	; y
		DB $13
		DB $23	; #
		DB 0
		DB $99	; ™
		DB $C1	; Б
		DB $3F	; ?
		DB $D3	; У
		DB $B2	; І
		DB $E1	; б
		DB $21	; !
		DB $44	; D
		DB $3D	; =
		DB $E4	; д
		DB $1F
		DB $B6	; ¶
		DB $24	; $
		DB $28	; (
		DB $87	; ‡
		DB $F3	; у
		DB $E0	; а
		DB $C7	; З
		DB $5D	; ]
		DB $10
		DB 2
		DB $D7	; Ч
		DB $C2	; В
		DB $D1	; С
		DB $6B	; k
		DB $F6	; ц
		DB $C0	; А
		DB $6B	; k
		DB $A7	; §
		DB $C2	; В
		DB $35	; 5
		DB $D4	; Ф
		DB $31	; 1
		DB $F8	; ш
		DB $1B
		DB $9A	; љ
		DB $4F	; O
		DB $6C	; l
		DB $93	; “
		DB $A2	; ў
		DB $2F	; /
		DB $D7	; Ч
		DB $18
		DB $C6	; Ж
		DB $3C	; <
		DB $2E	; .
		DB $B9	; №
		DB $A9	; ©
		DB $FD	; э
		DB $71	; q
		DB $EE	; о
		DB $79	; y
		DB $9D	; ќ
		DB 1
		DB $91	; ‘
		DB $FA	; ъ
		DB $E3	; г
		DB $18
		DB $C7	; З
		DB $AD	; ­
		DB $D4	; Ф
		DB $64	; d
		DB $7F	; 
		DB $A8	; Ё
		DB $B1	; ±
		DB $DD	; Э
		DB $CB	; Л
		DB $21	; !
		DB $6B	; k
		DB $E0	; а
		DB $39	; 9
		DB $38	; 8
		DB $89	; ‰
		DB $71	; q
		DB $AE	; ®
		DB $9F	; џ
		DB 0
		DB $39	; 9
		DB $38	; 8
		DB $70	; p
		DB $4B	; K
		DB $8B	; ‹
		DB $74	; t
		DB $A7	; §
		DB $C3	; Г
		DB $A2	; ў
		DB $5C	; \
		DB $AB	; «
		DB $90	; ђ
		DB $22	; "
		DB $7B	; {
		DB $7C	; |
		DB $F4	; ф
		DB $E3	; г
		DB $8E	; Ћ
		DB 3
		DB $82	; ‚
		DB $73	; s
		DB $97	; —
		DB $C1	; Б
		DB $C5	; Е
		DB $0D
		DB $56	; V
		DB $F7	; ч
		DB $BF	; ї
		DB $70	; p
		DB $A4	; ¤
		DB $89	; ‰
		DB $C7	; З
		DB $37	; 7
		DB $80	; Ђ
		DB $99	; ™
		DB $C1	; Б
		DB $3F	; ?
		DB $D3	; У
		DB $B2	; І
		DB $E1	; б
		DB $5D	; ]
		DB $1E
		DB 9
		DB $CC	; М
		DB 8
		DB $27	; '
		DB $C7	; З
		DB $35	; 5
		DB $78	; x
		DB $D8	; Ш
		DB $C3	; Г
		DB $A9	; ©
		DB $C2	; В
		DB $80	; Ђ
		DB $44	; D
		DB $E0	; а
		DB $99	; ™
		DB $16
		DB $47	; G
		DB $BA	; є
		DB $33	; 3
		DB $F7	; ч
		DB $3E	; >
		DB $FF
		DB $53	; S
		DB $B2	; І
		DB $27	; '
		DB 1
		DB $18
		DB $BA	; є
		DB $DC	; Ь
		DB $51	; Q
		DB $31	; 1
		DB $2E	; .
		DB 1
		DB $A3	; Ј
		DB $E7	; з
		DB $A5	; Ґ
		DB $E7	; з
		DB $F8	; ш
		DB $5C	; \
		DB $9B	; ›
		DB $B9	; №
		DB $22	; "
		DB $2C	; ,
		DB $82	; ‚
		DB $9F	; џ
		DB $E1	; б
		DB $EE	; о
		DB $7B	; {
		DB $9E	; ћ
		DB $6F	; o
		DB $5D	; ]
		DB $19
		DB $9F	; џ
		DB $F5	; х
		DB $C4	; Д
		DB $BD	; Ѕ
		DB $CF	; П
		DB $13
		DB $A0	;  
		DB $94	; ”
		DB $F9	; щ
		DB $FA	; ъ
		DB $E2	; в
		DB $5E	; ^
		DB $E0	; а
		DB $1B
		DB $AC	; ¬
		DB $DE	; Ю
		DB $7E	; ~
		DB $B8	; ё
		DB $90	; ђ
		DB $A3	; Ј
		DB $F9	; щ
		DB $CE	; О
		DB $7E	; ~
		DB $B8	; ё
		DB $90	; ђ
		DB 0
		DB $5D	; ]
		DB $19
		DB $FE	; ю
		DB $C0	; А
		DB $97	; —
		DB $DB	; Ы
		DB $EE	; о
		DB 0
		DB $99	; ™
		DB $C9	; Й
		DB $C7	; З
		DB $82	; ‚
		DB $33	; 3
		DB $C7	; З
		DB 6
		DB $89	; ‰
		DB 4
		DB $8B	; ‹
		DB $41	; A
		DB $2A	; *
		DB $49	; I
		DB $6F	; o
		DB $7B	; {
		DB $20
		DB 4
		DB $7E	; ~
		DB 8
		DB $E0	; а
		DB $88	; €
		DB 5
		DB $32	; 2
		DB $47	; G
		DB $91	; ‘
		DB $20
		DB $88	; €
		DB $8A	; Љ
		DB $92	; ’
		DB $5C	; \
		DB $73	; s
		DB $48	; H
		DB $94	; ”
		DB $FF
		DB $5C	; \
		DB $63	; c
		DB $1E
		DB $47	; G
		DB $A1	; Ў
		DB $5C	; \
		DB $63	; c
		DB $1E
		DB $1F
		DB $6F	; o
		DB $FA	; ъ
		DB $E3	; г
		DB $C2	; В
		DB $EB	; л
		DB $7F	; 
		DB $5C	; \
		DB $63	; c
		DB $1E
		DB $5F	; _
		DB $55	; U
		DB $FA	; ъ
		DB $80	; Ђ
		DB $28	; (
		DB 4
		DB $86	; †
		DB $9B	; ›
		DB $80	; Ђ
		DB $88	; €
		DB 4
		DB $4F	; O
		DB $D7	; Ч
		DB $18
		DB $12
		DB $C1	; Б
		DB $29	; )
		DB $7E	; ~
		DB $B8	; ё
		DB $5D	; ]
		DB $57	; W
		DB $FA	; ъ
		DB $80	; Ђ
		DB $25	; %
		DB $DE	; Ю
		DB $48	; H
		DB $FE	; ю
		DB $A0	;  
		DB $33	; 3
		DB $96	; –
		DB $3E	; >
		DB $7E	; ~
		DB $A0	;  
		DB $E7	; з
		DB $9F	; џ
		DB $12
		DB $4A	; J
		DB $5C	; \
		DB $F0	; р
		DB $1B
		DB $8E	; Ћ
		DB $79	; y
		DB $44	; D
		DB $C6	; Ж
		DB $F7	; ч
		DB $B0	; °
		DB $E7	; з
		DB $D9	; Щ
		DB $E7	; з
		DB $B7	; ·
		DB $A0	;  
		DB $8C	; Њ
		DB $F1	; с
		DB $C0	; А
		DB $4E	; N
		DB $60	; `
		DB $12
		DB $80	; Ђ
		DB $E7	; з
		DB $D9	; Щ
		DB $E1	; б
		DB $B7	; ·
		DB $A4	; ¤
		DB $29	; )
		DB $1A
		DB $30	; 0
		DB $D7	; Ч
		DB 0
		DB $D1	; С
		DB $F0	; р
		DB $D7	; Ч
		DB 3
		DB $49	; I
		DB $F1	; с
		DB $88	; €
		DB $94	; ”
		DB $89	; ‰
		DB $2F	; /
		DB $6F	; o
		DB $DC	; Ь
		DB $F7	; ч
		DB 0
		DB $D7	; Ч
		DB $A5	; Ґ
		DB $F8	; ш
		DB 0
		DB $89	; ‰
		DB $2C	; ,
		DB $86	; †
		DB $8F	; Џ
		DB $93	; “
		DB 3
		DB $C9	; Й
		DB $B0	; °
		DB $43	; C
		DB $64	; d
		DB $48	; H
		DB $CF	; П
		DB $8F	; Џ
		DB 4
		DB $67	; g
		DB $8E	; Ћ
		DB $4C	; L
		DB $0F
		DB $26	; &
		DB $C0	; А
		DB $7C	; |
		DB $49	; I
		DB $29	; )
		DB $73	; s
		DB $D1	; С
		DB $F1	; с
		DB $3C	; <
		DB $2F	; /
		DB $3B	; ;
		DB $D1	; С
		DB $F0	; р
		DB $FE	; ю
		DB $AF	; Ї
		DB $3F	; ?
		DB $CB	; Л
		DB $F0	; р
		DB $3D	; =
		DB $88	; €
		DB $FB	; ы
		DB $80	; Ђ
		DB $28	; (
		DB $25	; %
		DB $3E	; >
		DB $15
		DB $D1	; С
		DB $B0	; °
		DB $22	; "
		DB $3E	; >
		DB $4C	; L
		DB $0F
		DB $26	; &
		DB $C0	; А
		DB $9F	; џ
		DB $81	; Ѓ
		DB $E7	; з
		DB $F8	; ш
		DB $9C	; њ
		DB $F1	; с
		DB $3D	; =
		DB $1F
		DB $47	; G
		DB $CE	; О
		DB $F4	; ф
		DB $7D	; }
		DB $B0	; °
		DB $43	; C
		DB $64	; d
		DB $48	; H
		DB $CF	; П
		DB $9E	; ћ
		DB $92	; ’
		DB $81	; Ѓ
		DB $10
		DB $7D	; }
		DB $5E	; ^
		DB $1F
		DB $68	; h
		DB $D3	; У
		DB $11
		DB $CD	; Н
		DB $E4	; д
		DB $C0	; А
		DB $F2	; т
		DB $70	; p
		DB $E7	; з
		DB $B9	; №
		DB $E7	; з
		DB $C4	; Д
		DB $92	; ’
		DB $97	; —
		DB $1E
		DB $B0	; °
		DB $63	; c
		DB $93	; “
		DB $39	; 9
		DB $1B
		DB $C3	; Г
		DB $A2	; ў
		DB $7C	; |
		DB 7
		DB $14
		DB $4C	; L
		DB $6F	; o
		DB $7B	; {
		DB $71	; q
		DB $F8	; ш
		DB $32	; 2
		DB 2
		DB $3E	; >
		DB $DF	; Я
		DB $3D	; =
		DB $87	; ‡
		DB $52	; R
		DB $3C	; <
		DB $30	; 0
		DB $1A
		DB $6E	; n
		DB $1C
		DB $13
		DB $3F	; ?
		DB 4
		DB $40	; @
		DB $48	; H
		DB $83	; ѓ
		DB $E4	; д
		DB $DD	; Э
		DB $C0	; А
		DB $93	; “
		DB $7B	; {
		DB $DF	; Я
		DB $B9	; №
		DB $EE	; о
		DB $79	; y
		DB $F1	; с
		DB $24	; $
		DB $A5	; Ґ
		DB $C0	; А
		DB $71	; q
		DB $44	; D
		DB $C7	; З
		DB $26	; &
		DB $EE	; о
		DB $4A	; J
		DB $60	; `
		DB $8C	; Њ
		DB $F8	; ш
		DB 3
		DB 1
		DB $0D
		DB $D8	; Ш
		DB $F8	; ш
		DB $73	; s
		DB $8E	; Ћ
		DB $C9	; Й
		DB 3
		DB $27	; '
		DB $3C	; <
		DB $10
		DB $F8	; ш
		DB $B3	; і
		DB $8E	; Ћ
		DB $C9	; Й
		DB 3
		DB $27	; '
		DB 0
		DB $19
		DB 1
		DB $33	; 3
		DB $F1	; с
		DB $13
		DB $91	; ‘
		DB $16
		DB $5F	; _
		DB $6B	; k
		DB $88	; €
		DB $6F	; o
		DB $26	; &
		DB $72	; r
		DB $70	; p
		DB $AE	; ®
		DB $8B	; ‹
		DB $38	; 8
		DB $E2	; в
		DB $FE	; ю
		DB $BE	; ѕ
		DB $E0	; а
		DB $E7	; з
		DB $D8	; Ш
		DB $15
		DB $19
		DB $A0	;  
		DB $E7	; з
		DB $D8	; Ш
		DB $15
		DB $21	; !
		DB $A0	;  
		DB $E7	; з
		DB $D9	; Щ
		DB $EC	; м
		DB $2B	; +
		DB $CD	; Н
		DB $68	; h
		DB $E4	; д
		DB $9E	; ћ
		DB $45	; E
		DB $AF	; Ї
		DB $DB	; Ы
		DB $F7	; ч
		DB 0
		DB $FB	; ы
		DB $FA	; ъ
		DB $4B	; K
		DB $CF	; П
		DB $F0	; р
		DB $C7	; З
		DB $66	; f
		DB $EE	; о
		DB 0
		DB $2E	; .
		DB $8C	; Њ
		DB $C0	; А
		DB $FB	; ы
		DB $3C	; <
		DB 6
		DB $F6	; ц
		DB $73	; s
		DB 0
		DB $95	; •
		DB $C2	; В
		DB $B8	; ё
		DB $92	; ’
		DB $FB	; ы
		DB $3C	; <
		DB $26	; &
		DB $F4	; ф
		DB $12
		DB $9F	; џ
		DB $24	; $
		DB $F2	; т
		DB $2D	; -
		DB $60	; `
		DB $FB	; ы
		DB $3D	; =
		DB $46	; F
		DB $F6	; ц
		DB $44	; D
		DB $E2	; в
		DB $26	; &
		DB $46	; F
		DB 0
		DB $FB	; ы
		DB $3C	; <
		DB $76	; v
		DB $F5	; х
		DB 3
		DB $27	; '
		DB $10
		DB $DE	; Ю
		DB $48	; H
		DB $E0	; а
		DB $1B
		DB $AD	; ­
		DB $20
		DB $FB	; ы
		DB $3C	; <
		DB $16
		DB $F4	; ф
		DB $11
		DB $1F
		DB $3D	; =
		DB $27	; '
		DB $34	; 4
		DB $C0	; А
		DB $3A	; :
		DB $27	; '
		DB $2E	; .
		DB 0
		DB $3A	; :
		DB $27	; '
		DB $2E	; .
		DB $15
		DB $D1	; С
		DB $E0	; а
		DB $7A	; z
		DB $C1	; Б
		DB $8F	; Џ
		DB $D8	; Ш
		DB $A4	; ¤
		DB $89	; ‰
		DB $C0	; А
		DB $37	; 7
		DB $88	; €
		DB $99	; ™
		DB $19
		DB $FB	; ы
		DB 0
		DB $10
		DB $25	; %
		DB $3E	; >
		DB 3
		DB $92	; ’
		DB $79	; y
		DB $16
		DB $BF	; ї
		DB $D8	; Ш
		DB $E4	; д
		DB $D0	; Р
		DB $C2	; В
		DB $4B	; K
		DB $85	; …
		DB $74	; t
		DB $78	; x
		DB $E3	; г
		DB 8
		DB $C0	; А
		DB $92	; ’
		DB $3C	; <
		DB $E7	; з
		DB $39	; 9
		DB $F7	; ч
		DB $85	; …
		DB $40	; @
		DB $E1	; б
		DB $C1	; Б
		DB $2E	; .
		DB $4C	; L
		DB $E4	; д
		DB $91	; ‘
		DB $38	; 8
		DB $E7	; з
		DB $CD	; Н
		DB $0E
		DB $6C	; l
		DB $B9	; №
		DB $33	; 3
		DB $A2	; ў
		DB $5C	; \
		DB 8
		DB $27	; '
		DB $35	; 5
		DB $93	; “
		DB $91	; ‘
		DB $75	; u
		DB $1A
		DB $3F	; ?
		DB $D4	; Ф
		DB $FC	; ь
		DB 0
		DB $34	; 4
		DB $5D	; ]
		DB $47	; G
		DB $FB	; ы
		DB $9F	; џ
		DB $7F	; 
		DB $80	; Ђ
		DB $E3	; г
		DB $A3	; Ј
		DB $C0	; А
		DB $3B	; ;
		DB $A5	; Ґ
		DB $34	; 4
		DB $2C	; ,
		DB $9C	; њ
		DB $78	; x
		DB $23	; #
		DB $3C	; <
		DB $71	; q
		DB $84	; „
		DB $60	; `
		DB $49	; I
		DB $19
		DB $7B	; {
		DB $7E	; ~
		DB $E0	; а
		DB $E0	; а
		DB 7
		DB $50	; P
		DB $34	; 4
		DB $44	; D
		DB $D4	; Ф
		DB $BD	; Ѕ
		DB $BD	; Ѕ
		DB $7B	; {
		DB $60	; `
		DB $E3	; г
		DB 0
		DB $A2	; ў
		DB $4B	; K
		DB $80	; Ђ
		DB $E2	; в
		DB $D0	; Р
		DB $63	; c
		DB $CC	; М
		DB $E0	; а
		DB $81	; Ѓ
		DB $29	; )
		DB $CB	; Л
		DB $80	; Ђ
		DB $E4	; д
		DB $9E	; ћ
		DB $45	; E
		DB $AF	; Ї
		DB $80	; Ђ
		DB $E0	; а
		DB $8E	; Ћ
		DB $E7	; з
		DB $CB	; Л
		DB $80	; Ђ
		DB $E4	; д
		DB $AC	; ¬
		DB $86	; †
		DB $9A	; љ
		DB $5C	; \
		DB $93	; “
		DB $C8	; И
		DB $B5	; µ
		DB $F1	; с
		DB $EE	; о
		DB $43	; C
		DB $67	; g
		DB $2F	; /
		DB $6F	; o
		DB $DC	; Ь
		DB $7B	; {
		DB $90	; ђ
		DB $D9	; Щ
		DB $EB	; л
		DB $52	; R
		DB $E3	; г
		DB $8B	; ‹
		DB $C1	; Б
		DB $81	; Ѓ
		DB $80	; Ђ
		DB $31	; 1
		DB 0
		DB $E1	; б
		DB $D0	; Р
		DB $CF	; П
		DB $6F	; o
		DB $DC	; Ь
		DB $F7	; ч
		DB 0
		DB $DF	; Я
		DB $B9	; №
		DB $EE	; о
		DB 0
		DB $0D
		DB $27	; '
		DB $C4	; Д
		DB $4F	; O
		DB $85	; …
		DB $46	; F
		DB $72	; r
		DB $B2	; І
		DB $0F
		DB $DB	; Ы
		DB $F7	; ч
		DB $3D	; =
		DB $C0	; А
		DB 4
		DB $F8	; ш
		DB 4
		DB $F9	; щ
		DB $33	; 3
		DB $93	; “
		DB $8F	; Џ
		DB 4
		DB $67	; g
		DB $8D	; Ќ
		DB $EF	; п
		DB $7E	; ~
		DB $E7	; з
		DB $B8	; ё
		DB $93	; “
		DB $98	; 
		DB $4E	; N
		DB 0
		DB $E4	; д
		DB $48	; H
		DB $F2	; т
		DB $2D	; -
		DB $64	; d
		DB $1F
		DB $26	; &
		DB $72	; r
		DB 0
		DB $E0	; а
		DB $1A
		DB $3E	; >
		DB 0
		DB $E0	; а
		DB $69	; i
		DB $3E	; >
		DB $22	; "
		DB $7C	; |
		DB $38	; 8
		DB 7
		DB $C6	; Ж
		DB $BB	; »
		DB $84	; „
		DB $29	; )
		DB $48	; H
		DB $29	; )
		DB $FB	; ы
		DB $7E	; ~
		DB $E7	; з
		DB $B8	; ё
		DB 3
		DB $47	; G
		DB $C9	; Й
		DB $9C	; њ
		DB $9C	; њ
		DB $78	; x
		DB $23	; #
		DB $3C	; <
		DB $71	; q
		DB $88	; €
		DB $94	; ”
		DB $89	; ‰
		DB $2E	; .
		DB 1
		DB $BC	; ј
		DB 4
		DB $E6	; ж
		DB 1
		DB $28	; (
		DB $E0	; а
		DB $1E
		DB $F2	; т
		DB 2
		DB $32	; 2
		DB 3
		DB $47	; G
		DB $C0	; А
		DB $44	; D
		DB $9C	; њ
		DB $E2	; в
		DB $C9	; Й
		DB $52	; R
		DB $2F	; /
		DB $5A	; Z
		DB $90	; ђ
		DB $E0	; а
		DB $48	; H
		DB $B7	; ·
		DB $5B	; [
		DB $DA	; Ъ
		DB $E0	; а
		DB $E0	; а
		DB 2
		DB $EA	; к
		DB $93	; “
		DB $DA	; Ъ
		DB $E0	; а
		DB $94	; ”
		DB $28	; (
		DB 8
		DB $93	; “
		DB $5A	; Z
		DB $90	; ђ
		DB $71	; q
		DB $79	; y
		DB $33	; 3
		DB $93	; “
		DB $84	; „
		DB $6C	; l
		DB $E3	; г
		DB $8E	; Ћ
		DB $4A	; J
		DB $60	; `
		DB $44	; D
		DB $65	; e
		DB $B0	; °
		DB $E0	; а
		DB $62	; b
		DB $40	; @
		DB $4C	; L
		DB $E4	; д
		DB $97	; —
		DB 0
		DB $E2	; в
		DB $1B
		DB $CF	; П
		DB $49	; I
		DB $40	; @
		DB $88	; €
		DB $39	; 9
		DB $E0	; а
		DB $C4	; Д
		DB 4
		DB $D8	; Ш
		DB $E3	; г
		DB $D6	; Ц
		DB $0C
		DB $4B	; K
		DB $80	; Ђ
		DB $E4	; д
		DB $E8	; и
		DB $D2	; Т
		DB $6F	; o
		DB $7B	; {
		DB $F7	; ч
		DB 0
		DB $E2	; в
		DB $DD	; Э
		DB $29	; )
		DB $F0	; р
		DB $E8	; и
		DB $97	; —
		DB $2A	; *
		DB $E4	; д
		DB 8
		DB $9E	; ћ
		DB $DF	; Я
		DB $B8	; ё
		DB $E2	; в
		DB $68	; h
		DB $C7	; З
		DB $CB	; Л
		DB $88	; €
		DB $6C	; l
		DB $DD	; Э
		DB $CC	; М
		DB $3A	; :
		DB $91	; ‘
		DB $E3	; г
		DB $C1	; Б
		DB $19
		DB $E3	; г
		DB $DB	; Ы
		DB $F7	; ч
		DB 0
		DB $E1	; б
		DB $2E	; .
		DB $F2	; т
		DB $45	; E
		DB 4
		DB $68	; h
		DB $89	; ‰
		DB $C7	; З
		DB $B9	; №
		DB $0D
		DB $9C	; њ
		DB $B8	; ё
		DB $57	; W
		DB $47	; G
		DB $95	; •
		DB 2
		DB $DD	; Э
		DB $1E
		DB 1
		DB $A3	; Ј
		DB $E0	; а
		DB $41	; A
		DB $39	; 9
		DB $AC	; ¬
		DB $9C	; њ
		DB $53	; S
		DB $5D	; ]
		DB $65	; e
		DB $90	; ђ
		DB $66	; f
		DB $27	; '
		DB $B4	; ґ
		DB $E3	; г
		DB $D0	; Р
		DB $41	; A
		DB $12
		DB $5C	; \
		DB $71	; q
		DB $78	; x
		DB $67	; g
		DB $2C	; ,
		DB $7B	; {
		DB $F7	; ч
		DB 0
		DB $E1	; б
		DB $5D	; ]
		DB $46	; F
		DB $8F	; Џ
		DB $80	; Ђ
		DB $33	; 3
		DB $96	; –
		DB $3D	; =
		DB $80	; Ђ
		DB 7
		DB 2
		DB 8
		DB $8F	; Џ
		DB $DB	; Ы
		DB $F7	; ч
		DB 0
		DB $A4	; ¤
		DB $90	; ђ
		DB $D3	; У
		DB $70	; p
		DB $0D
		DB $E2	; в
		DB $1B
		DB $29	; )
		DB $C6	; Ж
		DB $8C	; Њ
		DB $23	; #
		DB $67	; g
		DB $ED	; н
		DB $FB	; ы
		DB $80	; Ђ
		DB 3
		DB $47	; G
		DB $C0	; А
		DB $70	; p
		DB $E0	; а
		DB $1A
		DB $3E	; >
		DB 6
		DB $91	; ‘
		DB $6C	; l
		DB $B8	; ё
		DB $74	; t
		DB $33	; 3
		DB $85	; …
		DB $74	; t
		DB $78	; x
		DB $E1	; б
		DB $D0	; Р
		DB $CE	; О
		DB $15
		DB $D1	; С
		DB $E0	; а
		DB $E1	; б
		DB $5D	; ]
		DB $1E
		DB 0
		DB $E2	; в
		DB $25	; %
		DB $C0	; А
		DB $FB	; ы
		DB $BD	; Ѕ
		DB $2E	; .
		DB $AD	; ­
		DB $D6	; Ц
		DB $24	; $
		DB $7F	; 
		DB $7F	; 
		DB $70	; p
		DB $FB	; ы
		DB $BC,$5E,$82,$53,$24,$7F,$7F,$70 ; 84	= <Faster>
		DB $FB	; ы
		DB $BC,$FE,$82,$92,$43,$4D,$FB ;	85 = <Pausing>
		DB $80	; Ђ
		DB $DE	; Ю
		DB $F7	; ч
		DB $EE	; о
		DB $7B	; {
		DB $80	; Ђ

; --- INDEX_ITEM_NAMES ------------------------------------------
; @done
; 5-bit packed text pool for the 127 item names, same bit-packed format
; as words_table (letter codes $00-$1C, dictionary-word codes >=$1D). The
; INDEX_ITEM_LENGTHS table gives each name's bit offset.
; **All 127 decoded strings: data/9B95-9C14__items.decoded.txt**
; (regenerate: `python docs/bardstale_textcodec.py dump-pool . items`).
; Referenced by: set_item_tables (BT_game) -> print_msg_no_cp
;               (de=INDEX_ITEM_NAMES).
INDEX_ITEM_NAMES:

		DB $9B	; ›
		DB $A2	; ў
		DB $23	; #
		DB $80	; Ђ


		DB $58	; X
		DB $18
		DB $F0	; р
		DB $0C
		DB $5C	; \
		DB 1
		DB $CA	; К
		DB $CE	; О
		DB $88	; €
		DB $C0	; А
		DB $91	; ‘
		DB $DD	; Э
		DB $19
		DB $F3	; у
		DB $D2	; Т
		DB $B3	; і
		DB $A2	; ў
		DB $30	; 0
		DB $18
		DB $0C
		DB $62	; b
		DB $44	; D
		DB $B0	; °
		DB $23	; #
		DB $CF	; П
		DB 2
		DB $E4	; д
		DB $38	; 8
		DB $16
		DB $10
		DB $44	; D
		DB $60	; `
		DB $60	; `
		DB 4
		DB $40	; @
		DB $94	; ”
		DB $C0	; А
		DB $52	; R
		DB $80	; Ђ
		DB $0D
		DB 4
		DB $A5	; Ґ
		DB $92	; ’
		DB $20
		DB $9B	; ›
		DB $AC	; ¬
		DB $48	; H
		DB $F3	; у
		DB $D2	; Т
		DB $3A	; :
		DB 8
		DB $B1	; ±
		DB $80	; Ђ
		DB $59	; Y
		DB 1
		DB $33	; 3
		DB $92	; ’
		DB $3C	; <
		DB $F0	; р
		DB $22	; "
		DB $C7	; З
		DB $44	; D
		DB $11
		DB $C0	; А
		DB $86	; †
		DB $F3	; у
		DB $CC	; М
		DB 2
		DB $16
		DB $90	; ђ
		DB $80	; Ђ
		DB $B2	; І
		DB $73	; s
		DB $C0	; А
		DB $8B	; ‹
		DB $1D
		DB $10
		DB $7A	; z
		DB $C1	; Б
		DB $32	; 2
		DB $73	; s
		DB $C0	; А
		DB $8B	; ‹
		DB $1D
		DB $10
		DB $8B	; ‹
		DB $82	; ‚
		DB $49	; I
		DB 0
		DB $39	; 9
		DB $16
		DB $C0	; А
		DB $59	; Y
		DB 1
		DB $33	; 3
		DB $92	; ’
		DB $3C	; <
		DB $F1	; с
		DB $96	; –
		DB $EA	; к
		DB $92	; ’
		DB $40	; @
		DB $30	; 0
		DB $28	; (
		DB $D9	; Щ
		DB $AC	; ¬
		DB $93	; “
		DB $90	; ђ
		DB $60	; `
		DB $1A
		DB $37	; 7
		DB $2D	; -
		DB $0D
		DB $38	; 8
		DB $22	; "
		DB $F0	; р
		DB $2A	; *
		DB $E9	; й
		DB $32	; 2
		DB 0
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $7A	; z
		DB $56	; V
		DB $74	; t
		DB $46	; F
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $7A	; z
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $78	; x
		DB $47	; G
		DB 2
		DB $1A
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $7A	; z
		DB $42	; B
		DB 2
		DB $C8	; И
		DB $90	; ђ
		DB $19
		DB $48	; H
		DB $81	; Ѓ
		DB $1C
		DB $F1	; с
		DB $4C	; L
		DB $D0	; Р
		DB $0C
		DB $40	; @
		DB $22	; "
		DB $46	; F
		DB $5C	; \
		DB $FB	; ы
		DB $CD	; Н
		DB 0
		DB 8
		DB $22	; "
		DB $39	; 9
		DB $59	; Y
		DB $D1	; С
		DB $18
		DB $2A	; *
		DB $22	; "
		DB $4E	; N
		DB $78	; x
		DB $EE	; о
		DB $8B	; ‹
		DB $40	; @
		DB $5A	; Z
		DB $0C
		DB $79	; y
		DB $D8	; Ш
		DB $0D
		DB $18
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $78	; x
		DB $60	; `
		DB $31	; 1
		DB $89	; ‰
		DB $10
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $78	; x
		DB $E4	; д
		DB $5B	; [
		DB 0
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $78	; x
		DB $CB	; Л
		DB $75	; u
		DB $49	; I
		DB $20
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $78	; x
		DB $17
		DB $20
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $79	; y
		DB $80	; Ђ
		DB $11
		DB 0
		DB $64	; d
		DB $CF	; П
		DB $1E
		DB $79	; y
		DB $EB	; л
		DB 4
		DB $C8	; И
		DB $71	; q
		DB $A2	; ў
		DB $4E	; N
		DB $78	; x
		DB $A6	; ¦
		DB $68	; h
		DB $58	; X
		DB $15
		DB $FA	; ъ
		DB $76	; v
		DB $5C	; \
		DB $F2	; т
		DB $F1	; с
		DB $12
		DB 0
		DB $91	; ‘
		DB $D0	; Р
		DB $45	; E
		DB $8F	; Џ
		DB $9E	; ћ
		DB $8A	; Љ
		DB $1A
		DB $60	; `
		DB $1B
		DB $A2	; ў
		DB $AE	; ®
		DB $7A	; z
		DB $28	; (
		DB $69	; i
		DB $80	; Ђ
		DB $2A	; *
		DB $1B
		DB $FA	; ъ
		DB $76	; v
		DB $5C	; \
		DB $F1	; с
		DB $57	; W
		DB $49	; I
		DB $90	; ђ
		DB $50	; P
		DB 8
		DB $BF	; ї
		DB $D3	; У
		DB $B2	; І
		DB $E7	; з
		DB $81	; Ѓ
		DB $72	; r
		DB 0
		DB $0A
		DB $DC	; Ь
		DB $E1	; б
		DB $F3	; у
		DB $C0	; А
		DB $B9	; №
		DB 0
		DB $18
		DB $30	; 0
		DB $15
		DB $80	; Ђ
		DB $64	; d
		DB $91	; ‘
		DB $D0	; Р
		DB $45	; E
		DB $8F	; Џ
		DB $9E	; ћ
		DB $94	; ”
		DB $C0	; А
		DB $52	; R
		DB $80	; Ђ
		DB $22	; "
		DB $CB	; Л
		DB $CF	; П
		DB 9
		DB $6E	; n
		DB 2
		DB $80	; Ђ
		DB $38	; 8
		DB $2C	; ,
		DB $A0	;  
		DB $AC	; ¬
		DB 3
		DB $20
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $7A	; z
		DB $56	; V
		DB $74	; t
		DB $46	; F
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $7A	; z
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $78	; x
		DB $60	; `
		DB $31	; 1
		DB $89	; ‰
		DB $10
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $78	; x
		DB $E4	; д
		DB $5B	; [
		DB 0
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $78	; x
		DB $CB	; Л
		DB $75	; u
		DB $49	; I
		DB $20
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $79	; y
		DB $80	; Ђ
		DB $11
		DB 0
		DB $0C
		DB $5C	; \
		DB $E6	; ж
		DB 0
		DB $7D	; }
		DB $22	; "
		DB $40	; @
		DB $AC	; ¬
		DB 3
		DB $20
		DB $25	; %
		DB $DD	; Э
		DB $1B
		DB 1
		DB $A3	; Ј
		DB 2
		DB $D1	; С
		DB $FA	; ъ
		DB $76	; v
		DB $5C	; \
		DB $F0	; р
		DB $81	; Ѓ
		DB $17
		DB $92	; ’
		DB $60	; `
		DB $60	; `
		DB $0C
		DB $81	; Ѓ
		DB $73	; s
		DB $CC	; М
		DB $75	; u
		DB $26	; &
		DB $70	; p
		DB $5D	; ]
		DB 4
		DB $A9	; ©
		DB $1D
		DB 4
		DB $58	; X
		DB $C0	; А
		DB $32	; 2
		DB 0
		DB $D9	; Щ
		DB $F3	; у
		DB $C5	; Е
		DB $33	; 3
		DB $40	; @
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $78	; x
		DB $47	; G
		DB 2
		DB $1A
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $7A	; z
		DB $42	; B
		DB 2
		DB $C8	; И
		DB 0
		DB $D9	; Щ
		DB $3E	; >
		DB $79	; y
		DB $EB	; л
		DB 4
		DB $C8	; И
		DB $0C
		DB $40	; @
		DB $22	; "
		DB $46	; F
		DB $5C	; \
		DB $FB	; ы
		DB $C9	; Й
		DB 0
		DB 4
		DB $45	; E
		DB $23	; #
		DB $A0	;  
		DB $8B	; ‹
		DB $18
		DB $7D	; }
		DB $22	; "
		DB $4E	; N
		DB $7A	; z
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB $60	; `
		DB $0C
		DB $4E	; N
		DB $7A	; z
		DB $53	; S
		DB 1
		DB $4A	; J
		DB $B0	; °
		DB $23	; #
		DB $CF	; П
		DB $4A	; J
		DB $60	; `
		DB $29	; )
		DB $40	; @
		DB $99	; ™
		DB $D0	; Р
		DB $42	; B
		DB $F3	; у
		DB $C3	; Г
		DB 1
		DB $8C	; Њ
		DB $48	; H
		DB $80	; Ђ
		DB $93	; “
		DB $A8	; Ё
		DB $BE	; ѕ
		DB $79	; y
		DB $80	; Ђ
		DB $11
		DB 0
		DB $B2	; І
		DB $26	; &
		DB $72	; r
		DB $47	; G
		DB $9E	; ћ
		DB $94	; ”
		DB $C0	; А
		DB $52	; R
		DB $80	; Ђ
		DB $93	; “
		DB $A2	; ў
		DB $22	; "
		DB $46	; F
		DB $53	; S
		DB 1
		DB $4A	; J
		DB $95	; •
		DB $9D	; ќ
		DB $11
		DB $F1	; с
		DB $C5	; Е
		DB $E7	; з
		DB $9E	; ћ
		DB 5
		DB 0
		DB $39	; 9
		DB 0
		DB $BE	; ѕ
		DB $78	; x
		DB $E0	; а
		DB $8B	; ‹
		DB $C0	; А
		DB $30	; 0
		DB $17
		DB $3F	; ?
		DB $D3	; У
		DB $B2	; І
		DB $E7	; з
		DB $8A	; Љ
		DB $BA	; є
		DB $4C	; L
		DB $80	; Ђ
		DB $2C	; ,
		DB $5D	; ]
		DB $29	; )
		DB $F3	; у
		DB $C7	; З
		DB $74	; t
		DB $5A	; Z
		DB $1B
		DB $1A
		DB $3E	; >
		DB $7A	; z
		DB $56	; V
		DB $74	; t
		DB $46	; F
		DB $1B
		DB $1A
		DB $3E	; >
		DB $7A	; z
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB $1B
		DB $1A
		DB $3E	; >
		DB $78	; x
		DB $60	; `
		DB $31	; 1
		DB $89	; ‰
		DB $10
		DB $1B
		DB $1A
		DB $3E	; >
		DB $78	; x
		DB $E4	; д
		DB $5B	; [
		DB 0
		DB $33	; 3
		DB $96	; –
		DB $46	; F
		DB $73	; s
		DB $C5	; Е
		DB $33	; 3
		DB $40	; @
		DB $9A	; љ
		DB $26	; &
		DB 6
		DB $F3	; у
		DB $C5	; Е
		DB $33	; 3
		DB $40	; @
		DB $13
		DB $9A	; љ
		DB $9A	; љ
		DB $46	; F
		DB $53	; S
		DB 1
		DB $4A	; J
		DB 4
		DB $45	; E
		DB $FA	; ъ
		DB $76	; v
		DB $5C	; \
		DB $F1	; с
		DB $C0	; А
		DB $C6	; Ж
		DB $12
		DB $20
		DB $94	; ”
		DB $C0	; А
		DB $52	; R
		DB $F1	; с
		DB $C5	; Е
		DB $E7	; з
		DB $96	; –
		DB $E8	; и
		DB $80	; Ђ
		DB $7B	; {
		DB $AC	; ¬
		DB $48	; H
		DB $CA	; К
		DB $60	; `
		DB $29	; )
		DB $40	; @
		DB $63	; c
		DB $A9	; ©
		DB $16
		DB $85	; …
		DB $60	; `
		DB $19
		DB 0
		DB $1C
		DB $40	; @
		DB $67	; g
		DB $36	; 6
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB $1B
		DB $1A
		DB $3E	; >
		DB $79	; y
		DB $EB	; л
		DB 4
		DB $C8	; И
		DB $B0	; °
		DB $22	; "
		DB $65	; e
		DB $BA	; є
		DB $A4	; ¤
		DB $90	; ђ
		DB $5B	; [
		DB $A2	; ў
		DB $43	; C
		DB $91	; ‘
		DB $6C	; l
		DB $1C
		DB $40	; @
		DB $67	; g
		DB $36	; 6
		DB $C0	; А
		DB $68	; h
		DB $C0	; А
		DB $52	; R
		DB 8
		DB $BF	; ї
		DB $D3	; У
		DB $B2	; І
		DB $E7	; з
		DB $84	; „
		DB $E6	; ж
		DB $3C	; <
		DB $12
		DB $90	; ђ
		DB $93	; “
		DB $C8	; И
		DB $41	; A
		DB $85	; …
		DB $CE	; О
		DB $9C	; њ
		DB $80	; Ђ
		DB $2A	; *
		DB $C0	; А
		DB $C2	; В
		DB $73	; s
		DB $C7	; З
		DB $74	; t
		DB $5A	; Z
		DB $9C	; њ
		DB $69	; i
		DB $33	; 3
		DB $8E	; Ћ
		DB $34	; 4
		DB $60	; `
		DB $93	; “
		DB $D1	; С
		DB $14
		DB $4C	; L
		DB $71	; q
		DB $A3	; Ј
		DB 0
		DB $7A	; z
		DB $1E
		DB $49	; I
		DB $71	; q
		DB $C5	; Е
		DB $E7	; з
		DB $9E	; ћ
		DB 6
		DB $80	; Ђ
		DB $8A	; Љ
		DB $1A
		DB $6E	; n
		DB $38	; 8
		DB $BC	; ј
		DB $F3	; у
		DB $DD	; Э
		DB $62	; b
		DB $44	; D
		DB $19
		DB 1
		DB $33	; 3
		DB $C5	; Е
		DB $0D
		DB $30	; 0
		DB $C0	; А
		DB $41	; A
		DB $18
		DB $82	; ‚
		DB $47	; G
		DB $41	; A
		DB $16
		DB $30	; 0
		DB $93	; “
		DB $C8	; И
		DB $29	; )
		DB $C4	; Д
		DB $9C	; њ
		DB $F3	; у
		DB 0
		DB $22	; "
		DB 0
		DB $18
		DB $0D
		DB $CF	; П
		DB $4A	; J
		DB $6E	; n
		DB $69	; i
		DB 0
		DB 4
		DB $45	; E
		DB $FA	; ъ
		DB $76	; v
		DB $5C	; \
		DB $F1	; с
		DB $30	; 0
		DB $40	; @
		DB $71	; q
		DB $A2	; ў
		DB $4B	; K
		DB 1
		DB $A3	; Ј
		DB $93	; “
		DB $D1	; С
		DB $14
		DB $4C	; L
		DB $E4	; д
		DB $5B	; [
		DB 0
		DB $1C
		DB $40	; @
		DB $67	; g
		DB $37	; 7
		DB $9E	; ћ
		DB $29	; )
		DB $9A	; љ
		DB $60	; `
		DB $0C
		DB $4E	; N
		DB $78	; x
		DB $A6	; ¦
		DB $68	; h
		DB $9C	; њ
		DB $5C	; \
		DB $B5	; µ
		DB $F3	; у
		DB $D1	; С
		DB $43	; C
		DB $4C	; L
		DB $9C	; њ
		DB $5C	; \
		DB $B5	; µ
		DB $F3	; у
		DB $D2	; Т
		DB $98	; 
		DB $0A
		DB $50	; P
		DB $73	; s
		DB $71	; q
		DB $7E	; ~
		DB $79	; y
		DB $44	; D
		DB $C0	; А
		DB $14
		DB $71	; q
		DB $29	; )
		DB $81	; Ѓ
		DB $7C	; |
		DB $F4	; ф
		DB $AC	; ¬
		DB $E8	; и
		DB $8C	; Њ
		DB $94	; ”
		DB $DC	; Ь
		DB $D2	; Т
		DB 5
		DB $60	; `
		DB $19
		DB 0
		DB $9C	; њ
		DB $41	; A
		DB $52	; R
		DB $2C	; ,
		DB $E4	; д
		DB $5B	; [
		DB 0
		DB $19
		DB 1
		DB $33	; 3
		DB $F3	; у
		DB $C3	; Г
		DB 1
		DB $8C	; Њ
		DB $48	; H
		DB $80	; Ђ
		DB $63	; c
		DB $9A	; љ
		DB $67	; g
		DB $73	; s
		DB $C5	; Е
		DB $33	; 3
		DB $40	; @
		DB $5A	; Z
		DB 4
		DB $7E	; ~
		DB $78	; x
		DB $A6	; ¦
		DB $68	; h
		DB $26	; &
		DB 8
		DB $60	; `
		DB $25	; %
		DB $32	; 2
		DB $47	; G
		DB $9E	; ћ
		DB $51	; Q
		DB $30	; 0
		DB $B2	; І
