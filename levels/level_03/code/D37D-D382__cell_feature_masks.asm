; --- cell_feature_masks ($D37D-$D382) --------------------------
; @done
; DATA: 6 feature-bit masks (01,02,80,10,08,04), ADDR_TABLE slot $03; ANDed with the cell feature byte by process_cell_features (GET_B_FROM_TABLE $03).

cell_feature_masks:
		DB $01,$02,$80,$10,$08,$04	; ......
