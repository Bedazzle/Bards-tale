; --- CELL_PICTURE_MAP -----------------------------------------
; @done
; Maps the cell directly ahead to a full-view picture id. 24 bytes of
; picture ids ($10-$1B, $86; $FF = none). display_walls_creatures takes
; the forward cell's feature code / 8 as the index: if the entry isn't
; $FF it SHOW_PIC_BY_A's that picture (door/archway/fountain/etc.),
; otherwise it falls through to drawing the wall slices.
; Referenced by: display_walls_creatures (ADDR_TABLE index $09)
CELL_PICTURE_MAP:
		DB $17
		DB $15
		DB $10
		DB $16
		DB $14
		DB $17
		DB $86
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $FF
		DB $14
		DB $FF
		DB $17
		DB $17
		DB $1B
		DB $17
		DB $1B
		DB $FF
		DB $FF
		DB $FF

; --- SLOT_SPRITE_ID -------------------------------------------
; @done
; Per-view-slot sprite id: 8 bytes (4,4,6,2,2,8,0,0) indexed by the view
; slot (0-7). render_sprite_3d reads it (GET_C_FROM_TABLE $08) and uses
; the id to index the CITY_SPRITE_DATA pointer table for the sprite record
; (width/height + RLE stream) drawn in that slot.
; Referenced by: render_sprite_3d (ADDR_TABLE index $08)
SLOT_SPRITE_ID:
		DB 4
		DB 4
		DB 6
		DB 2
		DB 2
		DB 8
		DB 0
		DB 0

; --- SLOT_SCREEN_COL ------------------------------------------
; @done
; Per-view-slot screen column: 8 bytes (2,$0C,6,2,$0C,5,2,$0C) indexed by
; the view slot. render_sprite_3d (GET_C_FROM_TABLE $07) adds it to the
; base $3EFF to place the slot's sprite horizontally on screen.
; Referenced by: render_sprite_3d (ADDR_TABLE index $07)
SLOT_SCREEN_COL:
		DB 2
		DB $0C
		DB 6
		DB 2
		DB $0C
		DB 5
		DB 2
		DB $0C

; --- SLOT_SCREEN_ROW ------------------------------------------
; @done
; Per-view-slot screen row/pixel-line offset: 8 bytes (0,1,0,0,1,0,0,1)
; indexed by the view slot. render_sprite_3d (GET_C_FROM_TABLE $05) uses
; it as the vertical offset when placing the slot's sprite.
; Referenced by: render_sprite_3d (ADDR_TABLE index $05)
SLOT_SCREEN_ROW:
		DB 0
		DB 1
		DB 0
		DB 0
		DB 1
		DB 0
		DB 0
		DB 1
