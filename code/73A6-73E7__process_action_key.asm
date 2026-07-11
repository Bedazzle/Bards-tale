; --- process_action_key (process_action_key) ---------------------------
; @done
; Read a command key and match it against the ACTIONS_KEYS table,
; then either return the matched entry index or invoke the matching
; ACTIONS_PROCS handler via a self-modified call. Drives the hero
; sheet's [E,T,D,P] menu.
; In:  a = number of table entries to scan, c = base index offset
; Out: carry set = no match / abort; otherwise the handler runs (or,
;      when bit 7 of the caller's flag is set, the index is returned)
; Note: patches the call operand at .call_proc; INX_ACTIONS_KEYS /
;       INX_ACTIONS_PROCS select the key and handler tables.
process_action_key:
		push	af

		WAIT_KEY_DOWN

		ld	a,(GAME_VARIABLES + VAR_KEEP_PRESSED)
		ld	(GAME_VARIABLES + VAR_PRESSED_KEY),a
		pop	af

run_action_by_e:
		ld	e,a
		and	$7F
		ld	b,a
		ld	d,c

		GET_GAME_VARIABLE	VAR_PRESSED_KEY

		jr	z,.no_match

		ld	l,a

		cp	CODE_ABORT
		ccf
		ret	z

.scan_keys:
		GET_C_FROM_TABLE	INX_ACTIONS_KEYS

		cp	l
		jr	z,.matched

		inc	c
		djnz	.scan_keys

.no_match:
		or	1
		scf

		ret

.matched:
		bit	7,e
		jr	z,.dispatch

		ld	a,c
		sub	d
		ld	c,a
		and	a

		ret

.dispatch:
		sla	c

		GET_C_FROM_TABLE	INX_ACTIONS_PROCS

		inc	c
		ld	l,a

		GET_C_FROM_TABLE	INX_ACTIONS_PROCS

		ld	h,a
		ld	(.call_proc+1),hl

.call_proc:
		call	0		; !!! SMC
		and	a

		ret
