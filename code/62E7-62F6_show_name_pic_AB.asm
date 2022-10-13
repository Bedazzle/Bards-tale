show_name_pic_AB:
		; A = picture
		; B = text
		ld	(pic_to_show+2), a
		ld	a, b

		CLEAR_TXT_BUFFER

		PRINT_EMPTY

		PRINT_LOCATION_NAME

		CLEAR_INFO_PANEL

pic_to_show:
		SHOW_PIC_BY_PARAM	0

		ret
