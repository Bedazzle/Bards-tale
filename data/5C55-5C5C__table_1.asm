; --- ___table_1 ----------------------------------------------
; @wip
; 8 bytes at $5C55 (ADDR_TABLE index $4F). No static GET_*_FROM_TABLE $4F
; call exists, but a dynamic combat trace (tools/m8xxx) observed slot $4F
; being dereferenced via the RST-10h dispatcher ($7150) at runtime with
; sub-index 0 - so it IS live, reached through a computed/indirect table
; index. The address sits in the $5C00 working-RAM region (heavy sysvar/
; ROM traffic in the trace), so this is almost certainly runtime STATE
; read through the table, not a static constant table.
; Note: exact meaning still unknown; a targeted watch on its writer is
;       needed (sibling of ___table_2 at $50).
; Referenced by: ADDR_TABLE index $4F (indirect; seen live in trace)
___table_1:
		DW $0F0F	; 5C56
		DW $1F1F
		DW $1F1F
		DW $1F1F
