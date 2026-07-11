; --- SUMMON_CREAT ---------------------------------------------
; @done
; Monster-id table for summon effects, 1 DB byte per summon entry:
; the creature index conjured into the party's monster-ally slot.
; Split into spell-summoned creatures (Wolf, Ogre, ... with 0/2 marker
; bytes separating real vs illusion groups) followed by item-summoned
; creatures. spell_summon_monster reads it (GET_B / GET_E FROM_TABLE)
; to pick which monster to summon.
; Referenced by: ADDR_TABLE index $62 (INX_SUMMON_CREAT) - spell_summon_monster
		debug "SUMMON_CREAT: "
SUMMON_CREAT:		; ___table_36:
		DB $10		; 16 = Wolf (INWO)
		DB $1D		; 29 = Ogre (INOG)
		DB 0		; sep or 0 for real?
		DB $0F		; 15 = Mercenary (WIWA)
		DB $65		; 101 = Red Dragon (WIDR)
		DB $79		; 121 = Storm Giant (WIGI)
		DB 2		; sep or 2 for illusion?
		DB $0A		; 10 = skeleton (SUDE)
		DB $14		; 20 = zombie (SUDE)
		DB $4E		; 78 = Lesser Demon (LESU)
		DB $33		; 51 = Ghoul (SUPH)
		DB $3C		; 60 = Wraith (SUPH)
		DB $5F		; 95 = Demon (PRSU)
		DB $7C		; 124 = Lich (SPSP)
		DB $6B		; 107 = Spectre (SPSP)
		DB $6F		; 111 = Greater Demon(GRSU)
		DB $7E		; 126 = Demon Lord (GRSU)
		DB $3B		; 59 = Green Dragon (item)
		DB $55		; 85 = War Giant (item)
		DB $1D		; 29 = Ogre (item)
		DB $62		; 98 = Mongo (item)
		DB $4F		; 79 = Fred (item)
		DB $7F		; 127 = Old Man (item)
		DB $6B		; 107 = Spectre (item)
		DB 4		; 4 = Dwarf (item)
		DB $70		; 112 = Master Wizard (item)
		DB $7C		; 124 = Lich (item)
		DB $19		; 25 = Samuari (item)
		DB $66		; 102 = Titan (item)
		DB $5D		; 93 = Golem (item)
