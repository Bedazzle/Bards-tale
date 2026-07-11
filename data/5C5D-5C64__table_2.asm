; --- ___table_2 ----------------------------------------------
; @wip
; 8 bytes at $5C5D (ADDR_TABLE index $50). Like ___table_1 ($4F) there is
; no static GET_*_FROM_TABLE $50, but a dynamic combat trace (tools/m8xxx)
; saw slot $50 dereferenced via the RST-10h dispatcher ($7150) at runtime
; (sub-index 0), so it is live via a computed/indirect index. It sits in
; the $5C00 working-RAM region, so it is runtime STATE reached through the
; table rather than a static constant table.
; Note: exact meaning still unknown; needs a writer watch (sibling of $4F).
; Referenced by: ADDR_TABLE index $50 (indirect; seen live in trace)
___table_2:
		DW $0800	; 5C5E
		DW $1008
		DW $3020
		DW $5040
