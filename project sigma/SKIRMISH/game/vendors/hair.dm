mob/player
	MakeVendor(type)
		..()
		if(type == "hair")
			HairVendor(VendorUI)
			var/UI/hairOverlay		= hairList[1]
			BuildBase(VendorUI,arms.icon_state,pants.icon_state,face.icon_state,shirt.icon_state,hairOverlay.icon_state,vanity.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>HAIR VENDOR</class>")
			ItemSelect 				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,hairList)
	proc/HairVendor(UI/Container/c)
		hairList = new
		var/pos = 1
		for(var/i = 0,i <= 28,i++)
			if(i == 14) continue
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = pos
			pos++
			o.itemType = "hair"
			o.icon = 'player/_Hair.dmi'
			o.icon_state = "style[i]"
			switch(i)
				if(1)
					o.price		= 10
					o.name		= "The Classic"
					o.desc		= "Classic messy look for you OG feeders."
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(2)
					o.price 	= 10
					o.name		= "Green Danger"
					o.desc		= "A green mohawk that says, \"I'm not afraid to make poor life choices!\""
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(3)
					o.price		= 10
					o.name		= "Hockey Mask"
					o.desc		= "Just like from summer camp!"
					o.transform = matrix(-10, -19,MATRIX_TRANSLATE)
				if(4)
					o.price		= 10
					o.name		= "Book Worm"
					o.desc		= "Ther perfect look if you chose to read instead of groom yourself."
					o.transform = matrix(-10, -19,MATRIX_TRANSLATE)
				if(5)
					o.price		= 10
					o.name		= "Emo Swoop"
					o.desc		= "Yeah, I listen to Pierce the Veil, what of it?"
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(6)
					o.price		= 10
					o.name		= "Adventurer's Cap"
					o.desc		= "A green cap that belonged to a hero from a distant land."
					o.transform = matrix(-10, -22,MATRIX_TRANSLATE)
				if(7)
					o.price		= 10
					o.name		= "Bowl Head"
					o.desc		= "Don't laugh, some people actually think this is cool."
					o.transform = matrix(-10, -19,MATRIX_TRANSLATE)
				if(8)
					o.price		= 10
					o.name		= "Not A Fedora"
					o.desc		= "Fedoras are cooler."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(9)
					o.price		= 50
					o.name		= "Bat Cowl"
					o.desc		= "Be the hero Got- I mean, Feed needs!"
					o.transform = matrix(-10, -20,MATRIX_TRANSLATE)
				if(10)
					o.price		= 50
					o.name		= "Computer Nerd"
					o.desc		= "Are you a loser with no social life, too?"
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(11)
					o.price		= 50
					o.name		= "Sun Hat"
					o.desc		= "A perfect hat for sittin' on the ol' front porch, chewin' tobaccy and making casually racist comments."
					o.transform = matrix(-14, -23,MATRIX_TRANSLATE)
				if(12)
					o.price		= 50
					o.name		= "Blue Danger"
					o.desc		= "A blue mohawk that says, \"I like to skateboard and listen to grunge!\""
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(13)
					o.price		= 50
					o.name		= "Sage Hat"
					o.desc		= "Mystic sage or old hobo with a fancy hat? You decide!"
					o.transform = matrix(-14, -23,MATRIX_TRANSLATE)
				if(15)
					o.price		= 50
					o.name		= "Middle-aged Denial"
					o.desc		= "I still have hair, what do you mean I should just commit?"
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(16)
					o.price		= 50
					o.name		= "Red Sage Hat"
					o.desc		= "Perfect for your mage cosplay, ya fuckin' nerd."
					o.transform = matrix(-14, -23,MATRIX_TRANSLATE)
				if(17)
					o.price		= 50
					o.name		= "Goldilocks"
					o.desc		= "Hopefully there aren't any bears. Fuck bears."
					o.transform = matrix(-10, -22,MATRIX_TRANSLATE)
				if(18)
					o.price		= 50
					o.name		= "Snow White"
					o.desc		= "Perfect for making people question whether you're old or just weird."
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(19)
					o.price		= 50
					o.name		= "White Beanie"
					o.desc		= "Just a white beanie, dude."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(20)
					o.price		= 50
					o.name		= "Electric Haze"
					o.desc		= "Perfect if your an edgy 15 year old girl."
					o.transform = matrix(-10, -19,MATRIX_TRANSLATE)
				if(21)
					o.price		= 100
					o.name		= "Micke's Moose Mask"
					o.desc		= "A mask inspired by the popular Micke the Moose games!"
					o.transform = matrix(-15, -18,MATRIX_TRANSLATE)
				if(22)
					o.price		= 100
					o.name		= "Shaggy Brown"
					o.desc		= "A shaggy brown do for you."
					o.transform = matrix(-10, -23,MATRIX_TRANSLATE)
				if(23)
					o.price		= 100
					o.name		= "Something unoffensive"
					o.desc		= "I can't think of anything that isn't rude. Sorry.."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(24)
					o.price		= 100
					o.name		= "Black Widow"
					o.desc		= "Black and sleak. like your soul or something."
					o.transform = matrix(-10, -19,MATRIX_TRANSLATE)
				if(25)
					o.price		= 100
					o.name		= "Old Gentleman"
					o.desc		= "Perfect combination of age and civility."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(26)
					o.price		= 115
					o.name		= "Black Durag"
					o.desc		= "Are you a gangster? Do you have a durag? Every gangster has a durag."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(27)
					o.price		= 100
					o.name		= "Red Beanie"
					o.desc		= "Red beanie to hide all the blood stains!"
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)
				if(28)
					o.price		= 100
					o.name		= "Blue Beanie"
					o.desc		= "Beanie, don't be so blue."
					o.transform = matrix(-10, -24,MATRIX_TRANSLATE)


			o.transform *= 0.5
			hairList += o
			VendorUI.pieces += o
			if(hair.icon_state == "[o.icon_state]") o.price = 0
			if(i == 0)
				o.none 	= 1
				o.price = 0
		if(key == "Amelia Pond")
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = pos
			o.itemType = "hair"
			o.icon = 'player/_Hair.dmi'
			o.icon_state = "amelia1"
			o.transform = matrix(-10, -22,MATRIX_TRANSLATE)
			o.transform *= 0.5
			hairList += o
			VendorUI.pieces += o
			if(hair.icon_state == "[o.icon_state]") o.price = 0