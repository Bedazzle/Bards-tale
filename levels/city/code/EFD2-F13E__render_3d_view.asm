; --- DO_SOME_MOVEMENT ------------------------------------------
; @done
; Build the first-person 3D view buffer by sampling the map cells
; around the party. Reads VAR_FACE_DIRECTION (0=N,1=E,2=S,3=W) and
; runs the matching scan pattern, walking a 3-deep x 3-wide grid
; ahead of the party and storing each cell's wall/feature code into
; its view slot (VIEW_CELL_0..VIEW_NEAR_CENTRE).
; In:  VAR_FACE_DIRECTION, party coords VAR_COORD_SO_NO / _WE_EA
; Out: VIEW_CELL_0..VIEW_CELL_7 = 8 wall cells, VIEW_NEAR_CENTRE = cell
;      directly ahead; view cursor VIEW_X/Y_OFFSET left dirty
; Note: FBD9=far-centre, FBDC=mid-centre, FBDF=near-centre(ahead)
DO_SOME_MOVEMENT:
		GET_GAME_VARIABLE	VAR_FACE_DIRECTION		; facing 0=N 1=E 2=S 3=W

		jp	z,.face_north

		dec	a
		jp	z,.face_east

		dec	a
		jp	z,.face_south

		ld	hl,GAME_VARIABLES + VAR_VIEW_X_OFFSET
		ld	a,(GAME_VARIABLES + VAR_COORD_WE_EA)
		sub	3
		call	view_seed_x
		inc	(iy+VAR_VIEW_X_OFFSET)
		dec	(hl)
		call	sample_view_cell
		ld	(VIEW_CELL_0),a
		call	scan_mid_inc
		ld	(VIEW_CELL_1),a
		inc	(iy+VAR_VIEW_X_OFFSET)
		call	scan_skip_dec
		ld	(VIEW_CELL_3),a
		call	scan_near_inc
		ld	(VIEW_CELL_4),a
		inc	(iy+VAR_VIEW_X_OFFSET)
		call	sample_view_cell
		ld	(VIEW_CELL_7),a
		call	scan_skip_dec
		ld	(VIEW_CELL_6),a

		ret
; -------------------------------------

.face_south:
		ld	hl,GAME_VARIABLES + VAR_VIEW_Y_OFFSET
		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)
		sub	3
		call	view_seed_y
		inc	(iy+VAR_VIEW_Y_OFFSET)
		dec	(hl)
		call	sample_view_cell
		ld	(VIEW_CELL_1),a
		call	scan_mid_inc
		ld	(VIEW_CELL_0),a
		inc	(iy+VAR_VIEW_Y_OFFSET)
		call	scan_skip_dec
		ld	(VIEW_CELL_4),a
		call	scan_near_inc
		ld	(VIEW_CELL_3),a
		inc	(iy+VAR_VIEW_Y_OFFSET)
		call	sample_view_cell
		ld	(VIEW_CELL_6),a
		call	scan_skip_dec
		ld	(VIEW_CELL_7),a

		ret
; -------------------------------------

.face_east:
		ld	hl,GAME_VARIABLES + VAR_VIEW_X_OFFSET
		ld	a,(GAME_VARIABLES + VAR_COORD_WE_EA)
		add	a,3
		call	view_seed_x
		dec	(iy+VAR_VIEW_X_OFFSET)
		inc	(hl)
		call	sample_view_cell
		ld	(VIEW_CELL_0),a
		call	scan_mid_dec
		ld	(VIEW_CELL_1),a
		dec	(iy+VAR_VIEW_X_OFFSET)
		call	scan_skip_inc
		ld	(VIEW_CELL_3),a
		call	scan_near_dec
		ld	(VIEW_CELL_4),a
		dec	(iy+VAR_VIEW_X_OFFSET)
		call	sample_view_cell
		ld	(VIEW_CELL_7),a
		call	scan_skip_inc
		ld	(VIEW_CELL_6),a

		ret
; -------------------------------------

.face_north:
		ld	hl,GAME_VARIABLES + VAR_VIEW_Y_OFFSET
		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)
		add	a,3
		call	view_seed_y
		dec	(iy+VAR_VIEW_Y_OFFSET)
		inc	(hl)
		call	sample_view_cell
		ld	(VIEW_CELL_1),a
		call	scan_mid_dec
		ld	(VIEW_CELL_0),a
		dec	(iy+VAR_VIEW_Y_OFFSET)
		call	scan_skip_inc
		ld	(VIEW_CELL_4),a
		call	scan_near_dec
		ld	(VIEW_CELL_3),a
		dec	(iy+VAR_VIEW_Y_OFFSET)
		call	sample_view_cell
		ld	(VIEW_CELL_6),a
		call	scan_skip_inc
		ld	(VIEW_CELL_7),a

		ret

; ======= S U B	R O U T	I N E =========

; --- view_seed_x -----------------------------------------------
; @done
; Seed the view cursor for an east/west facing: set VIEW_X_OFFSET
; to the far column and VIEW_Y_OFFSET to the party's lateral coord,
; then sample the far-centre cell into VIEW_FAR_CENTRE.
; In:  hl -> VIEW_X_OFFSET var, a = far column coord
; Out: VIEW_FAR_CENTRE = far-centre cell; hl -> VIEW_Y_OFFSET var
view_seed_x:
		ld	(hl),a
		dec	hl
		ld	a,(GAME_VARIABLES + VAR_COORD_SO_NO)
		ld	(hl),a
		call	sample_view_cell
		ld	(VIEW_FAR_CENTRE),a

		ret

