; --- enemy_joins_party ----------------------------------------
; @done
; Recruits an enemy into the party after combat. Aborts if the roster
; is full; otherwise picks a random non-empty roster slot, copies the
; 100-byte character record between the enemy record and that slot,
; then (on a coin-flip) selects which of the two becomes the active
; member. Marks it as a party member (CHAR_NEG_FLAG /
; CHAR_FORMER_HEALTH from list $36), announces "jumps into your
; party!" and shows its stats.
; In:  ix = enemy character record, iy = game variables
; Out: CF set if the roster was full (nothing recruited); else NC
; Note: record copy direction / final slot choice as written;
;       partially inferred.
enemy_joins_party:
		call	is_roster_full
		ret	c

		push	ix
		pop	hl

.pick_slot:
		PICK_RANDOM_HERO

		or	a
		jr	z,.pick_slot

		FIND_HERO_BY_A

		ld	b,$64 		; 100
		push	hl
		push	ix

.copy_record:
		ld	a,(ix+CHAR_NAME)
		ld	(hl),a
		inc	hl
		inc	ix
		djnz	.copy_record

		pop	ix
		pop	hl

		GET_RND_NUMBERS

		srl	a
		jr	nc,.mark_member

		push	hl
		pop	ix

.mark_member:
		ld	b,(iy+VAR_ACTIVE_ENEMY)
		xor	a

		GET_B_FROM_LIST	$36

		inc	a
		ld	(ix+CHAR_NEG_FLAG),a
		ld	(ix+CHAR_FORMER_HEALTH),a

		PRINT_MESSAGE	$77		; "jumps into your party!"

		PRINT_STATS_TABLE

		CHANGE_COMBAT_SPEED

		and	a

		ret
