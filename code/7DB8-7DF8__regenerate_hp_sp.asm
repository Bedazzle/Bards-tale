; --- regenerate_hp_sp ---------------------------------------
; @done
; Party regeneration entry: selects the hit-point stat ($34) and
; regenerates it by one point (toward the maximum) for every
; eligible hero, then refreshes the on-screen stats table.
; In:  iy = game variables
regenerate_hp_sp:
		ld	e,$34 ; '4'

; --- regen_all_stats -----------------------------------------------
; @done
; Shared regeneration body: regenerate the attribute selected by E
; by one point for the whole party (pause-guarded), then redraw the
; stats table. Entered by regenerate_hp_sp (hit points) and the
; bard-song handler with its own attribute in E.
; In:  e = attribute index to regenerate, iy = game variables
regen_all_stats:
		inc	(iy+VAR_PAUSE)		; pause ON
		call	regen_stat_all_heroes
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; -------------------------------------

; --- regen_stat_all_heroes ----------------------------------
; @done
; Walk all six party slots and regenerate attribute E by one point
; in each eligible hero, then tail-call print_stats_table.
; In:  e = attribute index, iy = game variables
regen_stat_all_heroes:
		ld	b,6

.hero_loop:
		FIND_HERO_BY_B

		jr	z,regen_stat_paused.next_hero

; --- regen_stat_paused -----------------------------------------------
; @done
; Regenerate attribute E for the single hero in slot B by one point,
; provided the value is below its stored maximum. Pause-guarded.
; Statuses 1..4 skip regeneration; status 0 or >= 5 regenerate.
; In:  b = hero slot (1..6), e = attribute index, iy = game variables
; Note: the maximum is the byte pair stored two bytes after the
;       current value; cmp_stat_to_cap does the compare.
regen_stat_paused:
		inc	(iy+VAR_PAUSE)		; pause ON

		PUSH_REGS

		CHECK_HERO_STATUS

		jr	z,.do_regen

		cp	5
		jr	c,.skip

.do_regen:
		ld	a,e

		GET_ATTR_BY_A

		call	cmp_stat_to_cap
		jr	nz,.apply_inc

		dec	hl
		call	cmp_stat_to_cap
		jr	z,.skip

		dec	hl

.apply_inc:
		inc	hl
		inc	(hl)
		jr	nz,.skip

		dec	hl
		inc	(hl)

.skip:
		dec	(iy+VAR_PAUSE)		; pause OFF

.next_hero:
		djnz	regen_stat_all_heroes.hero_loop

		jp	print_stats_table

; ======= S U B	R O U T	I N E =========


; --- cmp_stat_to_cap ----------------------------------------
; @done
; Compare a hero attribute byte at (hl) with its cap stored two
; bytes ahead, returning the flags of current - max (zf = at cap).
; In:  hl = pointer to the attribute byte
; Out: flags of (hl) - (hl+2); hl advanced by two
cmp_stat_to_cap:
		ld	a,(hl)
		inc	hl
		inc	hl

		cp	(hl)

		ret
