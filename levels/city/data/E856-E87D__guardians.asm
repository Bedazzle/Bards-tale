; --- GUARDIAN_FACE_DIR -----------------------------------------
; @done
; Required approach/facing direction (0-3) for each of the 10 city gate
; guardians, parallel to GUARDIANS / GUARDIAN_COORDS. proc_guardian reads
; it with GET_E_FROM_TABLE $10 (e = guardian index) and compares against
; VAR_FACE_DIRECTION: matching means the party faces the guarded gate.
; Referenced by: ADDR_TABLE index $10 (proc_guardian / describe_guardian).
GUARDIAN_FACE_DIR:
		DB 3
		DB 3
		DB 1
		DB 2
		DB 0
		DB 0
		DB 0
		DB 0
		DB 0
		DB 3

; --- GUARDIANS -------------------------------------------------
; @done
; Guardian type/id for each of the 10 city gate guardians (GUARD_* enum),
; parallel to GUARDIAN_COORDS / GUARDIAN_FACE_DIR. Read with
; GET_E_FROM_TABLE INX_GUARDIANS ($11); the value is stashed in
; ACTIVE_GUARDIAN and drives the 'statue of a ...' description and combat.
; Referenced by: ADDR_TABLE index $11 (proc_guardian / describe_guardian).
GUARDIANS:
		DB GUARD_STONE_GIANT
		DB GUARD_GOLEM
		DB GUARD_GREY_DRAGON
		DB GUARD_GOLEM
		DB GUARD_OGRE_LORD
		DB GUARD_OGRE_LORD
		DB GUARD_OGRE_LORD
		DB GUARD_SAMURAI
		DB GUARD_STONE_GIANT
		DB GUARD_STONE_GIANT

; --- GUARDIAN_COORDS -------------------------------------------
; @done
; Map coordinates of the 10 city gate guardians: 10 records of
; {DB so_no, DB we_ea}. describe_guardian scans this against the party's
; position to find which guardian (index e) is being approached.
; Referenced by: describe_guardian (ld hl,GUARDIAN_COORDS).
GUARDIAN_COORDS:
		DB $1A,4		; Stone Giant near Castle
		DB $1A,6		; Golem North of Castle
		DB $18,6		; Grey Dragon outside of Castle
		DB $16,6		; Golem SE of Castle
		DB $0E,3		; Ogre Lord Near City Gates
		DB 6,3		; Ogre Lord Near Mangar's Tower
		DB 6,6		; Ogre Lord Near Mangar's Tower
		DB 6,$1B		; Samurai near Scarlet Bard Inn
		DB 3,$16		; Stone Giant in SE of City
		DB 2,$15		; Stone Giant in SE of City