; ======= S U B	R O U T	I N E =========

; --- view_seed_y -----------------------------------------------
; @done
; Seed the view cursor for a north/south facing: set VIEW_Y_OFFSET
; to the far row and VIEW_X_OFFSET to the party's lateral coord,
; then sample the far-centre cell into VIEW_FAR_CENTRE.
; In:  hl -> VIEW_Y_OFFSET var, a = far row coord
; Out: VIEW_FAR_CENTRE = far-centre cell; hl -> VIEW_X_OFFSET var
view_seed_y:
		ld	(hl),a
		inc	hl
		ld	a,(GAME_VARIABLES + VAR_COORD_WE_EA)
		ld	(hl),a
		call	sample_view_cell
		ld	(VIEW_FAR_CENTRE),a

		ret

; ======= S U B	R O U T	I N E =========

; --- scan_mid_inc ----------------------------------------------
; @done
; Step the view cursor +1 along the lateral axis, sample the
; mid-depth centre cell into VIEW_MID_CENTRE, step +1 again and tail into
; sample_view_cell so the caller receives the next (side) cell in A.
; In:  hl -> lateral view-offset var
; Out: VIEW_MID_CENTRE set; a = cell two steps on
scan_mid_inc:
		inc	(hl)
		call	sample_view_cell
		ld	(VIEW_MID_CENTRE),a
		inc	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========

; --- scan_mid_dec ----------------------------------------------
; @done
; As scan_mid_inc but stepping the lateral cursor -1 each time
; (used by the mirror-facing scans): sample the mid-depth centre
; cell into VIEW_MID_CENTRE, then tail into sample_view_cell for the next cell.
; In:  hl -> lateral view-offset var
; Out: VIEW_MID_CENTRE set; a = cell two steps back
scan_mid_dec:
		dec	(hl)
		call	sample_view_cell
		ld	(VIEW_MID_CENTRE),a
		dec	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========

; --- scan_near_inc ---------------------------------------------
; @done
; Step the view cursor +1 laterally, sample the near-depth centre
; cell (the cell directly ahead) into VIEW_NEAR_CENTRE, step +1 again and
; tail into sample_view_cell to return the next side cell in A.
; In:  hl -> lateral view-offset var
; Out: VIEW_NEAR_CENTRE set; a = cell two steps on
scan_near_inc:
		inc	(hl)
		call	sample_view_cell
		ld	(VIEW_NEAR_CENTRE),a
		inc	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========

; --- scan_near_dec ---------------------------------------------
; @done
; As scan_near_inc but stepping the lateral cursor -1 each time:
; sample the near-depth centre cell (directly ahead) into
; VIEW_NEAR_CENTRE, then tail into sample_view_cell for the next side cell.
; In:  hl -> lateral view-offset var
; Out: VIEW_NEAR_CENTRE set; a = cell two steps back
scan_near_dec:
		dec	(hl)
		call	sample_view_cell
		ld	(VIEW_NEAR_CENTRE),a
		dec	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========

; --- scan_skip_inc ---------------------------------------------
; @done
; Skip one lateral cell (+2) without storing, then tail into
; sample_view_cell so the caller gets the cell two steps on in A.
; In:  hl -> lateral view-offset var
; Out: a = cell two steps on
scan_skip_inc:
		inc	(hl)
		inc	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========

; --- scan_skip_dec ---------------------------------------------
; @done
; Skip one lateral cell (-2) without storing, then tail into
; sample_view_cell so the caller gets the cell two steps back in A.
; In:  hl -> lateral view-offset var
; Out: a = cell two steps back
scan_skip_dec:
		dec	(hl)
		dec	(hl)

		jr	sample_view_cell

; ======= S U B	R O U T	I N E =========


; --- sample_view_cell --------------------------------------------------
; @done
; Sample one map cell for the 3D view: read the cell at the view
; cursor (VIEW_X_OFFSET, VIEW_Y_OFFSET) in the 30x30 map based at
; VIEW_MAP_BUFFER and return its wall/feature code via the lookup_addr_by_A
; lookup ($6E table).
; In:  VAR_VIEW_X_OFFSET / VAR_VIEW_Y_OFFSET (view cursor)
; Out: a = cell code, or 0 if the cursor is off the map (>= 30)
; Note: preserves hl; called cross-file (guardian, sinister_street)
sample_view_cell:
		push	hl
		ld	a,(GAME_VARIABLES + VAR_VIEW_Y_OFFSET)
		ld	b,a

		cp	$1E
		jr	nc,.off_map

		ld	a,(GAME_VARIABLES + VAR_VIEW_X_OFFSET)
		ld	c,a

		cp	$1E
		jr	nc,.off_map

		ld	a,$1D
		sub	b
		ld	b,a
		inc	b
		ld	hl,VIEW_MAP_BUFFER
		ld	de,$1E

.row:
		add	hl,de
		djnz	.row

		ld	e,c
		add	hl,de
		ld	c,l
		ld	b,h
		ld	a,$6E			; city map address ?
		call	lookup_addr_by_A
		pop	hl

		ret

.off_map:
		pop	hl
		xor	a

		ret
