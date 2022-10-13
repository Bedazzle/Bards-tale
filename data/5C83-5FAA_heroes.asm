HEROES:
		ds 100, 0
		db    0

ENEMY:
		db    0
		db 'EREMY THORPE  ', 0FFh
		db    0,	 0,   0,   0
		db    0,   0,	1,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0, 10h
		db    0, 10h,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0,   0,	0,   0,	  0,   0,   0,	 0,   0,   0
		db    0

BRIAN:
		db 'BRIAN THE FIST ', 0FFh

		IFNDEF KILLERS
			db %01100010
			db %01001110
			db %01010001
			db %10010010
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,	0,   0,	  0,   0,   0,	 0,   2,   0,    3,   0
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2
			db    0,   2
		ENDIF
		
		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0
		ENDIF
		
		db    0, 1Eh		; hits
		db    0, 1Eh		; cond
		
		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0,   0		; sppt max
			db    0,   0		; sppt curr
		ENDIF

		db    CLASS_PALADIN
		db    RACE_HUMAN
		db    0,   0
		db    0,   1
		db    STATUS_OK
		db    7

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0,   0,   0,	 0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		db    0,   0,   0
		db    0,	0,   1,	  0,   0,   0,	 0,   0,   0

		; items
		db    1, 0Dh,	1, 11h,	  1, 13h,   1, 0Bh,   1,   7
		db    0,   0,	0,   0,	  0,   0
		
		db    0,	 0,   0,   0
		db    1

EL_CID:
		db 'EL CID         ', 0FFh
		
		IFNDEF KILLERS
			db %01100010	; 0110 0010 0101 0000
			db %01010000
			db %00110001	; 0011 0001 1000 1110
			db %10001110

			;db %0110 0010	; XXXX XYYY		stamina XXXX X iq YYY
			;    ------xxx
			;db %0101 0000	; YY.Z ZZZZ		iq YY          dx ZZZZZ
			;    xx?------
			;db %0011 0001	; AAAA ABBB		cn AAAA A      lk BBB
			;    xxxxxx---
			;db %1000 1110	; BB.? ????     lk BB
			;    --?xxxxxx
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,   0,	0,   0,	  0,   0,   0,	 2,   0,   3,	0	; Experience - 1 byte each	for 11 digits
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2		; Max level acheived
			db    0,   2		; Current level
		ENDIF

		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0	; Gold - 1	byte each for 11 digits
		ENDIF

		db    0, 14h		; HITS HI/LO
		db    0, 14h		; COND HI/LO

		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0, 0		; SPPT MAX HI/LO
			db    0, 0		; SPPT curr HI/LO
		ENDIF

		db    CLASS_BARD	; Char Class
		db    RACE_ELF	; Char Race
		db    0
		db    0
		db    0			; Counter for won combats?
		db    1			; Counter for won combats?
		db    STATUS_OK	; Character status?
		db    8			; Natural AC?

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0			; Sorcerer spell level
			db    0			; Conjuror Spell level
			db    0			; Magician Spell level
			db    0			; Wizard Spell level
		ENDIF

		db    0			; Rogue	value: Disarm traps?
		db    0			; Rogue	value: Detect Traps?
		db    0			; Rogue	value: Hide in Shadows?
		db    0
		db    0			; Hunter critical hit chance
		db    1			; Bard songs remaining?
		db    0
		db    0
		db    0
		db    0			; Flag spell active that overrides neg effect
		db    0			; Holds	former health state
		db    0			; No. attacks per round	if class can

		; items
		db    1,   6		; item 1 state/ID
		db    1, 0Dh		; item 2
		db    1, 11h		; item 3
		db    1, 12h		; item 4
		db    1, 0Bh		; item 5
		db    1, 1Eh		; item 6
		db    0,   0		; item 7
		db    0,   0		; item 8

		db    0
		db    0
		db    0
		db    0

		db    2			; position in party

