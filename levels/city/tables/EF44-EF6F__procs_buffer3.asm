; --- PROCS_3 ---------------------------------------------------
; @done
; Location-handler jump table: one DW per city location/building type,
; each the address of a proc_* routine (0 = no handler). The movement
; dispatcher indexes this to run the routine for the cell the party
; steps onto (empty building, guild, tavern, shoppe, temple, guardian,
; iron gate, mad god, sewers, roscoe, amber tower, castle, ...).
; Referenced by: ADDR_TABLE index $0A (GET_*_FROM_TABLE 10).
PROCS_3:
		DW proc_emptybuild
		DW proc_guild
		DW proc_tavern
		DW proc_shoppe
		DW proc_temple
		DW proc_reviewbord
		DW 0
		DW proc_emptybuild
		DW 0
		DW 0
		DW 0
		DW 0
		DW proc_guardian
		DW proc_iron_gate
		DW proc_mad_god
		DW proc_city_sewers
		DW proc_emptybuild
		DW proc_roscoe
		DW proc_amber
		DW proc_castle
		DW proc_mangar_saved
		DW proc_gate_closed
