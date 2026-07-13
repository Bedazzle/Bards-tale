; values are extracted with GET_..._FROM_TABLE

; --- ADDR_TABLE ------------------------------------------------
; @done
; Master pointer table for the City overlay. Each slot is a DW holding
; (label + 1): the address of a data block or RAM buffer, biased by +1
; so the RST 10h GET_*_FROM_TABLE handlers (code/8CCD get_*_from_table)
; can index it with a 1-based register offset. The engine selects a slot
; by the byte that follows a GET_x_FROM_TABLE call and returns table[reg].
; Slots 0x75-0x91 live in the PICTURE_POINTERS sub-table below.
; Referenced by: RST 10h GET_A/B/C/D/E/H/L_FROM_TABLE dispatchers.
ADDR_TABLE:
		DW BARD_TUNE_TABLE + 1		; 00 (0)
		DW ___table_99 + 1		; 01 (1)
		DW COMBAT_SPEED_TABLE + 1		; 02 (2)
		DW SCRATCH_BUFFER + 1		; 03 (3)
		DW RACE_STAT_BASE + 1		; 04 (4)
		DW SLOT_SCREEN_ROW + 1		; 05 (5)
		DW ICON_SCREEN_POS + 1		; 06 (6)
		DW SLOT_SCREEN_COL + 1		; 07 (7)
		DW SLOT_SPRITE_ID + 1		; 08 (8)
		DW CELL_PICTURE_MAP + 1		; 09 (9)
		DW PROCS_3 + 1			; 0A (10)
		DW BARKEEP_RUMORS + 1		; 0B (11)
		DW SPELL_LEVEL_COST + 1		; 0C (12)
		DW CASTER_LEVEL_FIELD + 1		; 0D (13)
		DW CLASS_HP_GAIN_MASK + 1		; 0E (14)
		DW PICTURE_POINTERS + 1		; 0F (15)
		DW GUARDIAN_FACE_DIR + 1		; 10 (16)
		DW GUARDIANS + 1		; 11 (17)
		DW TEMPLE_HEAL_COST + 1		; 12 (18)
		DW ITEM_PRICES + 1		; 13 (19)
		DW KEY_CODES_TABLE + 1		; 14 (20)
		DW ___table_46 + 1		; 15 (21)
		DW PARTY_FILE + 1		; 16 (22)
		DW SPELL_REVEAL_STATE + 1		; 17 (23)
		DW SPELL_LIGHT_STATE + 1		; 18 (24)
		DW SPELL_SECRET_STATE + 1		; 19 (25)
		DW SPELL_CARPET_STATE + 1		; 1A (26)
		DW SPELL_COMPASS_STATE + 1		; 1B (27)
		DW SPELL_EYE_STATE + 1		; 1C (28)
		DW SPELL_SHIELD_STATE + 1		; 1D (29)
		DW SCRATCH_BUFFER + 1		; 1E (30)
		DW SCRATCH_BUFFER + 1		; 1F (31)
		DW SPELL_AC_DELTA + 1		; 20 (32)
		DW MOD_STAT_21_AMOUNT + 1		; 21 (33)
		DW MOD_STAT_22_AMOUNT + 1		; 22 (34)
		DW SPELL_DURATIONS + 1		; 23 (35)
		DW SONG_EFFECT_TABLE + 1		; 24 (36)
		DW PROCS_2 + 1			; 25 (37)
		DW SPELL_HANDLER_INDEX + 1		; 26 (38)
		DW ___table_40 + 1		; 27 (39)
		DW GOLD_ROLL_MASK_LO + 1		; 28 (40)
		DW GOLD_ROLL_MASK_HI + 1		; 29 (41)
		DW HIT_GROUP_KILLS + 1		; 2A (42)
		DW HIT_GROUP_LIST + 1		; 2B (43)
		DW GROUP_ATK_MOD + 1		; 2C (44)
		DW GROUP_AC_MOD + 1		; 2D (45)
		DW GROUP_DMG_MOD + 1		; 2E (46)
		DW ALLY_DATA + 1		; 2F (47)
		DW FD7A_ANCHOR + 1		; 30 (48)
		DW ACTIONS_PROCS + 1	; 31 (49)
		DW ACTIONS_KEYS + 1		; 32 (50)
		DW STAT_DISPLAY_TABLE + 1		; 33 (51)
		DW TEXT_BUFFER + 1		; 34 (52)
		DW AI_SPELL_CODES + 1		; 35 (53)
		DW COMBAT_ACTIVE_FLAG + 1		; 36 (54)
		DW ENEMY + 1			; 37 (55)
		DW COMBAT_INITIATIVE + 1		; 38 (56)
		DW OPTION_AVAIL_MASK + 1		; 39 (57)
		DW HERO_QUEUED_ITEM + 1		; 3A (58)
		DW HERO_CAST_STATE + 1		; 3B (59)
		DW HERO_QUEUED_SPELL + 1		; 3C (60)
		DW PALADIN_AC_BY_LEVEL + 1		; 3D (61)
		DW CLASS_AC_BONUS + 1		; 3E (62)
		DW ITEM_STATE_MARKERS + 1		; 3F (63)
		DW COMBAT_UI_TEXT + 1		; 40 (64)
		DW ACTIVE_GUARDIAN + 1		; 41 (65)
		DW GROUP_ILLUSION_FLAG + 1		; 42 (66)
		DW DAYPART_DMG_SCALE + 1		; 43 (67)
		DW MONST_HP_AC + 1		; 44 (68)
		DW ALLY_STATE + 1		; 45 (69) C228
		DW CLASS_EQUIP_MASK + 1		; 46 (70)
		DW ITEM_EQUIP + 1		; 47 (71)
		DW GUARDIAN_TYPE + 1		; 48 (72)
		DW XP_CLASS_THRESHOLDS + 1		; 49 (73)
		DW SPELL_HANDLER_PARAM + 1		; 4A (74)
		DW DICE_SIDES_TABLE + 1		; 4B (75)
		DW CLASS_TO_HIT_BONUS + 1		; 4C (76)
		DW DAMAGE_DICE_MASK + 1		; 4D (77)
		DW SWAP_STAT_TEMPLATE + 1		; 4E (78)
		DW DAYPART_ROLL_MASK + 1		; 4F (79)
		DW DAYPART_ROLL_ADD + 1		; 50 (80)
		DW DISPLAY_PALETTE + 1		; 51 (81)
		DW SCRATCH_BUFFER + 1		; 52 (82)
		DW SCRATCH_BUFFER + 1		; 53 (83)
		DW SCRATCH_BUFFER + 1		; 54 (84)
		DW GROUP_AC_MOD2 + 1		; 55 (85)
		DW HERO_ACTION_CODE + 1		; 56 (86)
		DW GROUP_TURN_SKIP + 1		; 57 (87)
		DW TELEPORT_MAP + 1		; 58 (88)	(city map address)
		DW ___table_28 + 1		; 59 (89)
		DW MONST_IMAGE + 1		; 5A (90)
		DW ___table_27 +1		; 5B (91)
		DW SPELL_ATTACK_BONUS + 1		; 5C (92)
		DW MOD_STAT_5D_AMOUNT + 1		; 5D (93)
		DW SOME_BUFF + 1		; 5E (94)
		DW RANGE_VALUES + 1		; 5F (95)
		DW REVEAL_DURAT + 1		; 60 (96)
		DW LIGHT_DURAT + 1		; 61 (97)
		DW SUMMON_CREAT + 1		; 62 (98)
		DW SUMMON_DATA + 1		; 63 (99)
		DW RND_RANGE_MASKS + 1		; 64 (100)
		DW SPELL_COST + 1		; 65 (101)
		DW STATUSES + 1			; 66 (102)
		DW ITEM_EFFECTS + 1		; 67 (103)
		DW WEAPON_DAMAGE + 1	; 68 (104)
		DW SPELL_TYPES + 1		; 69 (105)
		DW ITEM_SPELL_CODES + 1		; 6A (106)
		DW ITEM_SPECATT + 1		; 6B (107)
		DW MONK_BAREHAND_DAMAGE + 1		; 6C (108)
		DW XP_TABLE + 1			; 6D (109)
		DW CITY_MAP_DATA + 1	; 6E (110)
		DW CLASS_ELIGIBILITY + 1		; 6F (111)
		DW MONST_SPEC + 1		; 70 (112)
		DW OPTION_KEYS + 1		; 71 (113)
		DW MONST_MAGIC + 1		; 72 (114)
		DW WEAPON_BONUS + 1		; 73 (115)
		DW ATTACK_WORD_TABLE + 1		; 74 (116)

