; ============================================================================
; Shared dungeon game-state variables (absolute RAM addresses)
; ----------------------------------------------------------------------------
; The dungeon overlays (level_02, level_03, ...) address the engine's game-state
; RAM directly by absolute address; the shared engine reaches the same bytes
; IY-relative from base $5FAB (constants.asm VAR_* offsets). These are the same
; addresses in every overlay, so they are named ONCE here (included by each
; level's build) - the names mirror the engine's VAR_* constants (lowercased).
; ============================================================================

coord_so_no            EQU $5FAC		; VAR_COORD_SO_NO   party N/S coord (+1 = W/E)
face_direction         EQU $5FAE		; VAR_FACE_DIRECTION party facing 0-3
shield_state           EQU $5FCE		; VAR_SHIELD        shield-spell state (4)
light_dist             EQU $5FD2		; VAR_LIGHT_DIST    lit view distance
reveal_secret          EQU $5FD3		; VAR_REVEAL_SECRET show secret/hidden walls
treasure_flag          EQU $5FE1		; VAR_TREASURE_FLAG
view_y_offset          EQU $5FE3		; VAR_VIEW_Y_OFFSET 3D-view N/S coord
view_x_offset          EQU $5FE4		; VAR_VIEW_X_OFFSET 3D-view W/E coord
teleport_mode          EQU $5FE6		; VAR_TELEPORT_MODE
current_spell          EQU $5FF6		; VAR_CURRENT_SPELL
enemy_count            EQU $5FF8		; VAR_ENEMY_COUNT
damage_type            EQU $5FFB		; VAR_DAMAGE_TYPE
copy_daypart           EQU $5FFF		; VAR_COPY_DAYPART  daypart copy (scales rolls)
speed_lookup           EQU $6004		; VAR_SPEED_LOOKUP
encounter_ctr          EQU $6006		; VAR_ENCOUNTER_CTR
var_5D19               EQU $5D19		; ??? joining-creature HP (calc_monster_hp result)
var_5D1B               EQU $5D1B		; ???
