; --- GAME_VARIABLES -------------------------------------------
; @done
; The IY-based game variable block. The engine keeps iy = $5FAB
; (GAME_VARIABLES) and reads/writes fields as (iy+VAR_*), so this is one
; ~$78-byte struct addressed by byte offset (NOT a record array). Every
; VAR_* constant in constants.asm names one field; each byte below is
; annotated with its field name. The DB values are the initial defaults
; loaded with the party; the rest are zero-initialised at start. Saved
; as the tail of the PARTY_FILE block. A few offsets ($09/$0A, $17-$1C,
; $2A-$2D, $31, $3C) have no VAR_* name yet - scratch/unanalysed.
; Referenced by: GET_GAME_VARIABLE and every (iy+VAR_*) access (iy=GAME_VARIABLES).
GAME_VARIABLES:
		DB 5			; 00h  VAR_PARTY_SIZE
		DW GUILD_COORDS		; 01h  VAR_COORD_SO_NO / 02h VAR_COORD_WE_EA
		DB FACE_WEST		; 03h  VAR_FACE_DIRECTION
		DB $0A			; 04h  VAR_DAY_OUTER_CTR
		DB $1F			; 05h  VAR_DAY_OUTER
		DB 1			; 06h  VAR_DISPLAY_STATE
		DB 0			; 07h  VAR_DUNGEON_LEVEL
		DB $50			; 08h  VAR_DAY_MID_CTR
		DB 0			; 09h  (unknown)
		DB 0			; 0Ah  (unknown)
		DB 0			; 0Bh  VAR_SPELL_STATE
		DB $20			; 0Ch  VAR_DAY_INNER_CTR
		DB $0A			; 0Dh  VAR_DAY_INNER

		DB 0		; 0Eh  VAR_COMBAT_MODE
		DB 0		; 0Fh  VAR_EVENT_DEPTH
		DB 0		; 10h  VAR_SPELL_ACTIVE
		DB 0		; 11h  VAR_SPELL_ID
		DB 0		; 12h  VAR_TURN_PROCESSING
		DB 0		; 13h  VAR_REDRAW_STATS
		DB 0		; 14h  VAR_HERO_SLOT
		DB 0		; 15h  VAR_SPELL_DURATION
		DB 0		; 16h  VAR_SPELL_DURATION+1
		DB 0		; 17h  (unknown)
		DB 0		; 18h  (unknown)
		DB 0		; 19h  (unknown)
		DB 0		; 1Ah  (unknown)
		DB 0		; 1Bh  (unknown)
		DB 0		; 1Ch  (unknown)
		DB 0		; 1Dh  VAR_BARD_SONG_LVL
		DB 0		; 1Eh  VAR_DAY_PART
		DB 0		; 1Fh  VAR_LIGHT
		DB 0		; 20h  VAR_CARPET
		DB 0		; 21h  VAR_COMPASS_ON
		DB 0		; 22h  VAR_EYE
		DB 0		; 23h  VAR_SHIELD
		DB 0		; 24h  VAR_KEEP_PRESSED
		DB 0		; 25h  VAR_PRESSED_KEY
		DB 0		; 26h  VAR_CAST_HERO

		DB 5			; 27h  VAR_LIGHT_DIST

		DB 0		; 28h  VAR_REVEAL_SECRET
		DB 0		; 29h  VAR_DAY_TIMER_CHK
		DB 0		; 2Ah  (unknown)
		DB 0		; 2Bh  (unknown)
		DB 0		; 2Ch  (unknown)

		DB 6			; 2Dh  (unknown; default 6)

		DB 0		; 2Eh  VAR_ANIM_SPEED_FLAG
		DB 0		; 2Fh  VAR_NIGHT_TIMER
		DB 0		; 30h  VAR_PAUSE
		DB 0		; 31h  (unknown)
		DB 0		; 32h  VAR_RND_HI
		DB 0		; 33h  VAR_RND_LO
		DB 0		; 34h  VAR_WEAPON_BONUS
		DB 0		; 35h  VAR_DUNGEON_STEPS
		DB 0		; 36h  VAR_TREASURE_FLAG
		DB 0		; 37h  VAR_TEMPLE_TIMER
		DB 0		; 38h  VAR_VIEW_Y_OFFSET
		DB 0		; 39h  VAR_VIEW_X_OFFSET
		DB 0		; 3Ah  VAR_UNDERGROUND
		DB 0		; 3Bh  VAR_TELEPORT_MODE
		DB 0		; 3Ch  (unknown)
		DB 0		; 3Dh  VAR_SAVE_STATE_LO
		DB 0		; 3Eh  VAR_SAVE_STATE_HI
		DB 0		; 3Fh  VAR_AREA_MODE
		DB 0		; 40h  VAR_REVEAL_FLAG
		DB 0		; 41h  VAR_TEXT_BUF_PTR
		DB 0		; 42h  VAR_TEXT_BUF_PTR+1
		DB 0		; 43h  VAR_TREASURE_HI
		DB 0		; 44h  VAR_TREASURE (mid)
		DB 0		; 45h  VAR_TREASURE_LO
		DB 0		; 46h  VAR_INFO_ROW_POS
		DB 0		; 47h  VAR_INFO_COL_POS
		DB 0		; 48h  VAR_PORTRAIT_CTR
		DB 0		; 49h  VAR_SPELL_CLASS
		DB 0		; 4Ah  VAR_SPELL_LEVEL
		DB 0		; 4Bh  VAR_CURRENT_SPELL

		DB $FF			; 4Ch  VAR_CURRENT_ACTOR

		DB 0		; 4Dh  VAR_ENEMY_COUNT
		DB 0		; 4Eh  VAR_ACTIVE_ENEMY
		DB 0		; 4Fh  VAR_DISPLAY_COUNT
		DB 0		; 50h  VAR_DAMAGE_TYPE
		DB 0		; 51h  VAR_FLEE_SUCCESS
		DB 0		; 52h  VAR_ACTIVE_HERO
		DB 0		; 53h  VAR_TARGET_ID
		DB 0		; 54h  VAR_COPY_DAYPART
		DB 0		; 55h  VAR_ICON_CODE
		DB 0		; 56h  VAR_SONG_MODIFIER
		DB 0		; 57h  VAR_SONG_EFFECT
		DB 0		; 58h  VAR_COMBAT_SPEED
		DB 0		; 59h  VAR_SPEED_LOOKUP
		DB 0		; 5Ah  VAR_AMBUSH_FLAG
		DB 0		; 5Bh  VAR_ENCOUNTER_CTR
		DB 0		; 5Ch  VAR_BREATH_COUNT
		DB 0		; 5Dh  VAR_CURSOR_ROW
		DB 0		; 5Eh  VAR_CURSOR_COL
		DB 0		; 5Fh  VAR_BASE_DAMAGE
		DB 0		; 60h  VAR_DEFENSE_BONUS
		DB 0		; 61h  VAR_INITIATIVE_FLAG
		DB 0		; 62h  VAR_AC_MOD_ENEMY
		DB 0		; 63h  VAR_STAT_MODIFIER
		DB 0		; 64h  VAR_DAMAGE_PENALTY
		DB 0		; 65h  VAR_BREATH_VALUE
		DB 0		; 66h  VAR_ALLY_COUNTER
		DB 0		; 67h  VAR_ROUND_NUMBER
		DB 0		; 68h  VAR_ANTIMAGIC
		DB 0		; 69h  VAR_CURRENT_PARAM
		DB 0		; 6Ah  VAR_CURRENT_PARAM+1
		DB 0		; 6Bh  VAR_ENEMY_SLOT
		DB 0		; 6Ch  VAR_XP_THRESHOLD
		DB 0		; 6Dh  VAR_ATTACK_MODIFIER
		DB 0		; 6Eh  VAR_MEMBER_NUM
		DB 0		; 6Fh  VAR_PLURAL_FLAG
		DB 0		; 70h  VAR_TARGET_SELECT
		DB 0		; 71h  VAR_TARGET_SELECT+1
		DB 0		; 72h  VAR_PRINT_POS
		DB 0		; 73h  VAR_PRINT_POS+1
		DB 0		; 74h  VAR_GOLD_FOUND_HI
		DB 0		; 75h  VAR_GOLD_FOUND (lo)
		DB 0		; 76h  VAR_XP_TOTAL_HI
		DB 0		; 77h  VAR_XP_TOTAL_HI+1
