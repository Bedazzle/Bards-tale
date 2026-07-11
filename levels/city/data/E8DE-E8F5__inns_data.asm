; --- inns_data -------------------------------------------------
; @done
; The 7 city inns: 7 records of {DB so_no, DB we_ea, DB id}. find_inn
; scans it for a coordinate match at the party's position and prints the
; matching inn name; the id ($44-$4A) selects the name/behaviour.
; Referenced by: find_inn (ld hl,inns_data).
inns_data:
		DB 5,$1C,$44	; Scarlet Bard Coords +	Identifier
		DB $13,$17,$45	; Sinister Inn Coords + ID
		DB 7,$15,$46	; Dragon's Breath Coords + ID
		DB 6,$14,$47	; Ask Y'Mother Coords + ID
		DB 1,$14,$48	; Archmage Inn Coords + ID
		DB 8,1,$49	; Skull Tavern Coords + ID
		DB $12,$0B,$4A	; Drawn Blade Coords + ID

; --- default_inn -----------------------------------------------
; @done
; Fallback inn record {DB $FF,$FF,0} used when no inn coordinate matches;
; byte +2 is self-modified by find_inn so an unmatched search still prints.
; Referenced by: find_inn (default_inn + 2 patched).
default_inn:
		DB $FF,$FF,0
