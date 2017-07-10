UI
	Container
		ItemSelect
			var/tmp
				mob/player/p
				currentProduct = 1
				list/products
				list/currentProducts
				UI/Button/ItemScroll/Scroll/ScrollLeft
				UI/Button/ItemScroll/Scroll/ScrollRight
			New()
				..()
				spawn(1)
					pieces = new
					currentProducts = new
					products = new
					var/UI/Button/Item/Selected = garbage.Grab(/UI/Button/Item/)
					pieces += Selected
					p.client.screen += Selected
					FadeIn(Selected)
					ScrollLeft = garbage.Grab(/UI/Button/ItemScroll/Scroll/)
					ScrollLeft.dir = WEST
					ScrollLeft.transform = matrix(4, 0,MATRIX_TRANSLATE)
					pieces += ScrollLeft
					p.client.screen += ScrollLeft
					FadeIn(ScrollLeft)
					ScrollRight = garbage.Grab(/UI/Button/ItemScroll/Scroll/)
					ScrollRight.dir = EAST
					ScrollRight.transform = matrix(-4, 0,MATRIX_TRANSLATE)
					pieces += ScrollRight
					p.client.screen += ScrollRight
					FadeIn(ScrollRight)
					var/UI/Background/ItemScroll/Sides/Right = garbage.Grab(/UI/Background/ItemScroll/Sides/)
					Right.left = 0
					pieces += Right
					p.client.screen += Right
					FadeIn(Right)
					var/UI/Background/ItemScroll/Sides/Left = garbage.Grab(/UI/Background/ItemScroll/Sides/)
					Left.left = 1
					pieces += Left
					p.client.screen += Left
					FadeIn(Left)
			proc/ChangeProducts(mob/player/p,list/l,currentPos = 1)
				spawn(1)
					products = l
					currentProduct = currentPos
					ArrangeProducts(p)
			proc/ArrangeProducts(mob/player/p,fade)
				if(currentProducts)
					for(var/UI/Button/Item/Product in currentProducts)
						p.client.screen -= Product
						currentProducts -= Product
				var/i2 = 0
				var/i3 = 1
				for(var/i = 1,i <= 5,i++)
					var/UI/Button/Item/Product
					if(i < 3)
						if((currentProduct - i) <= 0)
							Product = products[products.len - i2]
							i2++
						else Product = products[currentProduct - i]
					else if(i == 3)
						Product = products[currentProduct]
						if(p.VendorUI)
							p.CurrentProduct = Product
							p.DescBox.maptext = "<p class='vendor'>[Product.desc]</class>"
							p.ProductName.maptext = "<p class='vendor'>[Product.name]</class>"
							p.VendorCost.maptext = "<p class='vendor'><font color='red'>Cost: [Product:price]</class></font>"
							if((!Product:price||Product:price > p.cashflow) && !Product:none)
								p.VendorUI.donebutton.icon_state = "toomuch"
							else
								p.VendorUI.donebutton.icon_state = "doneb"
						//Product.icon = initial(Product.icon)
					else
						if(((currentProduct + i) - 3) > products.len)
							Product = products[i3]
							i3++
						else Product = products[(currentProduct + i) - 3]
					if(i < 3) Product.screen_loc = "CENTER-[i],CENTER+2"
					else Product.screen_loc = "CENTER+[i - 3],CENTER+2"
					currentProducts += Product
					p.client.screen += Product
					if(fade) spawn(8) FadeIn(Product)

UI/Button/ItemScroll/Scroll
	layer 			= HUD_LAYER + 2
	New()
		..()
		spawn()
			if(dir == WEST)
				icon_state = "left"
				screen_loc = "CENTER-3,CENTER+2"
			if(dir == EAST)
				icon_state = "right"
				screen_loc = "CENTER+3,CENTER+2"
	Click()
		..()
		var/mob/player/p = usr
		if(dir == WEST) p.ItemSelect.currentProduct--
		if(dir == EAST) p.ItemSelect.currentProduct++
		if(p.ItemSelect.currentProduct > p.ItemSelect.products.len) p.ItemSelect.currentProduct = 1
		if(p.ItemSelect.currentProduct < 1) p.ItemSelect.currentProduct = p.ItemSelect.products.len
		var/UI/Button/Product = p.ItemSelect.products[p.ItemSelect.currentProduct]
		Product.Click()

UI/Background/ItemScroll/Sides
	icon_state 		= "box"
	layer 			= HUD_LAYER + 0.1
	screen_loc 		= "CENTER+1,CENTER+2 to CENTER+2,CENTER+2"
	var/tmp/left 	= 0
	New()
		..()
		spawn()
			if(left) screen_loc 	= "CENTER-2,CENTER+2 to CENTER-1,CENTER+2"