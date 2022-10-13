		debug "___table_22: "
SPELL_TYPES:
		db  1Ch		; MAFL - light
		db  0Bh		; ARFI - combat 1 foe
		db  0Ch		; SOSH - combat, self shield (buff)
		db  14h		; TRZP - trap zap
		db  0Ah		; FRFO - combat, group
		db  1Ch		; MACO - magic compass
		db    8		; BASK - combat, 1 char (buff)
		db  19h		; WOHL - healing, 1 char
		db  0Ah		; MAST - combat, group
		db  1Ch		; LERE - light
		db  1Dh		; LEVI - levitation
		db  8Ah		; WAST - combat, group
		db  1Ch		; INWO - summon special: wolf
		db  99h		; FLRE - healing, 1 char
		db  0Bh		; POST - combat, 1 foe (poison)
		db  1Ch		; GRRE - light
		db    8		; WROV - combat, 1 char (buff)
		db  4Ah		; SHSP - combat, group
		db  1Ch		; INOG - summon special: Ogre
		db  1Dh		; MALE - Major levitation
		db  9Dh		; FLAN - Healing, party
		db  1Ch		; APAR - teleport party		-- end Conjuror spells
		db  8Bh		; MIJA - combat, 1 foe     -- start sorcerer spells
		db  0Dh		; PHBL - combat, PARTY (buff)
		db  1Ch		; LOTR - locate traps
		db  0Ah		; HYIM - Combat, group (debuff) 
		db  0Dh		; DISB - Combat, party buff
		db  1Ch		; TADU - Combat, summon special: Dummy
		db  8Bh		; MIFI - combat, 1 Foe
		db  0Ah		; FEAR - combat, group (debuff)
		db  1Ch		; WIWO - summon special: Wolf (illusion)
		db  0Ch		; VANI - combat, self buff
		db  9Ch		; SESI - Second Sight
		db  0Ah		; CURS - group, combat (debuff)
		db  1Dh		; CAEY - light
		db  1Ch		; WIWA - summon special: Mercenary (illusion)
		db  0Dh		; INVI - combat, party buff
		db  1Ch		; WIOG - summon special: Ogre (illusion)
		db  0Dh		; DIIL - combat, party buff
		db  8Eh		; MIBL - combat, All foes (offensive)
		db  1Ch		; WIDR - summon special: Red Dragon (illusion)
		db  0Bh		; MIWP - character buff/debuff
		db  1Ch		; WIGI - summon special: Giant (illusion)
		db  9Ch		; SOSI - Sorcerer Sight			-- end sorcerer spells
		db    8		; VOPL - Combat, char buff  		-- start magician spells
		db  0Ch		; AIAR - Combat, self buff
		db  1Ch		; STLI - Light
		db  14h		; SCSI - Scry Sight
		db  6Bh		; HOWA - combat, 1 foe (note - this often doesn't work)
		db  0Bh		; WIST - combat, 1 foe debuff
		db    8		; MAGA - combat, char buff
		db  5Ch		; AREN - Area Enchant
		db  1Dh		; MYSH - party, buff (armour)
		db    9		; OGST - combat, char buff
		db  0Dh		; MIMI - combat, party buff
		db  0Ah		; STFL - combat, group (offensive)
		db  6Bh		; SPTO - combat, 1 foe (offensive)
		db  0Ah		; DRBR - combat, group (offensive)
		db  1Ch		; STSI - light
		db  0Dh		; ANMA - combat, party buff
		db  0Dh		; ANSW - combat, summon special: Joe the Sword
		db  0Bh		; STTO - combat, 1 foe (offensive)
		db  14h		; PHDO - Phase Door
		db  1Dh		; YMCA - party, buff (armour)
		db  9Dh		; REST - party, heal all
		db  0Bh		; DEST - combat, 1 foe (critical hit)    - end magician spells
		db  1Dh		; SUDE - summon special: zombie/skeleton - start wizard spells	
		db  0Ah		; REDE - combat, group (offensive)*
		db  1Dh		; LESU - summon special: lesser demon
		db  2Bh		; DEBA - combat, 1 foe (offensive)*
		db  1Dh		; SUPH - summon special: ghost
		db 0D8h		; DISP - character, buff
		db  1Dh		; PRSU - summon special: Demon
		db  18h		; ANDE - Animate Dead
		db  0Ah		; SPBI - combat, 1 foe (spell bind)
		db  2Ah		; DMST - combat, group (offensive)*
		db  1Dh		; SPSP - summon special: lich/spectre
		db 0F8h		; BEDE - Resurrect Char
		db  1Dh		; GRSU - summon special: Greater Demon/Demon Lord -- end wizard spells
		db  2Ah		; Bard Song or non-spell book summoning?
		db  0Ah		;
		db  0Ah		;
		db  0Ah		;
		db  4Ah		;
		db  6Ah		;
		db  6Ah		;
		db  0Ah		;
		db  8Ah		;
		db 0AAh		;
		db 0CAh		;
		db  1Ch		;
		db  1Ch		;
		db 0FCh		;
		db  0Dh		;
		db  1Dh		; end Bard Song or non-spell book summoning spells... (95 in total)
