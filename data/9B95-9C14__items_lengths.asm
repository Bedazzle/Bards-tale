; --- INDEX_ITEM_LENGTHS ---------------------------------------
; @done
; Item-name length table for the 5-bit packed-text decoder, parallel to
; INDEX_ITEM_NAMES. 128 bytes: [0]=0 (item 0 = none); [1..127] give each
; item name's length in 5-bit symbols (short names are uncompressed, so
; this equals the character count, e.g. "Torch"=5). Same len*5/8 skip as
; messages_table. The trailing `; N: Name` comments name each item id.
; Referenced by: set_item_tables (BT_game) -> print_msg_no_cp
;               (hl=INDEX_ITEM_LENGTHS, de=INDEX_ITEM_NAMES).
INDEX_ITEM_LENGTHS:
		DB 0	; 0:
		DB 5	; 1: Torch
		DB 4	; 2: Lamp
		DB 10	; 3: Broadsword
		DB 12	; 4: Short Sword
		DB 6	; 5: Dagger
		DB 8	; 6: War Axe
		DB 7	; 7: Halbard
		DB 4	; 8: Mace
		DB 5	; 9: Staff
		DB 7	; 10: Buckler
		DB 13	; 11: Tower Shield
		DB 14	; 12: Leather Armor
		DB 11	; 13: Chain Mail
		DB 12	; 14: Scale Armor
		DB 12	; 15: Plate Armor
		DB 5	; 16: Robes
		DB 4	; 17: Helm
		DB 15	; 18: Leather Gloves
		DB 9	; 19: Gauntlets
		DB 8	; 20: Mandolin
		DB 4	; 21: Harp
		DB 5	; 22: Flute
		DB 11	; 23: Mthr Sword
		DB 12	; 24: Mthr Shield
		DB 11	; 25: Mthr Chain
		DB 11	; 26: Mthr Scale
		DB 12	; 27: Samurai Fgn
		DB 12	; 28: Bracers [6]
		DB 9	; 29: Bardsword
		DB 10	; 30: Fire Horn
		DB 9	; 31: Lightwand
		DB 12	; 32: Mthr Dagger
		DB 10	; 33: Mthr Helm
		DB 12	; 34: Mthr Gloves
		DB 9	; 35: Mthr Axe
		DB 10	; 36: Mthr Mace
		DB 11	; 37: Mthr Plate
		DB 9	; 38: Ogre Fgn
		DB 13	; 39: Lak's Lyre
		DB 12	; 40: Shield Ring
		DB 10	; 41: Dork Ring
		DB 14	; 42: Fin's Flute
		DB 13	; 43: Kael's Axe
		DB 10	; 44: Blood Axe
		DB 8	; 45: Dayblade
		DB 13	; 46: Shield Staff
		DB 10	; 47: Elf Cloak
		DB 9	; 48: Hawkblade
		DB 11	; 49: Admt Sword
		DB 12	; 50: Admt Shield
		DB 12	; 51: Admt Dagger
		DB 10	; 52: Admt Helm
		DB 12	; 53: Admt Gloves
		DB 10	; 54: Admt Mace
		DB 5	; 55: Broom
		DB 9	; 56: Pureblade
		DB 8	; 57: Exorwand
		DB 15	; 58: Ali's Carpet
		DB 12	; 59: Magic Mouth
		DB 10	; 60: Luckshield
		DB 10	; 61: Giant Fgn
		DB 11	; 62: Admt Chain
		DB 11	; 63: Admt Scale
		DB 11	; 64: Admt Plate
		DB 12	; 65: Bracers [4]
		DB 9	; 66: Arcshield
		DB 12	; 67: Pure Shield
		DB 11	; 68: Mage Staff
		DB 10	; 69: War Staff
		DB 13	; 70: Theif Dagger
		DB 10	; 71: Soul Mace
		DB 13	; 72: Wither Staff
		DB 11	; 73: Sorcerstaff
		DB 13	; 74: Sword of Pak
		DB 10	; 75: Heal Harp
		DB 15	; 76: Galt's Flute
		DB 11	; 77: Frost Horn
		DB 11	; 78: Dmnd Sword
		DB 12	; 79: Dmnd Shield
		DB 12	; 80: Dmnd Dagger
		DB 10	; 81: Dmnd Helm
		DB 10	; 82: Golem Fgn
		DB 10	; 83: Titan Fgn
		DB 11	; 84: Conjurstaff
		DB 15	; 85: Arc's Hammer
		DB 13	; 86: Staff of Lor
		DB 10	; 87: Powerstaff
		DB 10	; 88: Mournblade
		DB 12	; 89: Dragonshield
		DB 11	; 90: Dmnd Plate
		DB 9	; 91: Wargloves
		DB 8	; 92: Lorehelm
		DB 10	; 93: Dragonwand
		DB 17	; 94: Kiels Compass
		DB 10	; 95: Speedboots
		DB 11	; 96: Flame Horn
		DB 9	; 97: Truthdrum
		DB 10	; 98: Spiritdrum
		DB 13	; 99: Pipes of Pan
		DB 14	; 100: Ring of Power
		DB 9	; 101: Deathring
		DB 12	; 102: Ybarrashield
		DB 13	; 103: Spectre Mace
		DB 10	; 104: Dag Stone
		DB 12	; 105: Arc's Eye
		DB 8	; 106: Ogrewand
		DB 10	; 107: Spirithelm
		DB 11	; 108: Dragon Fgn
		DB 9	; 109: Mage Fgn
		DB 11	; 110: Troll Ring
		DB 12	; 111: Troll Staff
		DB 9	; 112: Onyx Key
		DB 14	; 113: Crystal Sword
		DB 10	; 114: Stoneblade
		DB 10	; 115: Travelhelm
		DB 13	; 116: Death Dagger
		DB 10	; 117: Mongo Fgn
		DB 9	; 118: Lich Fgn
		DB 3	; 119: Eye
		DB 11	; 120: Master Key
		DB 8	; 121: WizWand
		DB 13	; 122: Silvr Square
		DB 13	; 123: Silvr Circle
		DB 13	; 124: Silvr Triang
		DB 9	; 125: Thor Fgn
		DB 13	; 126: Old Man Fgn
		DB 14	; 127: Spectre Snare
