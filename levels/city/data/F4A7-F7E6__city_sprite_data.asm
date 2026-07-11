; --- CITY_SPRITE_DATA (F4A7-F7E6) -----------------------------
; @done
; City 3D-view sprite graphics (creatures/objects drawn into the
; dungeon-style view by render_sprite_3d). Addressed absolutely from
; code via the CITY_SPRITE_DATA label; no ADDR_TABLE slot. Layout:
;
;   +$000  SPRITE_PTR_TABLE  - 5 word pointers to the sprite records
;                             below, indexed by SLOT_SPRITE_ID (the
;                             per-view-slot sprite id, values 0..8).
;   +$00A  city_sprite_0..4  - the 5 sprite records.
;   +$240  SPRITE_PIXEL_XLAT - 256-byte pixel translation table
;                             ($F6E7-$F7E6): every decoded stream byte
;                             is mapped through it before masking.
;
; Sprite record = 3-byte header {b0,b1,b2} then an RLE pixel stream.
; render_sprite_3d reads b0/b1 as the outer/inner draw-loop counts and
; b2 as a vertical screen offset ($3EFF + column + b2). RLE token: a
; stream byte of $01 starts a run ($01,count,value); any other byte is
; a literal. Each emitted byte is translated via SPRITE_PIXEL_XLAT and
; turned into an 8-pixel mask by decode_sprite_mask, then AND/OR
; composited onto the screen (attributes written at char-cell edges).
; Note: the individual sprites' pixel art is not identified; the record
;       format above is derived from render_sprite_3d, not from docs.
CITY_SPRITE_DATA:
SPRITE_PTR_TABLE:
		DW city_sprite_0, city_sprite_1, city_sprite_2, city_sprite_3, city_sprite_4

; sprite record 0 (0xf4b1): header rows/cols/y = 1,71,12
city_sprite_0:
		DB $01,$47,$0C		; b0,b1,b2 (loop counts + y-offset)
		DB $C0,$80,$C0,$80,$C0,$B0,$F0,$B0,$F0,$B8,$FC,$B8,$FC,$BB,$AF,$AB
		DB $AF,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B
		DB $2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B
		DB $2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B,$2F,$2B
		DB $2F,$2B,$2F,$2B,$2F,$2B,$2C,$28

; sprite record 1 (0xf4fc): header rows/cols/y = 3,59,18
city_sprite_1:
		DB $03,$3B,$12		; b0,b1,b2 (loop counts + y-offset)
		DB $11,$88,$22,$88,$22,$88,$22,$88,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8
		DB $EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8
		DB $EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8
		DB $EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$EC,$B8,$13,$8A,$23,$8E
		DB $2F,$8E,$3F,$8E,$FF,$EE,$FF,$EE,$FB,$E2,$F8,$E2,$F4,$E0,$F0,$E0
		DB $F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0
		DB $F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$E0,$F0,$EA,$FB,$EA,$FB,$EA
		DB $FB,$E0,$F0,$E0,$F0,$E0,$C0,$C0,$00,$00,$00,$01,$04,$C0,$E0,$F0
		DB $E0,$F0,$E0,$F0,$E0,$BC,$3C,$7C,$01,$1E,$3C,$EC,$A0,$C0,$01,$0A
		DB $00

; sprite record 2 (0xf590): header rows/cols/y = 4,33,28
city_sprite_2:
		DB $04,$21,$1C		; b0,b1,b2 (loop counts + y-offset)
		DB $11,$88,$22,$88,$22,$BB,$FF,$D5,$EA,$AA,$EA,$AA,$EA,$AA,$EA,$AA
		DB $EA,$AA,$EA,$AA,$EA,$AA,$EA,$AA,$EA,$AA,$EA,$AA,$EA,$AA,$EA,$AB
		DB $EA,$BB,$11,$88,$22,$88,$22,$BB,$FF,$55,$AB,$AA,$AB,$AA,$5B,$5A
		DB $5B,$5A,$5B,$5A,$5B,$5A,$5B,$5A,$5B,$5A,$5B,$5A,$5A,$5B,$5E,$7B
		DB $EE,$BB,$AA,$BB,$11,$88,$22,$88,$22,$BB,$EC,$28,$2C,$28,$2C,$28
		DB $2C,$28,$2C,$28,$2C,$28,$2C,$28,$2C,$28,$2C,$28,$2C,$28,$EC,$A8
		DB $EC,$A8,$EC,$A8,$AC,$BB,$1C,$8C,$3C,$AE,$FF,$EE,$FF,$DF,$F7,$DD
		DB $01,$10,$C3,$FB,$EC,$E8,$E0,$01,$04,$C0