INX_GUARDIANS		EQU $11
INX_ACTIONS_PROCS	EQU $31
INX_ACTIONS_KEYS	EQU $32
INX_MONST_HP_AC		EQU $44
INX_ITEM_EQUIP		EQU $47
INX_MONST_IMAGE		EQU $5A
INX_RANGE_VALUES	EQU $5F
INX_REVEAL_DURAT	EQU $60
INX_LIGHT_DURAT		EQU $61
INX_SUMMON_CREAT	EQU $62
INX_STATUSES		EQU $66
INX_ITEM_EFFECTS	EQU $67
INX_WEAPON_DAMAGE	EQU $68
INX_ITEM_SPECATT	EQU $6B
INX_XP_TABLE		EQU $6D
INX_MONST_SPEC		EQU $70
INX_OPTION_KEYS		EQU $71
INX_WEAPON_BONUS	EQU $73


; --- PICTURE_POINTERS -----------------------------------------------
; @done
; Picture-pointer sub-table: a list of DW (picture_data + 1) pointers
; indexed by picture id. show_pic_by_A (code/8923-89AD) does b = 2*id,
; reads two bytes here via GET_B_FROM_TABLE $0F to form the address of
; the packed bitmap, then unpacks it to the screen. Slot 0 corresponds to
; ADDR_TABLE global index 0x75, so picture id N points at global 0x75+N.
; City picture ids resolve to the PIC_DATA_* blocks in the location-pic
; files (CEF5/D73E/D831). Referenced by: ADDR_TABLE index $0F.
PICTURE_POINTERS:
		DW MONST_PIC_00 + 1	; 75 (117)
		DW MONST_PIC_01 + 1	; 76 (118)
		DW MONST_PIC_02 + 1	; 77 (119)
		DW MONST_PIC_03 + 1	; 78 (120)
		DW MONST_PIC_04 + 1	; 79 (121)
		DW MONST_PIC_05 + 1	; 7A (122)
		DW MONST_PIC_06 + 1	; 7B (123)
		DW MONST_PIC_07 + 1	; 7C (124)
		DW MONST_PIC_08 + 1	; 7D (125)
		DW MONST_PIC_07 + 1	; 7E (126)
		DW MONST_PIC_05 + 1	; 7F (127)
		DW MONST_PIC_0B + 1	; 80 (128)
		DW MONST_PIC_07 + 1	; 81 (129)
		DW PIC_DATA_GUILD + 1	; 82 (130)
		DW PIC_DATA_SHOPPE + 1	; 83 (131)
		DW PIC_DATA_TAVERN + 1	; 84 (132)
		DW PIC_DATA_10 + 1	; 85 (133)
		DW PIC_DATA_TEMPLE + 1	; 86 (134)
		DW PIC_DATA_BUILDING + 1	; 87 (135)
		DW PIC_DATA_REVIEWBOARD + 1	; 88 (136)
		DW PIC_DATA_14 + 1	; 89 (137)
		DW PIC_DATA_14 + 1	; 8A (138)
		DW PIC_DATA_14 + 1	; 8B (139)
		DW PIC_DATA_14 + 1	; 8C (140)
		DW MONST_PIC_07 + 1	; 8D (141)
		DW MONST_PIC_07 + 1	; 8E (142)
		DW PIC_DATA_GUARDIAN + 1	; 8F (143)
		DW PIC_DATA_TOWER + 1	; 90 (144)
		DW MONST_PIC_07 + 1	; 91 (145)
