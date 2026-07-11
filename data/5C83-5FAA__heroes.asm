; --- HEROES ---------------------------------------------------
; @done
; Party roster storage: an array of 101-byte ($65) hero records
; (find_hero computes ix = HEROES + hero*$65). Field layout = the CHAR_*
; offsets in constants.asm:
;   $00-$0F name, 15 chars + $FF terminator (at CHAR_NAME_TERM $0F)
;   $10-$13 two packed attribute words (St/IQ/Dx, Cn/Lk) - see
;           unpack_hero_attrs / pack_hero_attrs (5-bit fields per word)
;   $14-$1F experience, 12 bytes (1 decimal digit each)
;   $20-$23 max-level / current-level (hi,lo)
;   $24-$2F gold, 12 bytes (1 decimal digit each)
;   $30-$37 hits, condition, spell-points max/cur (hi,lo pairs)
;   $38 class, $39 race, $3C-$3D combats-won, $3E status, $3F natural AC
;   $40-$43 Sorcerer/Conjurer/Magician/Wizard spell levels
;   $44-$4F rogue disarm/detect/hide, hunter, bard songs, attacks/round...
;   $50-$5F inventory: 8 x {state, item-id}
;   $60-$63 backup/swap stats, $64 position in party
; This first record is a zeroed blank template. Part of the saved PARTY_FILE.
; Referenced by: find_hero (ix=HEROES+hero*$65), GET_ATTR_BY_PARAM (ix+CHAR_*).
HEROES:
		DS 100,0
		DB 0

; --- ENEMY ----------------------------------------------------
; @done
; Active-enemy scratch record: same 101-byte ($65) layout as a hero record
; but accessed via the ENEMY_* offsets (constants.asm). Combat code points
; ix here to read/write the current foe. Initialised with a placeholder
; ('EREMY THORPE'); overwritten each encounter.
; Referenced by: ADDR_TABLE index $37; combat routines (ix=ENEMY).
ENEMY:
		DB 0
		DB 'EREMY THORPE  ',$FF
		DB 0,0,0,0
		DB 0,0,1,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,$10
		DB 0,$10,0,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,0
		DB 0,0,0,0,0,0,0,0,0,0
		DB 0

; --- BRIAN ----------------------------------------------------
; @done
; Built-in default party member #1 - BRIAN THE FIST, a Paladin/Human. A
; full 101-byte hero record (see HEROES for the field layout). The IFDEF
; cheat flags (KILLERS / MAXEXPIRIENCE / MAXLEVEL / MAXGOLD / MAXSPPOINTS /
; MAXSPLEVEL) overwrite the attribute/exp/level/gold/spell fields at build
; time; the ELSE branches hold the shipped values.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
BRIAN:
		DB 'BRIAN THE FIST ',$FF

		IFNDEF KILLERS
			DB %01100010
			DB %01001110
			DB %01010001
			DB %10010010
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2
			DB 0,2
		ENDIF
		
		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0
		ENDIF
		
		DB 0,$1E		; hits
		DB 0,$1E		; cond
		
		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,0		; sppt max
			DB 0,0		; sppt curr
		ENDIF

		DB CLASS_PALADIN
		DB RACE_HUMAN
		DB 0,0
		DB 0,1
		DB STATUS_OK
		DB 7

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0,0,0,0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		DB 0,0,0
		DB 0,0,1,0,0,0,0,0,0

		; items
		DB 1,$0D,1,$11,1,$13,1,$0B,1,7
		DB 0,0,0,0,0,0
		
		DB 0,0,0,0
		DB 1

; --- EL_CID ---------------------------------------------------
; @done
; Built-in default party member - EL CID, a Bard/Elf. Full 101-byte hero
; record (see HEROES for field layout; inline comments here annotate the
; individual fields). Position-in-party field ($64) = 2.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
EL_CID:
		DB 'EL CID         ',$FF
		
		IFNDEF KILLERS
			DB %01100010	; 0110 0010 0101 0000
			DB %01010000
			DB %00110001	; 0011 0001 1000 1110
			DB %10001110

			;db %0110 0010	; XXXX XYYY		stamina XXXX X iq YYY
			;    ------xxx
			;db %0101 0000	; YY.Z ZZZZ		iq YY          dx ZZZZZ
			;    xx?------
			;db %0011 0001	; AAAA ABBB		cn AAAA A      lk BBB
			;    xxxxxx---
			;db %1000 1110	; BB.? ????     lk BB
			;    --?xxxxxx
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0	; Experience - 1 byte each	for 11 digits
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2		; Max level acheived
			DB 0,2		; Current level
		ENDIF

		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0	; Gold - 1	byte each for 11 digits
		ENDIF

		DB 0,$14		; HITS HI/LO
		DB 0,$14		; COND HI/LO

		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,0		; SPPT MAX HI/LO
			DB 0,0		; SPPT curr HI/LO
		ENDIF

		DB CLASS_BARD	; Char Class
		DB RACE_ELF	; Char Race
		DB 0
		DB 0
		DB 0			; Counter for won combats?
		DB 1			; Counter for won combats?
		DB STATUS_OK	; Character status?
		DB 8			; Natural AC?

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0			; Sorcerer spell level
			DB 0			; Conjuror Spell level
			DB 0			; Magician Spell level
			DB 0			; Wizard Spell level
		ENDIF

		DB 0			; Rogue	value: Disarm traps?
		DB 0			; Rogue	value: Detect Traps?
		DB 0			; Rogue	value: Hide in Shadows?
		DB 0
		DB 0			; Hunter critical hit chance
		DB 1			; Bard songs remaining?
		DB 0
		DB 0
		DB 0
		DB 0			; Flag spell active that overrides neg effect
		DB 0			; Holds	former health state
		DB 0			; No. attacks per round	if class can

		; items
		DB 1,6		; item 1 state/ID
		DB 1,$0D		; item 2
		DB 1,$11		; item 3
		DB 1,$12		; item 4
		DB 1,$0B		; item 5
		DB 1,$1E		; item 6
		DB 0,0		; item 7
		DB 0,0		; item 8

		DB 0
		DB 0
		DB 0
		DB 0

		DB 2			; position in party

