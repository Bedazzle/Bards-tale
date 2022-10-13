		debug "WEAPON_DAMAGE: "
WEAPON_DAMAGE:
		db    0
		db    0,   0,	1, 20h,	  0,   1, 40h, 20h, 20h,0FCh, 0Dh,   0,	  1,0FCh,   5,	 0
		db  21h,0FCh,	5,   0,	  1, 20h,0FCh,	 6,   0,   4,	5, 22h,	40h,   0, 22h,	 1
		db 0FCh,   4,	0, 20h,	  0, 41h,0FCh,	 5,   0,   1,0FCh,   5,	  0, 22h, 23h,	 4
		db  21h,   2,	2, 22h,	  0,   0,   0,	 1,0FCh,   5,	0,   2,	23h,   4, 22h, 41h
		db 0FCh, 0Eh,	0, 22h,0FCh,   7,   0,	 3,   0, 41h, 22h,   0,	  2,0FCh, 0Ah,	 0
		db  43h

		debug "WEAPON_BONUS: "
WEAPON_BONUS:
		db    0
		db 0FCh, 0Ah,	0,   1,	  2,   2,   3,	 4,   5,0FCh,	4,   1,	  0,   0,   0, 10h
		db    3,   4,	5,   0,	  4, 10h,   0,	 0, 10h,   2,	2, 10h,	  0,   6,   0,	 0
		db    2,   0,	2, 20h,	20h, 10h, 12h,	 2,   0, 20h,	4, 20h,	  3,   3, 20h, 20h
		db    0,   0,	2,   0,	  2,   0,   5,	 6,   7,   6,	3,   5,	  2,   0,   0, 10h
		db  20h, 32h, 20h,   0,	  0,   0, 30h,	 5, 30h,   4,	0,   0,	20h,0FCh,   4, 10h
		db    3,   8,	5,   2,	  1,   0,   1,	 0,   0,   0,	2,   0,	  1,   3, 50h,	 0
		db    0,   1,	3,   0,	  0,   0, 40h,	 0, 10h, 10h,	3, 30h,0FCh,   4,   0,	 2
		db    1,   1,	1,   0,	  0, 18h

		debug "ITEM_SPECATT: "
ITEM_SPECATT:
		db    0
		db    0,   0,0FCh,   7,	  1,   2,   2,0FCh,   5,   3,	4,   5,	  5,   6,   6,	 6
		db    1,   2,	3,   3,	  7,   3,   1,	 6,   9,   1,	4,   5,	  1,   1,   3,	 7
		db    6,   8,	8,   6,	11h,   1,   1,	 1, 0Ah,   1,	1,   2,	  1,   4,   5,	 1
		db    1,   1,	9, 0Ah,	0Ah,   2,   7,0FCh,   4,   3,	2,   2,	  1,   1,   1, 51h
		db  41h,   1,	1,   6,	  6,   6,   1,	 2,   1,   4,	7,   7,	  1,   1, 31h,	 1
		db  21h,   2,	3,   5,	  4,   9, 0Ah, 0Ah,0FCh,   4,	6,   8,	  8,   2, 21h, 0Ah
		db  0Ah,   9,	4,   7,	  7,   8,   1,	 0,   1, 61h,	4, 71h,	  7,   7, 0Ah,	 7
		db    9, 0Ah, 0Ah, 0Ah,	  7,   7, 71h

		debug "ITEM_EQUIP: "
ITEM_EQUIP:
		db    0
		db 0FFh,0FFh, 8Eh, 9Eh,0FFh, 8Eh, 87h, 9Fh,0FFh,0BFh, 8Eh,0BFh,	8Eh, 8Eh, 84h,0FFh
		db  8Eh,0BFh, 86h,   8,	  8,   8, 9Eh, 9Fh, 8Eh,0CEh,0FFh,0FFh,	  8,   8, 60h,0FFh
		db  9Eh,0BEh, 8Fh, 9Fh,	84h,0FFh,   8,0FFh,0FFh,   8, 8Eh,   2,0CEh,0E6h,0BCh, 8Eh
		db  8Eh, 8Eh,0FFh, 8Eh,	8Eh, 9Eh, 60h,	 4, 60h, 71h, 70h,0FFh,0FFh, 8Eh, 84h, 80h
		db  7Bh, 9Fh,	4, 60h,0FAh, 10h, 22h, 33h, 60h, 82h,	8,   8,	  8, 86h, 80h,0BCh
		db  84h,0FFh,0FFh, 60h,	8Eh, 40h, 60h,	 2, 86h, 80h, 8Ch,0ACh,	60h,0FBh, 79h,	 8
		db    8,   8,	8, 60h,	62h, 8Ch,0A2h,	 4, 60h, 60h, 82h,0FFh,0FFh,0FFh,0FAh,0FFh
		db  8Eh, 82h, 8Ch,0BBh,0FFh,0FFh,0FFh,0FFh, 20h,0FFh,0FFh,0FFh,0FFh,0FFh,0AAh

		debug "ITEM_EFFECTS: "
ITEM_EFFECTS:
		db    0
		db 0B0h,0B1h,0FCh, 18h,	  0,0BCh,   0,	 5, 2Bh, 90h,0FCh,   6,	  0,0B4h,   5,0FCh
		db    5,   0, 90h,0FCh,	  9,   0, 96h, 97h,0A4h, 96h, 9Eh,   6,0B3h,0FCh,   4,	 0
		db  9Fh,   0,	2,   0,	  8,   0,   0, 1Ah,0A5h, 91h, 93h, 2Dh,0FCh,   4,   0,0BEh
		db 0BDh,   4,0A0h,0A3h,	12h,   0, 2Dh,	 0,   0, 9Ch, 2Ch, 9Dh,	  7, 2Fh, 1Ah,0A5h
		db  94h, 1Bh,0A7h,0A2h,	  0, 19h, 9Ch, 95h,0A5h,0B2h,0BAh,   1,	  1, 0Eh,   9,	 0
		db  98h,   0,0B5h,0BBh,	0Ah, 0Fh,0A6h, 0Bh, 0Ch, 0Dh, 39h,0B7h,	28h

		debug "  items end: "
