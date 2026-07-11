; --- prep_black_color -----------------------------------------
; @done
; Fill the whole city-view window with black. Zeroes the colour byte in
; draw_city_colors' SMC slot, then enters clear_city_color.fill to clear the
; screen bitmap and set attributes for the $58-row window.
prep_black_color:
		push	af
		xor	a
		ld	(color_to_draw+1),a
		pop	af

		jr	clear_city_color.fill
; -------------------------------------

; --- clear_city_color -------------------------------------------------
; @done
; Clear the city-view window to black, seeding the attribute fill from
; value $39. Zeroes the colour SMC slot, then falls through into the
; shared .fill entry which sets the $58-row count and runs
; draw_city_colors.
clear_city_color:
		xor	a
		ld	(color_to_draw+1),a
		ld	a,$39

.fill:
		ld	b,$58

		jr	draw_city_colors
; -------------------------------------

; --- set_city_colors ------------------------------------------
; @done
; Paint the city view's attribute colours for the current time of day:
; the sky band (white-on-blue by day, black by night per
; iy+VAR_DAY_PART bit 0) then the red ground band. Each band is drawn by
; loading the chosen colour into the SMC slot and the band's row count
; into B and (re-)entering draw_city_colors / .fill_block.
; In:  iy = game variables base
set_city_colors:
		ld	a,$0F		; City view - daytime sky (white ink, dark blue	paper)
		bit	0,(iy+VAR_DAY_PART)
		jr	z,color_set

		ld	a,7		; City view - nighttime	sky (black)

color_set:
		ld	b,$28
		ld	(color_to_draw+1),a
		call	draw_city_colors
		ld	a,$17		; City view - Ground colour (white ink,	red paper)
		ld	(color_to_draw+1),a
		ld	b,$30

		jr	draw_city_colors.fill_block
; -------------------------------------

; --- draw_city_colors -----------------------------------------
; @done
; Clear a rectangular block of the city view and set its attributes. For
; B rows it zeroes a 10-byte-wide strip of screen bitmap from HL ($4021
; by default), stepping through the screen thirds, then fills the
; matching attribute rows at DE ($5821) with the colour bytes in the two
; SMC slots (color_to_drawx / color_to_draw).
; In:  b = row count, a = colour. draw_city_colors sets HL/DE to the
;      default window origin; .fill_block enters with HL/DE/A/B set.
; Note: writes screen ($4000-$57FF) and attributes ($5800-$5AFF).
draw_city_colors:
		ld	de,SCR_ATTR+$21
		ld	hl,SCREEN+$21

.fill_block:
		push	de
		ld	(color_to_drawx+1),a
		ld	a,b
		push	af

.clear_row:
		push	hl
		ld	d,h
		ld	e,l
		inc	de
		ld	bc,$0A
		ld	(hl),0
		ldir

		pop	hl
		push	af
		inc	h
		ld	a,h
		and	7
		jr	nz,.next_row

		ld	a,l
		add	a,$20
		ld	l,a
		jr	c,.next_row

		ld	a,h
		sub	8
		ld	h,a

.next_row:
		pop	af
		dec	a
		jr	nz,.clear_row

		pop	af
		ex	(sp),hl
		rra
		rra
		rra
		and	$1F

.attr_loop:
		ld	d,h
		ld	e,l
		inc	de
		ld	bc,$0A

color_to_drawx:
		ld	(hl),0			; !!! SMC
		ldir

color_to_draw:
		ld	(hl),0			; !!! SMC
		ld	bc,$16
		add	hl,bc
		dec	a
		jr	nz,draw_city_colors.attr_loop

		ex	de,hl
		pop	hl

		ret
