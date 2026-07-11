; --- print_who_will ------------------------------------------
; @done
; Clear the info panel and print the "Who will" prompt prefix.
; Shared opener for the party-action prompts (play_song / use_item
; append the rest of the sentence, e.g. "play?" / "use an item?").
print_who_will:
		CLEAR_INFO_PANEL

		PRINT_MESSAGE	$1E			; "Who will"

		ret
