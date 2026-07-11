; --- apply_damage_to_group ----------------------------------
; @done
; Pause-guarded public entry for applying a damage/effect packet.
; Raises the pause flag, dispatches through apply_damage_dispatch
; (which routes to an enemy group or a single hero), then lowers
; the pause flag again.
; In:  a = target byte (bit 7 set = enemy group, else hero id),
;      de = damage amount, iy = game variables
apply_damage_to_group:
		PUSH_REGS

		inc	(iy+VAR_PAUSE)		; pause ON
		call	apply_damage_dispatch
		dec	(iy+VAR_PAUSE)		; pause OFF

		ret

; --- apply_damage_dispatch ----------------------------------
; @done
; Route an incoming damage/effect packet. If the target byte has
; bit 7 clear it is a single hero id and control falls through to
; apply_damage_to_hero. If bit 7 is set the low 7 bits are an enemy
; group id: the effect is applied to a live member of that group,
; and when the member dies the group list is compacted, its
; remaining count decremented and the active-enemy tables updated.
; In:  a = target byte, de = damage amount, iy = game variables
; Out: cf reflects the outcome (set on the group path)
; Note: group bookkeeping via tables $36/$41/$42/$2A/$2B;
;       details partially inferred.
apply_damage_dispatch:
		cp	$80
		jr	c,apply_damage_to_hero

		push	hl
		and	$7F
		ld	c,a
		ld	b,c

		CALC_IN_FB7D

		ex	de,hl

		CALC_SPELL_FX

		GET_B_FROM_TABLE	$36

		ld	b,a

.find_alive:
		bit	0,(hl)
		jr	nz,.apply_to_member

		inc	de
		inc	hl
		djnz	.find_alive

		ld	b,c

		CALC_IN_FB7D

		ex	de,hl

		CALC_SPELL_FX

		ld	b,a

.apply_to_member:
		res	0,(hl)
		ex	(sp),hl
		ex	de,hl
		ld	a,(GAME_VARIABLES + VAR_DAMAGE_TYPE)

		cp	6
		jr	nc,.remove_member

		xor	a
		ld	(GAME_VARIABLES + VAR_DAMAGE_TYPE),a

		cp	d
		jr	nz,.remove_member

		ld	a,(hl)
		sub	e
		jr	z,.remove_member
		jr	c,.remove_member

		ld	(hl),a
		and	a
		pop	hl

		ret
; -------------------------------------

.remove_member:
		pop	de

.compact_loop:
		inc	de
		inc	hl
		ld	a,(de)
		dec	de
		ld	(de),a
		ld	a,(hl)
		dec	hl
		ld	(hl),a
		inc	de
		inc	hl
		djnz	.compact_loop

		GET_C_FROM_TABLE	$36

		dec	a
		exx
		ld	(hl),a
		exx
		jr	nz,.update_active

		xor	a

		GET_C_FROM_LIST	$42

.update_active:
		GET_C_FROM_TABLE	$41

		ld	d,a
		ld	e,0

.scan_active:
		GET_E_FROM_TABLE	$2B

		jr	z,.mark_active

		cp	d
		jr	z,.mark_active

		inc	e
		ld	a,e

		cp	$10
		jr      c,.scan_active
		jr      group_damage_done

.mark_active:
		ld	a,d
		exx
		ld	(hl),a
		exx

		GET_E_FROM_TABLE	$2A

		exx
		inc	(hl)
		exx

group_damage_done:
		scf

		ret