SAMSON:
		db 'SAMSON         ', 0FFh
		
		IFNDEF KILLERS
			db %10010010
			db %10001001
			db %01011010
			db %10010011
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF
		
		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,	0,   0,	  0,   0,   0,	 0,   2,   0,  3,   0
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2
			db    0,   2
		ENDIF
		
		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0
		ENDIF

		db    0, 1Ch
		db    0, 1Ch

		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0,   0
			db    0,   0
		ENDIF
		
		db    CLASS_WARRIOR
		db    RACE_DWARF

		db    0,   0
		db    0,   1
		db    STATUS_OK
		db    7

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0,   0,   0,	 0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		db    0,   0,   0
		db    0,	0,   1,	  0,   0,   0,	 0,   0,   0

		; items
		db    1,   3,	1, 0Dh,	  1, 11h,   1, 13h,   1, 0Bh,  0,   0,	0,   0,	  0,   0

		db    0F0h,0F0h,   7, 16h
		db    3

MARKUS:
		db 'MARKUS         ', 0FFh

		IFNDEF KILLERS
			db %01001010
			db %10010001
			db %00110010
			db %10010000
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,	0,   0,	  0,   0,   0,	 0,   2,   0,  3,   0
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2
			db    0,   2
		ENDIF
		
		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0
		ENDIF

		db    0, 18h
		db    0, 18h

		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0,   0
			db    0,   0
		ENDIF
		
		db    CLASS_ROGUE
		db    RACE_HOBBIT

		db    0,   0
		db    0,   1
		db    STATUS_OK
		db    6

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0,   0,   0,	 0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		db    1Dh, 18h, 1Ah
		db    0,	0,   1,	  0,   0,   0,	 0,   0,   0

		; items
		db    1,   8,	1, 0Ah,	  1, 0Ch,   1, 12h,   0,   2,  0,   2,	0,   0,	  0,   0

		db    2Eh,0E2h,0ECh,0EEh
		db    4

MERLIN:
		db 'MERLIN         ', 0FFh

		IFNDEF KILLERS
			db %01010100
			db %01000111
			db %01001011
			db %00001110
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,	0,   0,	  0,   0,   0,	 0,   2,   0,  3,   0
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2
			db    0,   2
		ENDIF
		
		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0
		ENDIF
		
		db    0, 10h		; hits
		db    0, 10h		; cond

		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0, 14h		; sppt max
			db    0, 14h		; sppt curr
		ENDIF

		db    CLASS_CONJURER
		db    RACE_GNOME

		db    0,   0
		db    0,   1
		db    STATUS_OK
		db    1

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0,   1,   0,	 0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		db    0,   0,   0
		db    0,	  0,   1,  0,   0,   0,	 0,   0,   0

		; items
		db    1,   5,	1, 10h,	  0,   0,   0,	 0,   0,   0,  0,   0,	0,   0,	  0,   0

		db    0FFh,0FFh,0FFh, 7Fh
		db 5

OMAR:
		db 'OMAR           ', 0FFh

		IFNDEF KILLERS
			db %01011100
			db %00001011
			db %01000010
			db %11010011
		ELSE
			db %11111111, %11111111, %11111111, %11111111
		ENDIF

		IFDEF MAXEXPIRIENCE
			ds 12, 9
		ELSE
			db    0,   0,	0,   0,	  0,   0,   0,	 0,   2,   0,  3,   0
		ENDIF

		IFDEF MAXLEVEL
			db    0,   7
			db    0,   7
		ELSE
			db    0,   2
			db    0,   2
		ENDIF
		
		IFDEF MAXGOLD
			ds 12, 9
		ELSE
			ds 12, 0
		ENDIF
		
		db    0, 14h		; hits
		db    0, 14h		; cond
		
		IFDEF MAXSPPOINTS
			db 0FFh, 0FFh, 0FFh, 0FFh
		ELSE
			db    0, 0Eh		; sppt max
			db    0, 0Eh		; sppt curr
		ENDIF
		
		db    CLASS_MAGICIAN
		db    RACE_ELF
		
		db    0,   0
		db    0,   1
		db    STATUS_OK
		db    1

		IFDEF MAXSPLEVEL
			db 7, 7, 7, 7
		ELSE
			db    0,   0,   1,  0	; Sorc / Conj / Mag / Wiz levels
		ENDIF

		db    0,   0,   0
		db    0,   0,   1,  0,   0,   0,	 0,   0,   0

		; items
		db    1,   9,	1, 10h,	  0,   0,   0,	 0,   0,   0,  0,   0,	0,   0,	  0,   0

		db    12h,	 8,0AAh,0A8h
		db    6		; position
