; --- pick_random_hero (select_random_hero / dispatch $51) ----------
; @done
; Combat AI: pick a party slot (0-6) at random to act on this round.
; Rolls a masked random index and validates the candidate (slot
; occupied, not an inactive summoned ally, passes the table-$40 gate
; and CHECK_HERO_STATUS); retries up to 7 times, wrapping the index at
; the party-size limit. Falls back to slot 1 if none qualify.
; In:  iy = game variables base
; Out: a = chosen party slot
; Note: c holds the index mask (7 here); enter at pick_random_hero_lo for mask 3.
select_random_hero:				; PICK_RANDOM_HERO
		PUSH_REGS

		ld	c,7
		jr	pick_hero_scan

; --- pick_random_hero_lo (pick_random_hero_lo) ------------------------
; @done
; As pick_random_hero but limits the random slot index to 0-3 (mask 3)
; rather than 0-7 - picks among the front-rank party members only.
; Called by the combat driver (combat_foes).
; In:  iy = game variables base
; Out: a = chosen party slot (0-3)
pick_random_hero_lo:
		PUSH_REGS

		ld	c,3

; Shared scan loop for both entry points (index mask already in c).
pick_hero_scan:
		ld	e,7

		GET_RND_NUMBERS

		and	c
		ld	b,a

		cp	7
		jr	z,.next

.test_slot:
		FIND_HERO_BY_B

		jr	z,.next

		ld	a,b
		or	a
		jr	nz,.check_status

		ld	a,(ENEMY+ENEMY_ACTIVE_FLAG)
		or	a
		jr	nz,.next

		ld	a,(ENEMY+ENEMY_SPECIAL_FLAG)
		or	a
		jr	z,.check_status

		GET_GAME_VARIABLE	VAR_ALLY_COUNTER			; ???

		jr	nz,.next

.check_status:
		GET_B_FROM_TABLE	$40

		jr	nz,.next

		CHECK_HERO_STATUS

		jr	c,.done

.next:
		inc	b
		dec	e
		jr	z,.fallback

		ld	a,b

		cp	STATUS_STONED
		jr	z,.wrap

		cp	STATUS_NUTS
		jr	c,.test_slot

.wrap:
		ld	b,0

		jr	.test_slot

.fallback:
		ld	b,1

.done:
		ld	a,b

		ret
