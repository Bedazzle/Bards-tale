; --- SPELL_TYPES ----------------------------------------------
; @done
; Per-spell effect/target descriptor byte, 1 DB each, in SPELL_NAMES
; order (82 spells) plus ~13 trailing bard-song / non-book summon
; entries (95 total). Direct byte lookup by spell index. The low bits
; select the effect class (e.g. $1C light, $1D levitation/summon,
; $0A combat group, $0B combat 1 foe, $0C/$0D buff, $19 heal); bit 7
; flags the offensive / area-effect variant (select_spell_target tests
; mask $69 bit 7: value >= 4 => group/area).
; Referenced by: ADDR_TABLE index $69 - cast_spell, who_cast_spell,
;                spell_heal_and_cure (GET_IY_A_FROM_TABLE $4B,$69),
;                select_spell_target, use_item (CHECK_ITEM_MASK $69,7)
		debug "___table_22: "
SPELL_TYPES:
		DB $1C		; MAFL - light
		DB $0B		; ARFI - combat 1 foe
		DB $0C		; SOSH - combat, self shield (buff)
		DB $14		; TRZP - trap zap
		DB $0A		; FRFO - combat, group
		DB $1C		; MACO - magic compass
		DB 8		; BASK - combat, 1 char (buff)
		DB $19		; WOHL - healing, 1 char
		DB $0A		; MAST - combat, group
		DB $1C		; LERE - light
		DB $1D		; LEVI - levitation
		DB $8A		; WAST - combat, group
		DB $1C		; INWO - summon special: wolf
		DB $99		; FLRE - healing, 1 char
		DB $0B		; POST - combat, 1 foe (poison)
		DB $1C		; GRRE - light
		DB 8		; WROV - combat, 1 char (buff)
		DB $4A		; SHSP - combat, group
		DB $1C		; INOG - summon special: Ogre
		DB $1D		; MALE - Major levitation
		DB $9D		; FLAN - Healing, party
		DB $1C		; APAR - teleport party		-- end Conjuror spells
		DB $8B		; MIJA - combat, 1 foe     -- start sorcerer spells
		DB $0D		; PHBL - combat, PARTY (buff)
		DB $1C		; LOTR - locate traps
		DB $0A		; HYIM - Combat, group (debuff) 
		DB $0D		; DISB - Combat, party buff
		DB $1C		; TADU - Combat, summon special: Dummy
		DB $8B		; MIFI - combat, 1 Foe
		DB $0A		; FEAR - combat, group (debuff)
		DB $1C		; WIWO - summon special: Wolf (illusion)
		DB $0C		; VANI - combat, self buff
		DB $9C		; SESI - Second Sight
		DB $0A		; CURS - group, combat (debuff)
		DB $1D		; CAEY - light
		DB $1C		; WIWA - summon special: Mercenary (illusion)
		DB $0D		; INVI - combat, party buff
		DB $1C		; WIOG - summon special: Ogre (illusion)
		DB $0D		; DIIL - combat, party buff
		DB $8E		; MIBL - combat, All foes (offensive)
		DB $1C		; WIDR - summon special: Red Dragon (illusion)
		DB $0B		; MIWP - character buff/debuff
		DB $1C		; WIGI - summon special: Giant (illusion)
		DB $9C		; SOSI - Sorcerer Sight			-- end sorcerer spells
		DB 8		; VOPL - Combat, char buff  		-- start magician spells
		DB $0C		; AIAR - Combat, self buff
		DB $1C		; STLI - Light
		DB $14		; SCSI - Scry Sight
		DB $6B		; HOWA - combat, 1 foe (note - this often doesn't work)
		DB $0B		; WIST - combat, 1 foe debuff
		DB 8		; MAGA - combat, char buff
		DB $5C		; AREN - Area Enchant
		DB $1D		; MYSH - party, buff (armour)
		DB 9		; OGST - combat, char buff
		DB $0D		; MIMI - combat, party buff
		DB $0A		; STFL - combat, group (offensive)
		DB $6B		; SPTO - combat, 1 foe (offensive)
		DB $0A		; DRBR - combat, group (offensive)
		DB $1C		; STSI - light
		DB $0D		; ANMA - combat, party buff
		DB $0D		; ANSW - combat, summon special: Joe the Sword
		DB $0B		; STTO - combat, 1 foe (offensive)
		DB $14		; PHDO - Phase Door
		DB $1D		; YMCA - party, buff (armour)
		DB $9D		; REST - party, heal all
		DB $0B		; DEST - combat, 1 foe (critical hit)    - end magician spells
		DB $1D		; SUDE - summon special: zombie/skeleton - start wizard spells	
		DB $0A		; REDE - combat, group (offensive)*
		DB $1D		; LESU - summon special: lesser demon
		DB $2B		; DEBA - combat, 1 foe (offensive)*
		DB $1D		; SUPH - summon special: ghost
		DB $D8		; DISP - character, buff
		DB $1D		; PRSU - summon special: Demon
		DB $18		; ANDE - Animate Dead
		DB $0A		; SPBI - combat, 1 foe (spell bind)
		DB $2A		; DMST - combat, group (offensive)*
		DB $1D		; SPSP - summon special: lich/spectre
		DB $F8		; BEDE - Resurrect Char
		DB $1D		; GRSU - summon special: Greater Demon/Demon Lord -- end wizard spells
		DB $2A		; Bard Song or non-spell book summoning?
		DB $0A		;
		DB $0A		;
		DB $0A		;
		DB $4A		;
		DB $6A		;
		DB $6A		;
		DB $0A		;
		DB $8A		;
		DB $AA		;
		DB $CA		;
		DB $1C		;
		DB $1C		;
		DB $FC		;
		DB $0D		;
		DB $1D		; end Bard Song or non-spell book summoning spells... (95 in total)