; --- SAMSON ---------------------------------------------------
; @done
; Built-in default party member - SAMSON, a Warrior/Dwarf. Full 101-byte
; hero record (see HEROES for field layout). Position-in-party ($64) = 3.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
SAMSON:
		DB 'SAMSON         ',$FF
		
		IFNDEF KILLERS
			DB %10010010
			DB %10001001
			DB %01011010
			DB %10010011
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF
		
		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2
			DB 0,2
		ENDIF
		
		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0
		ENDIF

		DB 0,$1C
		DB 0,$1C

		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,0
			DB 0,0
		ENDIF
		
		DB CLASS_WARRIOR
		DB RACE_DWARF

		DB 0,0
		DB 0,1
		DB STATUS_OK
		DB 7

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0,0,0,0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		DB 0,0,0
		DB 0,0,1,0,0,0,0,0,0

		; items
		DB 1,3,1,$0D,1,$11,1,$13,1,$0B,0,0,0,0,0,0

		DB $F0,$F0,7,$16
		DB 3

; --- MARKUS ---------------------------------------------------
; @done
; Built-in default party member - MARKUS, a Rogue/Hobbit. Full 101-byte
; hero record (see HEROES for field layout). Position-in-party ($64) = 4.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
MARKUS:
		DB 'MARKUS         ',$FF

		IFNDEF KILLERS
			DB %01001010
			DB %10010001
			DB %00110010
			DB %10010000
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2
			DB 0,2
		ENDIF
		
		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0
		ENDIF

		DB 0,$18
		DB 0,$18

		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,0
			DB 0,0
		ENDIF
		
		DB CLASS_ROGUE
		DB RACE_HOBBIT

		DB 0,0
		DB 0,1
		DB STATUS_OK
		DB 6

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0,0,0,0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		DB $1D,$18,$1A
		DB 0,0,1,0,0,0,0,0,0

		; items
		DB 1,8,1,$0A,1,$0C,1,$12,0,2,0,2,0,0,0,0

		DB $2E,$E2,$EC,$EE
		DB 4

; --- MERLIN ---------------------------------------------------
; @done
; Built-in default party member - MERLIN, a Conjurer/Gnome. Full 101-byte
; hero record (see HEROES for field layout). Position-in-party ($64) = 5.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
MERLIN:
		DB 'MERLIN         ',$FF

		IFNDEF KILLERS
			DB %01010100
			DB %01000111
			DB %01001011
			DB %00001110
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2
			DB 0,2
		ENDIF
		
		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0
		ENDIF
		
		DB 0,$10		; hits
		DB 0,$10		; cond

		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,$14		; sppt max
			DB 0,$14		; sppt curr
		ENDIF

		DB CLASS_CONJURER
		DB RACE_GNOME

		DB 0,0
		DB 0,1
		DB STATUS_OK
		DB 1

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0,1,0,0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		DB 0,0,0
		DB 0,0,1,0,0,0,0,0,0

		; items
		DB 1,5,1,$10,0,0,0,0,0,0,0,0,0,0,0,0

		DB $FF,$FF,$FF,$7F
		DB 5

; --- OMAR -----------------------------------------------------
; @done
; Built-in default party member - OMAR, a Magician/Elf. Full 101-byte hero
; record (see HEROES for field layout). Position-in-party ($64) = 6.
; Referenced by: find_hero (ix=HEROES+hero*$65); the pre-loaded roster.
OMAR:
		DB 'OMAR           ',$FF

		IFNDEF KILLERS
			DB %01011100
			DB %00001011
			DB %01000010
			DB %11010011
		ELSE
			DB %11111111,%11111111,%11111111,%11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			DS 12,9
		ELSE
			DB 0,0,0,0,0,0,0,0,2,0,3,0
		ENDIF

		IFDEF MAXLEVEL
			DB 0,7
			DB 0,7
		ELSE
			DB 0,2
			DB 0,2
		ENDIF
		
		IFDEF MAXGOLD
			DS 12,9
		ELSE
			DS 12,0
		ENDIF
		
		DB 0,$14		; hits
		DB 0,$14		; cond
		
		IFDEF MAXSPPOINTS
			DB $FF,$FF,$FF,$FF
		ELSE
			DB 0,$0E		; sppt max
			DB 0,$0E		; sppt curr
		ENDIF
		
		DB CLASS_MAGICIAN
		DB RACE_ELF
		
		DB 0,0
		DB 0,1
		DB STATUS_OK
		DB 1

		IFDEF MAXSPLEVEL
			DB 7,7,7,7
		ELSE
			DB 0,0,1,0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		DB 0,0,0
		DB 0,0,1,0,0,0,0,0,0

		; items
		DB 1,9,1,$10,0,0,0,0,0,0,0,0,0,0,0,0

		DB $12,8,$AA,$A8
		DB 6		; position