; sprite record 3 (0xf60d): header rows/cols/y = 3,18,34
city_sprite_3:
		DB $03,$12,$22		; b0,b1,b2 (loop counts + y-offset)
		DB $00,$00,$03,$0F,$01,$0E,$0E,$0F,$3C,$FF,$EE,$BB,$EE,$AA,$AA,$01
		DB $09,$96,$FF,$AA,$FF,$00,$00,$C0,$B0,$F0,$01,$0D,$B0,$F0

; sprite record 4 (0xf62e): header rows/cols/y = 5,45,19
city_sprite_4:
		DB $05,$2D,$13		; b0,b1,b2 (loop counts + y-offset)
		DB $01,$07,$00,$03,$0E,$3B,$EE,$FF,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE
		DB $EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE
		DB $EE,$FE,$EE,$FE,$EE,$FE,$EE,$FE,$EE,$FF,$00,$00,$00,$03,$0E,$3B
		DB $EE,$BF,$EE,$FF,$EE,$FF,$EE,$01,$05,$AA,$01,$14,$A9,$AA,$01,$04
		DB $FF,$AA,$EE,$FF,$0F,$3A,$EE,$BF,$EE,$FF,$EE,$FF,$EE,$FF,$EE,$FF
		DB $EE,$01,$05,$AA,$55,$FF,$DD,$FF,$DD,$FF,$DD,$FF,$DD,$FF,$DD,$FF
		DB $DD,$FF,$DD,$FF,$DD,$FF,$DD,$FF,$AA,$01,$04,$FF,$AA,$EE,$FF,$00
		DB $C0,$B0,$EC,$EB,$FE,$EE,$FF,$EE,$FF,$EE,$FF,$EE,$01,$05,$AA,$5A
		DB $01,$13,$DA,$AA,$01,$04,$FF,$AA,$EE,$FF,$01,$05,$00,$C0,$B0,$EC
		DB $EB,$FE,$EE,$FF,$EE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF
		DB $AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$AF,$AE,$EF
		DB $EE,$EF,$EE,$AF,$EE,$FF

; --- SPRITE_PIXEL_XLAT (F6E7-F7E6) ----------------------------
; 256-byte translation table: decoded stream byte -> screen pixel byte.
SPRITE_PIXEL_XLAT:
		DB $00,$40,$80,$C0,$10,$50,$90,$D0,$20,$60,$A0,$E0,$30,$70,$B0,$F0
		DB $04,$44,$84,$C4,$14,$54,$94,$D4,$24,$64,$A4,$E4,$34,$74,$B4,$F4
		DB $08,$48,$88,$C8,$18,$58,$98,$D8,$28,$68,$A8,$E8,$38,$78,$B8,$F8
		DB $0C,$4C,$8C,$CC,$1C,$5C,$9C,$DC,$2C,$6C,$AC,$EC,$3C,$7C,$BC,$FC
		DB $01,$41,$81,$C1,$11,$51,$91,$D1,$21,$61,$A1,$E1,$31,$71,$B1,$F1
		DB $05,$45,$85,$C5,$15,$55,$95,$D5,$25,$65,$A5,$E5,$35,$75,$B5,$F5
		DB $09,$49,$89,$C9,$19,$59,$99,$D9,$29,$69,$A9,$E9,$39,$79,$B9,$F9
		DB $0D,$4D,$8D,$CD,$1D,$5D,$9D,$DD,$2D,$6D,$AD,$ED,$3D,$7D,$BD,$FD
		DB $02,$42,$82,$C2,$12,$52,$92,$D2,$22,$62,$A2,$E2,$32,$72,$B2,$F2
		DB $06,$46,$86,$C6,$16,$56,$96,$D6,$26,$66,$A6,$E6,$36,$76,$B6,$F6
		DB $0A,$4A,$8A,$CA,$1A,$5A,$9A,$DA,$2A,$6A,$AA,$EA,$3A,$7A,$BA,$FA
		DB $0E,$4E,$8E,$CE,$1E,$5E,$9E,$DE,$2E,$6E,$AE,$EE,$3E,$7E,$BE,$FE
		DB $03,$43,$83,$C3,$13,$53,$93,$D3,$23,$63,$A3,$E3,$33,$73,$B3,$F3
		DB $07,$47,$87,$C7,$17,$57,$97,$D7,$27,$67,$A7,$E7,$37,$77,$B7,$F7
		DB $0B,$4B,$8B,$CB,$1B,$5B,$9B,$DB,$2B,$6B,$AB,$EB,$3B,$7B,$BB,$FB
		DB $0F,$4F,$8F,$CF,$1F,$5F,$9F,$DF,$2F,$6F,$AF,$EF,$3F,$7F,$BF,$FF
