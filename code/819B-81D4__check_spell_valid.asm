; --- check_spell_valid ----------------------------------------
; @done
; Decides whether the current spell is allowed against the current
; target and, on a match, dispatches the special-cased spells. Builds
; the target's spell/attack code (from VAR_TARGET_ID or the enemy's
; attack spec), then searches an $0B-byte per-target table of
; permitted spell letters at DAMAGE_DICE_MASK+$B (offset by $0B for letters
; >= 'E'); sets carry if the spell is not in the list. On a match the
; 'C' and 'K' spells branch to breath_attack_run, the rest fall into spell_roll_damage.
; In:  VAR_CURRENT_SPELL, VAR_TARGET_ID, ENEMY record; iy = game vars
; Out: CF set if the spell is not valid for this target
check_spell_valid:
		GET_GAME_VARIABLE	VAR_TARGET_ID			; ???

		ld	a,(ENEMY+ENEMY_ATTACK_SPEC)
		jr	c,.from_enemy

		jr	z,.have_code

		scf

		ret

.from_enemy:
		and	$7F

		GET_A_FROM_TABLE	$41

.have_code:
		ld	de,$0B
		push	af
		ld	a,c

		cp	$45 ; 'E'
		jr	nc,.search

		ld	de,0

.search:
		pop	af
		ld	hl,DAMAGE_DICE_MASK+$B
		add	hl,de
		ld	bc,$0B
		cpir
		jr	z,.valid

		scf

		ret

.valid:
		ld	a,(GAME_VARIABLES + VAR_CURRENT_SPELL)

		cp	$43 ; 'C'
		jp	z,breath_attack_run

		cp	$4B ; 'K'
		jr	nz,spell_roll_damage

		jp	breath_attack_run
