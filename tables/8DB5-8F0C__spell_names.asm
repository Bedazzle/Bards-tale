; --- SPELL_NAMES ----------------------------------------------
; @done
; The spellcaster spell-name dictionary: a stream of 4-letter spell
; codes (DB '4 chars', no separator) grouped by class and level. Each
; group ends with a bit-7 marker byte $F1..$F6 = level 1..6, $F0 = level
; 7 (end of class). process_spell walks this stream letter-by-letter
; matching the 4 chars typed into TEXT_BUFFER; when a $Fn byte is hit it
; advances the level ($Fn & $0F) and, on $F0, the class, deriving the
; matched spell's code / class / level. The 28 sub-labels
; (conjurer_L1..wizard_L7) name each class+level group in the stream;
; the four classes run conjurer, sorcerer, magician, wizard.
; Referenced by: process_spell (ld de,SPELL_NAMES)
SPELL_NAMES:

conjurer_L1:
		DB 'MAFL'	; MAGE FLAME
		DB 'ARFI'	; ARC FIRE
		DB 'SOSH'	; SORCERER SHIELD
		DB 'TRZP'	; TRAP ZAP
		DB $F1

conjurer_L2:
		DB 'FRFO'	; FREEZE FOES
		DB 'MACO'	; KIEL'S MAGIC COMPASS
		DB 'BASK'	; BATTLESKILL
		DB 'WOHL'	; WORD OF HEALING
		DB $F2

conjurer_L3:
		DB 'MAST'	; ARCYNE'S MAGESTAR
		DB 'LERE'	; LESSER REVELATION
		DB 'LEVI'	; LEVITATION
		DB 'WAST'	; WARSTRIKE
		DB $F3

conjurer_L4:
		DB 'INWO'	; ELIK'S INSTANT WOLF
		DB 'FLRE'	; FLESH RESTORE
		DB 'POST'	; POISON STRIKE
		DB $F4

conjurer_L5:
		DB 'GRRE'	; GREATER REVELATION
		DB 'WROV'	; WRATH OF VALHALLA
		DB 'SHSP'	; SHOCK-SPHERE
		DB $F5

conjurer_L6:
		DB 'INOG'	; ELIK'S INSTANT OGRE
		DB 'MALE'	; MAJOR LEVITATION
		DB $F6

conjurer_L7:
		DB 'FLAN'	; FLESH ANEW
		DB 'APAR'	; APPORT ARCANE
		DB $F0

		; ----------

sorcerer_L1:
		DB 'MIJA'	; MANGAR'S MIND JAB
		DB 'PHBL'	; PHASE BLUR
		DB 'LOTR'	; LOCATE TRAPS
		DB 'HYIM'	; HYPNOTIC IMAGE
		DB $F1

sorcerer_L2:
		DB 'DISB'	; DISBELIEVE
		DB 'TADU'	; TARGET DUMMY
		DB 'MIFI'	; MANGAR'S MIND FIST
		DB 'FEAR'	; WORD OF FEAR
		DB $F2

sorcerer_L3:
		DB 'WIWO'	; WIND WOLF
		DB 'VANI'	; KYLEARAN'S VANISHING SPELL
		DB 'SESI'	; SECOND SIGHT
		DB 'CURS'	; CURSE
		DB $F3

sorcerer_L4:
		DB 'CAEY'	; CAT EYES
		DB 'WIWA'	; WIND WARRIOR
		DB 'INVI'	; KYLEARAN'S INVISIBILITY SPELL
		DB $F4

sorcerer_L5:
		DB 'WIOG'	; WIND OGRE
		DB 'DIIL'	; DISRUPT ILLUSION
		DB 'MIBL'	; MANGAR'S MIND BLADE
		DB $F5

sorcerer_L6:
		DB 'WIDR'	; WIND DRAGON
		DB 'MIWP'	; MIND WARP
		DB $F6

sorcerer_L7:
		DB 'WIGI'	; WIND GIANT
		DB 'SOSI'	; SORCERER SIGHT
		DB $F0

		; ----------

magician_L1:
		DB 'VOPL'	; VORPAL PLATING
		DB 'AIAR'	; AIR ARMOUR
		DB 'STLI'	; SABHAR'S STEELIGHT
		DB 'SCSI'	; SCRY SIGHT
		DB $F1

magician_L2:
		DB 'HOWA'	; HOLY WATER
		DB 'WIST'	; WITHER STRIKE
		DB 'MAGA'	; MAGE GAUNTLETS
		DB 'AREN'	; AREA ENCHANT
		DB $F2

magician_L3:
		DB 'MYSH'	; YBARRA'S MYSTIC SHIELD
		DB 'OGST'	; OSCON'S OGRESTRENGTH
		DB 'MIMI'	; MITHRIL MIGHT
		DB 'STFL'	; STARFLARE
		DB $F3

magician_L4:
		DB 'SPTO'	; SPECTRE TOUCH
		DB 'DRBR'	; DRAGON BREATH
		DB 'STSI'	; SABHAR'S STONELIGHT SPELL
		DB $F4

magician_L5:
		DB 'ANMA'	; ANTI-MAGIC
		DB 'ANSW'	; AKER'S ANIMATED SWORD
		DB 'STTO'	; STONE TOUCH
		DB $F5

magician_L6:
		DB 'PHDO'	; PHASE DOOR
		DB 'YMCA'	; YBARRA'S MYSTICAL COAT OF ARMOUR
		DB $F6

magician_L7:
		DB 'REST'	; RESTORATION
		DB 'DEST'	; DEATH STRIKE
		DB $F0

		; ----------

wizard_L1:
		DB 'SUDE'	; SUMMON DEAD
		DB 'REDE'	; REPEL DEAD
		DB $F1

wizard_L2:
		DB 'LESU'	; LESSER SUMMONING
		DB 'DEBA'	; DEMON BANE
		DB $F2

wizard_L3:
		DB 'SUPH'	; SUMMON PHANTOM
		DB 'DISP'	; DISPOSSESS
		DB $F3

wizard_L4:
		DB 'PRSU'	; PRIME SUMMONING
		DB 'ANDE'	; ANIMATE DEAD
		DB $F4

wizard_L5:
		DB 'SPBI'	; BAYLOR'S SPELL BIND
		DB 'DMST'	; DEMON STRIKE
		DB $F5

wizard_L6:
		DB 'SPSP'	; SPELL SPRITE
		DB 'BEDE'	; BEYOND DEATH
		DB $F6

wizard_L7:
		DB 'GRSU'	; GREATER SUMMONING
		DB $F0
