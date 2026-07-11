; --- GATE_TABLE -----------------------------------------------
; @done
; Four gate records {DB x, DB y, DB pass-through facing}. proc_iron_gate
; scans this for the record matching the party's coords; on a match it
; sets VAR_FACE_DIRECTION to the record's facing and steps through.
GATE_TABLE:
		DB 4,2,FACE_NORTH		; gate north of Mangar's coords + pass direction
		DB 2,4,FACE_EAST		; gate east of Mangar's coords
		DB $1B,$19,FACE_WEST	; gate west of Kylearan's coords
		DB $19,$1B,FACE_SOUTH	; gate south of Kylearan's coords
