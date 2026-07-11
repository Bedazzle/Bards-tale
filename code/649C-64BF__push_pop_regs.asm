; --- push_regs ------------------------------------------------
; @done
; Save-all-registers helper invoked via PUSH_REGS (RST 10h, id $38).
; Pushes DE, BC, IX, IY, HL (plus the alt-set DE') and splices pop_regs
; into the return chain, so a plain RET in the caller then automatically
; restores every register. HL' is preserved through keeper_hl.
; Out: all registers preserved across the caller; pop_regs queued as the
;      post-return restore step.
; Note: rearranges the stack (ex (sp),hl) to insert pop_regs as a return
;       vector; the caller must reach a matching RET.
push_regs:
		exx
		pop	de
		exx
		ld	(keeper_hl),hl
		ex	(sp),hl
		push	de
		push	bc
		push	ix
		push	iy
		push	hl
		ld	hl,pop_regs
		ex	(sp),hl
		push	hl
		exx
		push	de
		exx
		ld	hl,(keeper_hl)

		ret

; Scratch word used by push_regs to stash HL across the stack shuffle.
keeper_hl:
		DW 0

; -------------------------------------

; --- pop_regs -------------------------------------------------
; @done
; Restore the registers saved by push_regs (IY, IX, BC, DE, HL) and
; return. Reached automatically because push_regs pushed its address as
; a return vector under the caller.
pop_regs:
		pop	iy
		pop	ix
		pop	bc
		pop	de
		pop	hl

		ret
