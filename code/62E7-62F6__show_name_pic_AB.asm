; --- show_name_pic_AB -------------------------------------
; @done
; Show a location screen: draw picture A and print name/text B.
; Patches the SHOW_PIC parameter with A, prints the location name
; for message B, clears the info panel, then displays the picture.
; In:  a = picture id, b = text/name id
; Note: pic_to_show holds the self-modified SHOW_PIC parameter.
show_name_pic_AB:
		; A = picture
		; B = text
		ld	(pic_to_show+2),a
		ld	a,b

		CLEAR_TXT_BUFFER

		PRINT_EMPTY

		PRINT_LOCATION_NAME

		CLEAR_INFO_PANEL

pic_to_show:
		SHOW_PIC_BY_PARAM	0

		ret
