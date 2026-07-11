; --- SPELL_DURATIONS ------------------------------------------
; @done
; Per-spell effect duration, 6 x 16-bit little-endian entries indexed
; by spell id. start_spell_or_song reads SPELL_DURATIONS[id*2] (low
; byte via GET_B_FROM_TABLE $23, high byte the next entry) and stores
; the 16-bit value in VAR_SPELL_DURATION; tick_spell_duration counts it
; down each round. (SONG_EFFECT_TABLE below is the song equivalent at
; index $24.)
; Referenced by: start_spell_or_song (ADDR_TABLE index $23)
SPELL_DURATIONS:
		DB $E0
		DB $2E
		DB $3A
		DB $20
		DB $52
		DB $1C
		DB $C2
		DB $33
		DB $E0
		DB $2E
		DB $98
		DB $3A

; --- SONG_EFFECT_TABLE ----------------------------------------
; @done
; 12 bytes = 6 x {DB $64, DB 0} — per-song effect value/duration
; ($64 = 100). Almost certainly the block reached via ADDR_TABLE
; index $24 (___table_5), read by start_song_effect.
; Referenced by: start_song_effect (ADDR_TABLE index $24)
SONG_EFFECT_TABLE:
		DB $64
		DB 0
		DB $64
		DB 0
		DB $64
		DB 0
		DB $64
		DB 0
		DB $64
		DB 0
		DB $64
		DB 0
