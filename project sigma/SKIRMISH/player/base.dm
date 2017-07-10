
mob/player
	appearance_flags	= KEEP_TOGETHER
	icon				= '_BaseT.dmi'
	icon_state			= "base-"
	density				= 1
	step_size			= 3
	bound_width			= 14
	can_dopple			= 1
	var
		obj/arms 		= new /obj/player/arms
		obj/shirt		= new /obj/player/shirt
		obj/pants		= new /obj/player/pants
		obj/hair 		= new /obj/player/hair
		obj/vanity		= new /obj/player/vanity
		obj/face		= new /obj/player/face
		pl_indicator	= new /obj/player/indicator


		flicking		= 0	// set to 1 if the player is already flicking an icon state. Prevents a couple graphic issues.
		hair_lock		= 0	// set to 1 if the player shouldn't be allowed to customize their hair (useful when players have custom icons)

	proc
		draw_base()
			draw_planes()
			draw_nametag("[name]", level)
			if(namecolor) new_color(namecolor)
			refresh_hud()
<<<<<<< HEAD
			/* if you need to override certain base appearances for certain players, it's easiest to go about it this way.
			*/
			if(key == "Mickemoose")
				icon				= '_mickebody.dmi'
				icon_state			= "base-"
				hair_lock			= 1
				hair.icon_state		= "micke1"
				hair.pixel_x		= -4
				shirt.icon_state	= null
				pants.icon_state	= null
				vanity.icon_state	= null
			if(key == "Kumoriiiiiiiii")
				icon				= 'player/_alien.dmi'
				icon_state			= "base-"
				arms.icon			= 'player/_alien_arms.dmi'
				face.icon_state		= null
=======
			equipped_weapon 	= new /obj/weapon/gun/pistol
			equipped_special	= new /obj/weapon/special/grenade
			arms.icon_state		= "base-pistol"
			pants.icon_state	= "pants[pick(1,2)]"
			shirt.icon_state	= "shirt[rand(1,11)]"
			hair.icon_state		= "style[rand(1,13)]"
			vanity.icon_state	= "vanity[rand(1,9)]"
			if(key == "Amelia Pond")
				shirt.icon_state 	= "amelia-shirt"
				pants.icon_state 	= "amelia-pants"
				hair.icon_state		= "amelia1"
			if(key == "Ghost of ET")
				hair.icon_state		= "style8"
			if(key == "Kumorii")
				hair.icon_state		= "style10"
				shirt.icon_state	= "shirt10"
				pants.icon_state	= "pants1"
				vanity.icon_state	= "vanity1"
			if(key == "Yut Put")
				hair.icon_state		= "style14"
				shirt.icon_state	= "shirt12"
				pants.icon_state	= "pants1"
			//	vanity.icon_state	= "vanity1"
			if(key == "Saskae7")
				shirt.icon_state	= "shirt9"
				pants.icon_state	= "pants2"
			if(hair.icon_state == "style11" || hair.icon_state == "style13"|| hair.icon_state == "style14") hair.pixel_x = -5
			else hair.pixel_x = 0
>>>>>>> origin/master
			overlays += arms
			overlays += shirt
			overlays += pants
			overlays += hair
			overlays += vanity
			overlays += face
			underlays += pl_indicator


		flick_arms(fstate = "base-")
			if(flicking) return
			flicking = 1
			var/ogstate = arms.icon_state
			overlays -= arms
			arms.icon_state = "[fstate]"
			overlays += arms
			sleep 1
			overlays -= arms
			arms.icon_state = "[ogstate]"
			overlays += arms
			flicking = 0


		arms_state(nstate = "base-")
			overlays -= arms
			arms.icon_state	= "[nstate]"
			overlays += arms


obj/player

	arms
		icon		= 'arms.dmi'
		pixel_x		= -16
		layer		= FLOAT_LAYER+0.23

	shirt
		icon		= '_Clothes.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.1
	pants
		icon		= '_Clothes.dmi'
		icon_state	= "pants"
		layer		= FLOAT_LAYER+0.1
	hair
		icon		= '_Hair.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.21
	face
		icon		= '_Face.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.20
	vanity
		icon		= 'vanity.dmi'
		icon_state	= ""
		layer		= FLOAT_LAYER+0.22
	indicator
		icon				= 'game/misc_effects.dmi'
		icon_state			= "indicator"
		pixel_y				= -4
		pixel_x				= 1
		layer				= TURF_LAYER+0.3
		appearance_flags	= NO_CLIENT_COLOR | KEEP_APART