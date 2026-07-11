; --- CLASS_HP_GAIN_MASK ---------------------------------------
; @done
; Per-class HP-gain bit-mask, 10 bytes indexed by class 0-9
; ($0F,7,7,3,3,7,$0F,$0F,$0F,7). On level-up (do_advancement) the
; new HP added to CHAR_COND is RND_NUMBERS masked with this value, so
; warriors ($0F = 0-15) gain more than spell casters (3 = 0-3).
; Referenced by: do_advancement (ADDR_TABLE index $0E)
CLASS_HP_GAIN_MASK:
		DB $0F
		DB 7
		DB 7
		DB 3
		DB 3
		DB 7
		DB $0F
		DB $0F
		DB $0F
		DB 7

; --- CASTER_LEVEL_FIELD ---------------------------------------
; @done
; Maps a spellcaster class to the CHAR record offset of its
; spell-level field: 4 bytes ($43,$40,$41,$42) indexed by caster
; type-1. $40/$41/$42 = CHAR_SORC/CONJ/MAGI_LEVEL, $43 = the 4th
; caster's level field. do_spell_acquire/do_class_change look up the
; offset then GET_ATTR_BY_A to read the hero's current spell level.
; Referenced by: do_spell_acquire, do_class_change (ADDR_TABLE index $0D)
CASTER_LEVEL_FIELD:
		DB $43
		DB $40
		DB $41
		DB $42

; --- SPELL_LEVEL_COST -----------------------------------------
; @done
; Gold cost to learn each spell level, indexed by spell level
; (0,$0B,$13,$23,$3B,$53,... - rises with level). do_spell_acquire
; prints "spell level N will cost thee <this> in gold" and compares
; it against the hero's gold (store_bcd_and_compare) before charging.
; Note: cost byte is expanded to a BCD amount by the print/compare path.
; Referenced by: do_spell_acquire (ADDR_TABLE index $0C)
SPELL_LEVEL_COST:
		DB 0
		DB $0B
		DB $13
		DB $23
		DB $3B
		DB $53
		DB $14
