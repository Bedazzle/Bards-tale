MONST_HP_ENC:
		db  12h, 12h, 22h, 22h,	21h, 22h, 21h, 21h, 22h, 21h, 21h, 21h,	22h, 22h, 21h, 22h
		db  21h, 22h,0FCh,   6,	21h, 32h, 32h, 32h,0FCh,   4, 31h, 32h,	31h, 31h, 32h, 32h
		db  32h, 31h, 32h, 32h,	31h, 30h, 42h, 32h, 32h, 41h, 42h, 42h,	42h, 41h,0FCh,	 4
		db  42h, 41h, 41h, 42h,	42h, 41h, 42h, 42h, 42h, 41h,0FCh,   5,	42h, 41h, 42h, 41h
		db  52h, 53h, 52h, 53h,	52h, 52h, 52h, 50h, 52h, 52h, 52h, 51h,	52h, 52h, 53h, 52h
		db  50h, 51h, 52h, 53h,	50h, 52h, 52h, 62h, 54h, 15h, 51h, 64h,	66h, 61h, 62h, 52h
		db  52h, 52h, 53h, 62h,	62h, 61h, 61h, 62h, 61h, 63h, 64h, 15h,	62h, 62h, 70h, 60h
		db  62h, 62h, 62h, 66h,	72h, 72h, 72h, 71h

___table_13:
		db    1
		db    1
		db    2
		db    2
		db    2
		db    3
		db    3
		db    4

MONST_HP_AC:
		db    0
		db  40h, 60h, 21h, 61h,	22h, 42h, 21h, 21h, 63h, 84h, 84h, 44h,	43h,0A4h, 85h,0A4h
		db  23h,0C5h,0C6h,0C5h,	23h, 23h, 23h, 23h, 46h, 25h, 26h, 45h,	86h, 66h, 86h,0C6h
		db 0C7h,0A5h, 25h, 25h,	25h, 25h, 86h,0C6h, 46h, 87h, 27h,0E7h,0E8h, 28h, 69h, 28h
		db  48h, 69h, 29h, 27h,	27h, 27h, 67h, 88h, 89h, 49h, 89h,0AAh,	49h,0CAh,0EAh, 4Ah
		db  6Bh,0AAh,0A9h,0A9h,0C9h,0A9h,0EBh, 2Bh, 2Ah, 2Ah, 6Ah, 4Bh,	4Bh,0ACh, 4Ah, 2Bh
		db  2Bh, 2Bh, 4Bh, 6Ch,	6Dh, 4Dh, 4Ch, 6Ch, 8Ch, 4Bh, 2Bh, 4Ch,	4Dh, 8Dh, 2Eh,0CEh
		db 0AFh,0EFh, 50h, 2Fh,	50h, 70h,0EDh,0EDh,0EDh,0CFh, 50h, 71h,	30h, 72h,0D3h, 2Fh
		db  70h,0B2h,0B0h, 91h,0B3h,0F4h,0D3h,0B2h,0F4h,0F3h,0D3h,0F4h,	54h,0F4h, 14h

MONST_SPEC:	
		db    0
		db    0,   0,0FCh,   4,	  1,   0,   0,0FCh,   4,   2,	1,   3,	  2,   3,   4,	 3
		db    3,   4,0FCh,   4,	  2,   4, 24h,	 3,   4,   5, 84h,   4,	  5,   5,0FCh,	 5
		db    4,   6, 26h,   7,	  6,   8,   7,	 7,   7,   8,	7,   7,	  8, 88h,0FCh,	 4
		db    6, 0Ah,	9,   9,	0Ah, 6Ah, 0Ah, 0Bh, 0Bh, 0Dh, 6Bh, 0Bh,0FCh,   4,   8, 0Bh
		db  0Ch, 2Bh, 0Ch,0ABh,	0Ch, 4Dh, 8Eh, 0Ch,0FCh,   4, 0Ah,0EEh,	0Fh, 0Fh, 0Eh, 90h
		db  11h,0D0h, 30h, 10h,	12h, 53h, 74h, 13h, 13h, 14h, 14h, 10h,	17h, 16h, 10h, 10h
		db  10h, 13h, 56h, 18h,	36h, 59h,0BBh, 12h, 15h, 15h, 15h, 18h,	1Ah,0F8h, 1Ch, 1Ch
		db  1Eh, 9Dh, 75h,0B7h,	15h,0DFh,0FFh

