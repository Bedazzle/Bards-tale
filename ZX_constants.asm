; ============================================================================
; ZX Spectrum hardware constants
; ----------------------------------------------------------------------------
; Pure machine constants (screen/attribute memory, I/O ports, ROM entry points).
; These are NOT game symbols - they belong here, out of the game constants and
; out of the per-level externals. Included by every build (main + each level
; overlay) so the whole project shares one definition.
; ============================================================================

; --- display memory ---
SCREEN                 EQU $4000		; pixel bitmap $4000-$57FF
SCR_ATTR               EQU $5800		; attributes $5800-$5AFF
SCR_ATTR_LEN           EQU $0300		; 768 attribute bytes

; --- I/O ports ---
PORT_BORDER            EQU $FE			; ULA: border / beeper / keyboard

; --- 48K ROM entry points ---
ROM_KEY_SCAN           EQU $028E
ROM_KEY_REPEAT         EQU $031C
ROM_BEEPER             EQU $03B5
ROM_BYTES_SAVE         EQU $04C6
ROM_BYTES_LOAD         EQU $0562
ROM_LOAD               EQU $0556
