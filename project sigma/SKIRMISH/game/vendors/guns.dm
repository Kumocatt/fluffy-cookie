mob/player
	MakeVendor(type)
		..()
		if(type == "gun")
			GunVendor(VendorUI)
			var/UI/gunOverlay		= gunList[1]
			BuildBase(VendorUI,gunOverlay.icon_state,pants.icon_state,face.icon_state,shirt.icon_state,hair.icon_state,vanity.icon_state)
			GenerateContainer(/UI/Container,0.1,2,2,4,100,"Vendor Sign",VendorUI,"<p class='vendor'>GUN VENDOR</class>")
			ItemSelect				= garbage.Grab(/UI/Container/ItemSelect/)
			ItemSelect.p 			= src
			ItemSelect.ChangeProducts(src,gunList)
			VendorUI.baseObject.dir 	= EAST
	proc/GunVendor(UI/Container/c)
		gunList = new
		for(var/i = 1,i <= 10,i++)
			var/UI/Button/Item/Vendor/Gun/o = garbage.Grab(/UI/Button/Item/Vendor/Gun/)
			o.parent 						= c
			o.itemType 						= "gun"
			o.icon 							= 'game/vendors/guns.dmi'
			o.position 						= i
			o.layer 						= HUD_LAYER + 3
			switch(i)
				if(1)
					o.price 		= 25
					o.name 			= "Pistol"
					o.icon_state	= "base-pistol"
					o.gun_type		= /obj/weapon/gun/pistol
					o.step			= 4
					o.desc 			= "A regular ol' pistol."
					o.transform 	= matrix(-26, -2,MATRIX_TRANSLATE)
				if(2)
					o.price 		= 50
					o.name 			= "Kobra"
					o.icon_state	= "base-kobra"
					o.gun_type		= /obj/weapon/gun/kobra
					o.step			= 4
					o.desc			= "Like a pistol, but kooler."
					o.transform 	= matrix(-28, -2,MATRIX_TRANSLATE)
				if(3)
					o.price 		= 75
					o.name 			= "3DG3-10RD"
					o.icon_state	= "base-3dg3-10rd"
					o.gun_type		= /obj/weapon/gun/edge_lord
					o.step			= 4
					o.desc 			= "The perfect gun for people who think Hitler did nothing wrong."
					o.transform 	= matrix(-28, -3,MATRIX_TRANSLATE)
				if(4)
					o.price 		= 100
					o.name 			= "Pink Dream"
					o.icon_state	= "base-pinkdream"
					o.gun_type		= /obj/weapon/gun/pink_dream
					o.step			= 4
					o.desc 			= "If a gun were a relaxing candlelit bubblebath, it would be the Pink Dream."
					o.transform 	= matrix(-28, -3,MATRIX_TRANSLATE)
				if(5)
					o.price 		= 125
					o.name 			= "Krossbow"
					o.icon_state	= "base-krossbow"
					o.gun_type		= /obj/weapon/gun/krossbow
					o.step			= 4
					o.desc 			= "Less gun and more antiquated method of medieval warfare."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(6)
					o.price 		= 400
					o.name 			= "Red Baron"
					o.icon_state	= "base-redbaron"
					o.gun_type		= /obj/weapon/gun/red_baron
					o.step			= 4
					o.desc 			= "Automatic assault rifle that's as red as the blood of its enemies. Last half of mag will set enemies ablaze."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(7)
					o.price 		= 500
					o.name 			= "Uzi"
					o.icon_state	= "base-uzi"
					o.gun_type		= /obj/weapon/gun/uzi
					o.step			= 4
					o.desc 			= "An automatic SMG that handles even better than your mother."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(8)
					o.price 		= 1000
					o.name 			= "El Verde"
					o.icon_state	= "base-elverde"
					o.gun_type		= /obj/weapon/gun/el_verde
					o.step			= 4
					o.desc 			= "Intergalactic laser pistol originally crafted by little green men. Far out."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(9)
					o.price 		= 2500
					o.name 			= "Lysergia"
					o.icon_state	= "base-lysergia"
					o.gun_type		= /obj/weapon/gun/lysergia
					o.step			= 4
					o.desc 			= "Interdimensional weapon tech that shoots bombs of explosive plasma."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
				if(10)
					o.price 		= 4000
					o.name 			= "Stalker"
					o.icon_state	= "base-stalker"
					o.gun_type		= /obj/weapon/gun/stalker
					o.step			= 4
					o.desc 			= "Automatic laser weapon with high fire rate. Crafted by space gunsmiths."
					o.transform 	= matrix(-19, -2,MATRIX_TRANSLATE)
			if(arms.icon_state == "[o.icon_state]")
				o.price = 0
			gunList += o
			c.pieces += o