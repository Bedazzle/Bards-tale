; --- simple_down_hl ---------------------------------------
; @done
; Advance a ZX screen address in HL down by one pixel line,
; crossing the character-cell and screen-third boundaries. Within
; a cell it just adds $0100 (increments the pixel row); at the last
; row of a third it steps to the next third (+$20) or drops to the
; next character row (-$1760).
; In:  hl = screen address.  Out: hl = address one line lower.
; Note: preserves af and de.
simple_down_hl:
		push	af
		push	de
		ld	a,h
		and	$47

		cp	$47				; detect second third of bitmap area
		ld	de,$0100		; 256
		jr	nz,.add_delta

		ld	a,l
		and	$E0

		cp	$E0			; -32
		ld	de,$20			; 32
		jr	z,.add_delta

		ld	de,$F920		; -1760

.add_delta:
		add	hl,de
		pop	de
		pop	af

		ret

;down_hl:
;	INC H
;	LD A,H
;	AND 7
;	JR NZ,EXIT	;CY=0
;	LD A,L
;	ADD A,32
;	LD L,A
;	JR C,EXIT	;CY=1
;	LD A,H
;	ADD A,-8
;	LD H,A		;CY=1
;EXIT:
;	ret