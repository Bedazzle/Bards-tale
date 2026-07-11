; --- SCRATCH_BUFFER --------------------------------------------
; @done
; Shared zero-initialised RAM work buffer (DS 18*10 + 1 = 181 bytes).
; Aliased by several ADDR_TABLE slots (indices $03, $1E, $1F, $52, $53,
; $54) that hand out this scratch area to different routines.
; Referenced by: ADDR_TABLE indices $03/$1E/$1F/$52/$53/$54.
SCRATCH_BUFFER:
		DS 18*10,0

		DB 0
