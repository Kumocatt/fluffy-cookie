UI/Highlight
	icon_state = "highlight"
	layer = HUD_LAYER + 10
	plane = 100
	var/tmp
		Type
		position


mob/player
	var/tmp
		UI/Highlight/Highlight
	verb
		Controller_Scroll_Up()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER:8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 2)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER:-8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 3)
						Highlight.position = 4
						Highlight.screen_loc = "CENTER,CENTER+3"
						Highlight.transform = matrix(11, 1, MATRIX_SCALE)
					else if(Highlight.position == 2)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER,CENTER-3"
						Highlight.transform = matrix(9, 1, MATRIX_SCALE)

		Controller_Scroll_Down()
			set hidden = 1
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER:-8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 2)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER:8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					else if(Highlight.position == 3)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER,CENTER-3"
						Highlight.transform = matrix(9, 1, MATRIX_SCALE)
					else if(Highlight.position == 2)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 4
						Highlight.screen_loc = "CENTER,CENTER+3"
						Highlight.transform = matrix(11, 1, MATRIX_SCALE)
		Controller_Scroll_Left()
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						ItemSelect.ScrollLeft.Click()
					else if(Highlight.position == 2)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER:-8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						ScrollLeft.Click()
					else if(Highlight.position == 3)
						ItemSelect.ScrollLeft.Click()
					else if(Highlight.position == 2)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 2
						Highlight.screen_loc = "CENTER,CENTER-3"
						Highlight.transform = matrix(9, 1, MATRIX_SCALE)
		Controller_Scroll_Right()
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 3)
						ItemSelect.ScrollRight.Click()
					else if(Highlight.position == 2)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER:8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 3
						Highlight.screen_loc = "CENTER,CENTER+2"
						Highlight.transform = matrix(7, 1, MATRIX_SCALE)
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 4)
						ScrollRight.Click()
					else if(Highlight.position == 3)
						ItemSelect.ScrollRight.Click()
					else if(Highlight.position == 2)
						Highlight.position = 1
						Highlight.screen_loc = "CENTER,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)
					else if(Highlight.position == 1)
						Highlight.position = 4
						Highlight.screen_loc = "CENTER,CENTER+3"
						Highlight.transform = matrix(11, 1, MATRIX_SCALE)
		Controller_Interact()
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					//Highlight.screen_loc = "CENTER:-8,CENTER - 4"
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
				else if(CharacterCreation)
					CharacterCreation.pieces += Highlight
					Highlight.Type = "Character Creation"
					Highlight.position = 3
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(Highlight.Type == "Vendor")
					if(Highlight.position == 2)
						DissassembleContainer(VendorUI)
						DissassembleContainer(ItemSelect)
						winset(src,"default","macro=\"play\"")
						move_disabled	= 0
						Highlight 		= null
						return
					if(Highlight.position == 1)
						VendorUI.donebutton.Click()
						Highlight = null
				else if(Highlight.Type == "Character Creation")
					if(Highlight.position == 2)
						var/obj/input_box/ibox = get_ibox("Choose Name")
						if(ibox)
							ibox.Click()
					if(Highlight.position == 1)
						CharacterCreation.donebutton.Click()
						Highlight = null
		Controller_B()
			if(!Highlight)
				Highlight = new /UI/Highlight
				if(VendorUI)
					VendorUI.pieces += Highlight
					Highlight.Type = "Vendor"
					Highlight.position = 3
					//Highlight.screen_loc = "CENTER:-8,CENTER - 4"
					Highlight.screen_loc = "CENTER,CENTER+2"
					Highlight.transform = matrix(7, 1, MATRIX_SCALE)
					client.screen += Highlight
			else
				if(VendorUI)
					if(Highlight.position == 2)
						DissassembleContainer(VendorUI)
						DissassembleContainer(ItemSelect)
						winset(src,"default","macro=\"play\"")
						move_disabled	= 0
						Highlight 		= null
					else
						Highlight.position = 2
						Highlight.screen_loc = "CENTER:-8,CENTER-4"
						Highlight.transform = matrix(1, 1, MATRIX_SCALE)