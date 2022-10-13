simple_down_hl:
		push	af
		push	de
		ld	a, h
		and	47h

		cp	47h				; detect second third of bitmap area
		ld	de, 100h		; 256
		jr	nz, loc_89C9

		ld	a, l
		and	0E0h

		cp	0E0h			; -32
		ld	de, 20h			; 32
		jr	z, loc_89C9

		ld	de, 0F920h		; -1760

loc_89C9:
		add	hl, de
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