; --- CITY_MAP_DATA ---------------------------------------------
; @done
; Run-length-encoded map of Skara Brae (the outdoor city grid). Decoded
; row by row; the escape $FC,count,value emits 'value' repeated 'count'
; times, all other bytes are literal cells. Cell bits encode wall/edge
; flags; bytes like $60/$68/$11/$21/$99 mark special locations (buildings,
; gates, guardians).
; Referenced by: ADDR_TABLE index $6E (CITY_MAP_DATA + 1).
CITY_MAP_DATA:
		DB 0,0,0
		DB $FC,$1E,1,$FC,$15,0,1,1,0,0,0,1,1,1,0,0,$FC,7,1,0,$FC,5,1,0,$FC,5,1,0,0,$68,0,$91
		DB 0,1,1,1,0,0,$60,0,$60,0,0,0,1,0,1,0,0,0,1,$FC,6,0,1,0,1,0,0,0,1,1,0,0
		DB 1,1,1,0,0,$21,0,1,0,1,0,1,0,0,0,$FC,4,1,0,1,0,1,1,$68,1,1,1,0,0,1,$99,0
		DB $60,0,0,0,1,0,1,$FC,$0A,0,1,0,1,1,0,$FC,4,1,0,1,1,1,0,0,1,1,1,0,$FC,4,1,0
		DB 1,1,1,0,0,1,1,0,1,1,0,$FC,4,1,$FC,4,0,$60,1,$FC,7,0,1,$FC,5,0,1,$FC,7,0,1,1
		DB $FC,6,0,1,0,1,1,0,$89,1,0,0,$FC,4,1,0,1,0,1,1,0,$FC,5,1,0,$FC,4,1,0,1,0,0
		DB 1,0,0,0,1,$FC,4,0,1,0,1,0,$29,1,0,1,0,1,1,1,$FC,4,0,1,$FC,4,0,1,1,1,0,$FC
		DB 4,1,0,0,0,1,0,$11,1,$FC,4,0,1,1,0,1,1,0,$FC,4,1,0,0,$11,1,0,$FC,4,$21,$FC,4,1
		DB 0,1,0,0,$19,0,1,1,1,0,1,$FC,6,0,1,0,1,$21,$FC,8,0,1,0,1,$FC,5,0,$FC,4,1,0,1
		DB 0,1,1,0,1,1,1,$21,$FC,5,0,$71,1,0,1,0,1,1,0,$FC,4,1,$A8,0,0,0,1,0,1,1,0,0
		DB 0,1,$21,$FC,5,0,$71,1,0,0,0,1,9,0,$81,$FC,6,1,$60,1,0,0,0,1,1,0,1,$21,$FC,5,0,$71
		DB 1,1,1,0,1,1,0,$FC,5,1,0,1,0,1,1,1,0,0,1,$FC,8,0,$71,1,1,1,0,1,$FC,5,0,1
		DB 1,0,1,$FC,4,0,1,0,$FC,4,1,$FC,4,$21,0,1,0,0,1,0,1,0,0,$FC,5,1,0,0,0,1,1,0
		DB 1,0,0,0,$FC,6,1,0,1,$FC,5,0,1,$FC,4,0,1,1,$FC,6,0,1,0,1,0,0,0,1,1,0,0,0
		DB 1,0,1,1,1,0,0,1,1,0,1,0,0,1,1,0,1,1,0,1,0,0,1,1,0,1,1,0,1,1,1,$FC
		DB 4,0,1,0,1,$21,0,0,1,0,$11,1,0,1,1,0,1,0,0,1,1,$FC,7,0,1,0,0,1,1,0,0,1
		DB 0,1,0,1,$FC,4,0,1,0,1,0,0,$FC,$0B,1,$11,1,0,1,0,1,0,0,1,0,1,1,$60,1,1,$60,1
		DB $FC,5,0,1,1,$FC,4,0,1,$11,1,0,0,1,0,1,$60,1,0,0,1,0,0,1,0,0,1,0,0,1,1,$FC
		DB 4,0,1,1,$FC,6,0,1,0,1,0,$11,0,0,1,$68,1,0,1,0,1,0
		
; --- TELEPORT_MAP ---------------------------------------------
; @wip
; Per-dungeon-level teleport table (ADDR_TABLE slot $58, generically named
; 'city map address' there). Same $FC,count,value run-length encoding as
; CITY_MAP_DATA, contiguous in this file. Indexed by the *target level*:
;   - proc_teleport validates the chosen destination level d via
;     GET_D_FROM_TABLE $58 (sub-index d) and GET_A_FROM_TABLE $58 (d+8);
;     carry from either aborts the teleport.
;   - teleport_to_level reads it via GET_IY_A_FROM_TABLE $3B,$58 to pick the
;     tape block for that level (result +4 -> insert_skara_tape).
; Note: the decoded per-level record layout (the d / d+8 / $3B sub-fields)
;       is not yet carved out, hence @wip.
TELEPORT_MAP:
		DB 0,$FC,6,1,$FC,7,0,1,1,0
		DB 1,0,1,0,1,0,0,0,1,0,0,1,$FC,$0A,0,1,0,0,$21,$60,0,1,0,1,0,1,1,1,0,$A1,0,$68
		DB 0,$FC,$0B,1,$FC,4,0,$60,0,0,1,0,1,0,0,1,1,$78,0,0,1,1,$FC,$0B,0,1,1,1,$11,1,0,0
		DB 1,0,1,1,1,0,$FC,5,1,$FC,$10,0,$FC,4,1
