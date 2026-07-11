; --- SPELL_COST -----------------------------------------------
; @done
; Spell-point cost per spell, 1 DB byte each, in the exact SPELL_NAMES
; order (conjurer -> sorcerer -> magician -> wizard, level 1..7). Direct
; byte lookup by spell index (uncompressed; ADDR_TABLE stores LABEL+1).
; check_spell_cost reads it to test the caster's remaining spell points.
; Referenced by: ADDR_TABLE index $65 - check_spell_cost
SPELL_COST:
		; ----------
		; conjurer
		; ----------
		; level 1
		DB 2	; MAGE FLAME
		DB 3	; ARC FIRE
		DB 3	; SORCERER SHIELD
		DB 2	; TRAP ZAP

		; level 2
		DB 3	; FREEZE FOES
		DB 3	; KIEL'S MAGIC COMPASS
		DB 4	; BATTLESKILL
		DB 4	; WORD OF HEALING

		; level 3
		DB 5	; ARCYNE'S MAGESTAR
		DB 5	; LESSER REVELATION
		DB 4	; LEVITATION
		DB 5	; WARSTRIKE

		; level 4
		DB 6	; ELIK'S INSTANT WOLF
		DB 6	; FLESH RESTORE
		DB 6	; POISON STRIKE

		; level 5
		DB 7	; GREATER REVELATION
		DB 7	; WRATH OF VALHALLA
		DB 7	; SHOCK-SPHERE

		; level 6
		DB 9	; ELIK'S INSTANT OGRE
		DB 8	; MAJOR LEVITATION

		; level 7
		DB $0C	; FLESH ANEW
		DB $0F	; APPORT ARCANE

		; ----------
		; sorcerer
		; ----------
		; level 1
		DB 3	; MANGAR'S MIND JAB
		DB 2	; PHASE BLUR
		DB 2	; LOCATE TRAPS
		DB 3	; HYPNOTIC IMAGE

		; level 2
		DB 4	; DISBELIEVE
		DB 4	; TARGET DUMMY
		DB 4	; MANGAR'S MIND FIST
		DB 4	; WORD OF FEAR

		; level 3
		DB 5	; WIND WOLF
		DB 6	; KYLEARAN'S VANISHING SPELL
		DB 6	; SECOND SIGHT
		DB 5	; CURSE

		; level 4
		DB 7	; CAT EYES
		DB 6	; WIND WARRIOR
		DB 7	; KYLEARAN'S INVISIBILITY SPELL

		; level 5
		DB 7	; WIND OGRE
		DB 8	; DISRUPT ILLUSION
		DB 8	; MANGAR'S MIND BLADE

		; level 6
		DB $0A	; WIND DRAGON
		DB 9	; MIND WARP

		; level 7
		DB $0C	; WIND GIANT
		DB $0B	; SORCERER SIGHT

		; ----------
		; magician
		; ----------
		; level 1
		DB 3	; VORPAL PLATING
		DB 3	; AIR ARMOUR
		DB 2	; SABHAR'S STEELIGHT
		DB 2	; SCRY SIGHT

		; level 2
		DB 4	; HOLY WATER
		DB 5	; WITHER STRIKE
		DB 5	; MAGE GAUNTLETS
		DB 5	; AREA ENCHANT

		; level 3
		DB 6	; YBARRA'S MYSTIC SHIELD
		DB 6	; OSCON'S OGRESTRENGTH
		DB 7	; MITHRIL MIGHT
		DB 6	; STARFLARE

		; level 4
		DB 8	; SPECTRE TOUCH
		DB 7	; DRAGON BREATH
		DB 7	; SABHAR'S STONELIGHT SPELL

		; level 5
		DB 8	; ANTI-MAGIC
		DB 8	; AKER'S ANIMATED SWORD
		DB 8	; STONE TOUCH

		; level 6
		DB 9	; PHASE DOOR
		DB $0A	; YBARRA'S MYSTICAL COAT OF ARMOUR

		; level 7
		DB $0C	; RESTORATION
		DB $0E	; DEATH STRIKE

		; ----------
		; wizard
		; ----------
		; level 1
		DB 6	; SUMMON DEAD
		DB 4	; REPEL DEAD

		; level 2
		DB 8	; LESSER SUMMONING
		DB 8	; DEMON BANE

		; level 3
		DB $0A	; SUMMON PHANTOM
		DB $0A	; DISPOSSESS

		; level 4
		DB $0C	; PRIME SUMMONING
		DB $0B	; ANIMATE DEAD

		; level 5
		DB $0E	; BAYLOR'S SPELL BIND
		DB $0D	; DEMON STRIKE

		; level 6
		DB $0F	; SPELL SPRITE
		DB $12	; BEYOND DEATH

		; level 7
		DB $16	; GREATER SUMMONING
		; ----------
