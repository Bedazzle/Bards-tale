; --- decode_sprite_mask --------------------------------------------------
; @done
; Decode a packed wall-slice code into an 8-pixel fill/shade mask
; for the 3D-view renderer (render_sprite_3d does cpl / and (hl) / or e
; with the result). Branches on the code's nibbles/bits to pick a
; solid, half, or dither pattern:
;   $FF full, $F0 left half, $0F right half, $A0/$A5/$05 dithers.
; In:  e = packed slice code
; Out: a = pixel mask (0 when e = 0)
; Note: exact code->pattern semantics partially inferred
decode_sprite_mask:
		ld	a,e
		or	a
		ret	z

		push	af
		and	$F0 ; 'р'
		jr	z,.hi_zero

		pop	af
		push	af
		and	$30 ; '0'
		jr	nz,.mid_set

		pop	af
		and	$0F
		jr	z,.mask_a0

		cp	4
		jr	c,.mask_a5

		ld	a,$FF

		ret

.mask_a0:
		ld	a,$A0

		ret

.mask_a5:
		ld	a,$A5

		ret

.mid_set:
		pop	af
		and	$0F
		jr	z,.mask_f0

		ld	a,$FF

		ret

.mask_f0:
		ld	a,$F0

		ret

.hi_zero:
		pop	af

		cp	4
		jr	c,.mask_05

		ld	a,$0F

		ret

.mask_05:
		ld	a,5

		ret
