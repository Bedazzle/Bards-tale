; --- loader ---------------------------------------------------
; @done
; Tape loader (runs at $FF8E). Fills the screen attributes, then reads
; 7-byte tape headers until one whose filename matches LOAD_FILENAME, loads
; that block's data to SCR_ATTR, and jumps to the game entry.
; Out: jp binary_start once the matching block has loaded.
; Note: uses the ROM tape routine ROM_BYTES_LOAD ($0556).
tape_loader:
		di
		ld	hl,$3D00
		ld	(boot_scr_save),hl
		ld	sp,STACK_LOADER
		scf

		ld	hl,SCR_ATTR
		ld	de,SCR_ATTR+1
		ld	bc,SCR_ATTR_LEN-1
		ld	(hl),7
		ldir

load_header:
		ld	ix,LOAD_HEADER_BUF	; destination
		ld	de,7			; length
		xor	a				; A->0 header
		cp	e
		ex	af,af'

		call	ROM_BYTES_LOAD

		jr	nc,load_header

		ld	b,5
		ld	hl,LOAD_HEADER_BUF	; loaded header
		ld	de,LOAD_FILENAME	; filename to load

test_filename:
		ld	a,(de)
		cp	(hl)
		jr	nz,load_header

		inc	de
		inc	hl
		djnz	test_filename

		ld	ix,SCR_ATTR	; destination
		ld	de,(LOAD_HEADER_BUF+5)	; length
		ld	a,$FF			; A->FF data
		or	a
		scf
		ex	af,af'

		ld	a,$0F
		out	(PORT_BORDER),a
		di

		call	ROM_BYTES_LOAD

		jr	nc,load_header

		xor	a
		out	(PORT_BORDER),a

		jp	binary_start