MONST_IMAGE:
		db    0
		db    0,   0,	0,   0,	  5, 0Bh,   2,	 2, 0Bh,   3,	1,   8,	  6, 0Bh,   1,	 6
		db  0Ah, 0Bh,	1,   3,	  2,   2,   2,	 2,   1,   8,	5,   6,	0Bh,   3, 0Bh,	 1
		db    0,   5,	2,   2,	  2,   2,   5,	 8, 0Ah,   3, 0Bh, 0Bh,	  6, 0Bh,   4,	 9
		db    0,   1,	3,   2,	  2,   2,   2, 0Ah,   6,   4,	4, 0Ch,	0Ch, 0Bh,   4, 0Ah
		db  0Ch,   1,	2,   2,	  2,   2,   4, 0Bh,   9, 0Bh,	3, 0Bh,	0Ch, 0Ch,   7,	 2
		db    2,   2,	2,   5,	0Bh,   1,   1, 0Ch,   4,   4,	9,   3,	0Bh,   5, 0Ch,	 6
		db  0Ch,   7,	1,   3,	  4, 0Bh,   2,	 2,   2, 0Ch,	3, 0Bh,	  9,   5, 0Ch,	 2
		db  0Bh,   1, 0Ch,   4,	  4,   2, 0Bh,	 9, 0Bh, 0Ch,	7,   3,	  2, 0Bh,   7

XP_TABLE:	
		db  32h, 3Ch, 46h, 50h,	50h, 5Ah, 5Ah, 64h, 64h, 64h, 6Eh, 78h,	96h,0B4h,0C8h,0DCh
		db    1,   1,	1,0FCh,	  4,   2,   3,	 3,0FCh,   7,	4,0FCh,	  4,   5,0FCh,	 4
		db    6,0FCh,	4,   7,0FCh,   4,   8,0FCh,   8,   9,0FCh, 10h,	0Ah,0FCh, 0Ch, 0Bh
		db 0FCh, 0Ch, 0Ch,0FCh,	0Ch, 0Dh,0FCh, 10h, 0Eh,0FCh,	4, 0Fh

MONST_MAGIC:
		db    0
		db 0FCh, 1Dh,	0,   1,	  1,   2,   0,	 0, 19h, 13h,0FCh, 31h,	  0,   1,   2,	 3
		db    0, 19h, 13h, 1Bh,	  0, 0Bh, 0Bh, 0Ch,   0,   1, 19h, 22h,0FCh, 29h,   0,	 1
		db    3,   4,	0, 1Bh,	1Ch, 1Dh,   0, 0Bh, 0Ch, 0Dh,	0,   4,	1Bh, 22h,0FCh, 0Eh
		db    0,0FEh,0FEh,0FCh,	12h,   0, 57h, 57h,0FCh, 11h,	0,   3,	  4,   5,   0, 1Bh
		db  1Dh, 1Eh,	0, 0Eh,	10h, 11h,   0,	 4, 1Dh, 23h,0FCh, 0Eh,	  0, 58h, 58h,0FCh
		db  0Eh,   0, 59h, 59h,0FCh, 0Dh,   0,	 5,   6,   6,	0, 1Bh,	1Eh, 1Fh,   0,	 6
		db  1Dh, 23h,	0, 10h,	11h, 12h,   0,	 0, 4Fh, 4Fh,0FCh, 1Bh,	  0, 11h,   0,	 0
		db    0, 14h,	0,   9,	  8,   7,   0, 1Dh, 1Ch, 1Fh,	0, 12h,	15h, 16h,   0, 25h
		db  24h, 1Fh,0FCh, 16h,	  0, 50h, 50h,0FCh,   6,   0, 1Dh, 0Eh,	  0,   0,0FEh,0FEh
		db 0FCh,   7,	0, 0Dh,	  0,   0,   0, 50h,0FCh, 0Ah,	0, 20h,	20h,0FCh, 0Ah,	 0
		db  51h, 51h,0FCh,   5,	  0, 0Ah,   9,	 9,   0, 1Fh, 20h, 21h,	  0, 15h, 16h, 18h
		db 0FCh, 0Dh,	0, 1Eh,	1Fh, 21h,   0,	 0, 24h, 21h,	0,   0,	25h, 52h,   0, 25h
		db  26h, 26h,	0,   0,	20h,   7,   0,	 0,   0, 15h,0FCh,   6,	  0, 53h, 53h,	 0
		db    0, 54h, 54h, 26h,	18h, 21h, 1Fh,0FCh,   6,   0, 55h, 55h,0FCh, 0Bh,   0, 21h
		db    0, 26h, 21h, 0Dh,	26h, 18h, 21h, 1Fh,   0,   0, 26h, 56h,	  0,   0, 15h, 15h
