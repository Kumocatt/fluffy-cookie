mob/player/var/tmp/list/faceList

mob/player
	MakeVendor(type)
		..()
		if(type == "face")
			FaceVendor(VendorUI)
			var/UI/faceOverlay	= faceList[1]
			BuildBase(VendorUI,arms.icon_state,pants.icon_state,faceOverlay.icon_state,shirt.icon_state,hair.icon_state,vanity.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>FACE VENDOR</class>")
			ItemSelect 				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,faceList)
	proc/FaceVendor(UI/Container/c)
		faceList = new
		for(var/i = 1,i <= 10,i++)
			var/UI/Button/Item/Vendor/o = garbage.Grab(/UI/Button/Item/Vendor/)
			o.parent = c
			o.position = i
			o.itemType = "face"
			o.icon = 'player/_Face.dmi'
			o.icon_state = "face[i]"
			o.transform = matrix(-2, -10,MATRIX_TRANSLATE)
			switch(i)
				if(1)
					o.price		= 10
					o.name		= "Normal"
					o.desc		= "The default look."
				if(2)
					o.price		= 10
					o.name		= "Angry Mr. Bean"
					o.desc		= "For a comedic angry look."
				if(3)
					o.price		= 50
					o.name		= "Novelty Face"
					o.desc		= "Does it get any better than novelty nose glasses?"
				if(4)
					o.price		= 50
					o.name		= "XTC"
					o.desc		= "Ecstacy is a hell of a drug."
				if(5)
					o.price		= 100
					o.name		= "Stoned Eyes"
					o.desc		= ".. what?"
				if(6)
					o.price		= 100
					o.name		= "Eyes of Oz"
					o.desc		= "Bright green eyes. Like the Emerald City."
				if(7)
					o.price		= 200
					o.name		= "Hexxed"
					o.desc		= "Need a look to reflect your soulless husk of a body? Look no further!"
				if(8)
					o.price		= 200
					o.name		= "Eye for an Eye"
					o.desc		= "Welp, you could keep your eyes. ..OR you could let me gouge them out and then pay me $200?"
				if(9)
					o.price		= 100
					o.name		= "Fuckless"
					o.desc		= "Ideal look if you want to show off all the fucks you don't give."
				if(10)
					o.price		= 100
					o.name		= "X_x"
					o.desc		= "lol dedface"
			faceList += o
			VendorUI.pieces += o
			if(face.icon_state == "[o.icon_state]") o.price = 0