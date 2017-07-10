proc
	fire_count(turf/t)
		//	called to count how many fire triggers are on a tile.
		if(t)
			var/count = 0
			for(var/obj/hazard/fire/f in t)
				count ++
			return count



atom/movable
	proc/drop_fire(flames = 4, mob/owner, ds = 150)
		/*
			called to spawn fire around a given object.
		*/
		var/list/turf_list = new /list()
		for(var/turf/t in bounds(8, src))
			if(!t.density) turf_list += t
		if(turf_list.len) for(var/i = 0 to flames)
			var/turf/t = pick(turf_list)
			switch(fire_count(t))
				if(0)
					var/obj/hazard/fire/f 		= garbage.Grab(/obj/hazard/fire)
					f.owner						= owner
					f.loc						= t
					f.step_x					= 0
					f.step_y					= pick(0,8) // randomize things a lil
					f.spawndel(ds)
				if(1)
					for(var/obj/hazard/fire/p in t)
						. = p.step_y;break
					var/obj/hazard/fire/f 		= garbage.Grab(/obj/hazard/fire)
					f.owner						= owner
					f.loc						= t
					f.step_x					= 0
					f.step_y					= (. ? 0 : 8)
					f.spawndel(ds)






obj/barricade
	barrel
		icon 			= '32x32.dmi'
		icon_state 		= "barrel"
		density 		= 1
		layer 			= TURF_LAYER+2
		step_size		= 2
		is_explosive	= 1
		d_ignore		= 0
		var/litfuse		= 0	// 1 if about to explode.

		repop()
			set waitfor = 0
			sleep 200
			loc 		= initial(loc)
			icon_state 	= initial(icon_state)
			density 	= 1
			exploded	= 0
			litfuse		= 0

		proc
			light_fuse(blastbounds = 1, damage = -100, mob/owner, pk = 0, green_smoke = 0, list/bodyparts = null)
				set waitfor = 0
				animate(src, transform = matrix()*1.2, time = 3, easing = ELASTIC_EASING, loop = -1)
				animate( transform = matrix()*0.9, time = 3, loop = -1)
				sleep 12
				transform = matrix()
				Explode(blastbounds, damage, owner, pk, green_smoke, bodyparts)



	proc
		repop()
			set waitfor = 0
			sleep 200
			loc 		= initial(loc)
			icon_state 	= initial(icon_state)
			density 	= 1
			exploded	= 0

obj/hazard
	is_garbage	= 1
	GC()
		alpha = 255
		..()
	mine
		icon		= 'combat/_Bullets.dmi'
		icon_state	= "mine"
		is_explosive= 1
		layer		= TURF_LAYER+0.2
		bound_x		= 8
		bound_width	= 8
		bound_height= 8
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a))
				Explode(16, -80, owner, 1)
		GC()
			icon_state	= "mine"
			exploded 	= 0
			..()

	fire
		icon				= 'effects/fire.dmi'
		icon_state			= "fire1"
		appearance_flags	= NO_CLIENT_COLOR
		blend_mode			= BLEND_ADD
		plane				= 2
		bound_x				= 8
		bound_y				= 2
		bound_height		= 8
		New()
			..()
			if(prob(5))
				if(prob(50))
					icon_state = "hellfire"
					draw_spotlight(x_os = -30, y_os = -38, hex = "#FF3333", size_modi = 3, alph = 200)
				else
					icon_state = "fireproof"
					draw_spotlight(x_os = -30, y_os = -38, hex = "#99CCFF", size_modi = 3, alph = 200)
			else
				icon_state	= "fire[pick(1,2)]"
				draw_spotlight(x_os = -30, y_os = -38, hex = "#FFCC00", size_modi = 3, alph = 200)
			animate(src, transform = matrix()*1.1, time = 2, loop = -1)
			animate(transform = matrix()/0.9, time = 2, loop = -1)
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a))
				if(icon_state == "fireproof")
					a:fireproof()
				else
					if(icon_state == "hellfire")
						a:burn(,1)
					else a:burn()
			else if(istype(a, /obj/projectile) && a.icon_state == "bullet")
				a.icon_state = "firebullet"
			else if(istype(a, /obj/barricade))
				GC()


	puke
		icon				= 'combat/_Bullets.dmi'
		icon_state			= "puke1"
		appearance_flags	= NO_CLIENT_COLOR
		bound_x				= 8
		bound_y				= 2
		bound_height		= 8
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(ismob(a)) a:slow()

	spikes
		icon		= 'combat/projectiles.dmi'
		icon_state	= "spikes-off"
		layer		= TURF_LAYER+0.2
		Crossed(atom/movable/a)
			if(icon_state == "spikes-on" && ismob(a))
				a:edit_health(-15)
			else if(ismob(a))
				sleep 5
				icon_state = "spikes-on"
				sleep 20
				icon_state = "spikes-off"
		GC()
			icon_state = "spikes-off"
			..()

/*	sacriportal
		icon		= 'combat/projectiles.dmi'
		icon_state	= "sacrispikes"
		layer		= TURF_LAYER+0.2
		var/tmp/bloodgained = 0
		Crossed(atom/movable/a)
			if(icon_state == "sacrispikes" && ismob(a))
				a:edit_health(-20)
				bloodgained += 20
				if(bloodgained >= 100)
					bloodgained = 0
					var/obj/hazard/portal/p = new
					p.loc = loc
					del src
<<<<<<< HEAD
*/
=======

	portal
		icon				= 'game/misc_effects.dmi'
		icon_state			= "portal-closed"
		appearance_flags	= NO_CLIENT_COLOR
		plane				= 2
		bound_x				= 3
		New()
			..()
			icon_state	= "portal-open"
			active_game.portals.Add(src)
		var/tmp
			mob/owner
		Crossed(atom/movable/a)
			if(a.can_teleport && icon_state == "portal-open")
				flick("portal-use",src)
				a:portal(owner)

>>>>>>> origin/master
	edge_spike
		icon		= '_new x16.dmi'
		icon_state	= "spikes"
		layer		= TURF_LAYER+0.2
		Cross(atom/movable/a)
			if(ismob(a))
				if(get_general_dir(src, a) == SOUTH)
					a:edit_health(-6)
					a:knockback( 8, get_dir(src,a))

				if(get_general_dir(src, a) == NORTH)
					a:edit_health(-6)
					a:knockback( 8, get_dir(src,a))
				return 0
		GC()
			..()

	boom_marker	// used to create explosions on the fly.
		is_explosive 	= 1
		exploded		= 0


var
	obj/overlays/fire/FIRE_OVERLAY			= new
	obj/overlays/censor_bar/CENSOR_OVERLAY	= new
	obj/overlays/cowbell/COWBELL_OVERLAY	= new
	obj/overlays/crown/CROWN_OVERLAY		= new
	obj/overlays/stun/STUN_OVERLAY			= new


obj/overlays
	fire
		icon 			= 'fire.dmi'
		icon_state 		= "fire1"
		plane			= 2
		layer			= FLOAT_LAYER
		pixel_x 		= -6
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM
		blend_mode		= BLEND_ADD
	shield1
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield1"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	shield2
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield2"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	shield3
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield3"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	npc_shield1
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield1"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		pixel_x			= 6
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	npc_shield2
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield2"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		pixel_x			= 6
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	npc_shield3
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shield3"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		pixel_x			= 6
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	shield_of_russia
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "shieldrussia"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR
	cowbell
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "cowbell"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= 32
		pixel_x			= -4
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM
	crown
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "crown"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= 32
		pixel_x			= -4
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM
	censor_bar
		icon				= 'game/misc_effects.dmi'
		icon_state			= "censorbar"
		layer				= FLOAT_LAYER
		plane				= 2
		appearance_flags	= NO_CLIENT_COLOR
	reload
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "reloading"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= -2
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM
	revive_indicator
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "revive1"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= 14
		pixel_x			= -13
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM
	stun
		icon 			= 'game/misc_effects.dmi'
		icon_state 		= "stun"
		plane			= 3
		layer			= FLOAT_LAYER
		pixel_y 		= 20
		pixel_x			= -4
		appearance_flags= NO_CLIENT_COLOR+KEEP_APART+RESET_COLOR+RESET_TRANSFORM



mob
	var/tmp
		fireproof	= 0
		on_fire		= 0
		bleeding	= 0
		can_bleed	= 1
		censored	= 0
		can_censor	= 1
		shocked		= 0
		can_shock	= 1
		cowbell		= 0
		invincible	= 0
		speed_flux	= 0
		slowed		= 0
		can_slow	= 1
		shielded	= 0
	proc
		burn(mob/owner, hellfire = 0)
			set waitfor = 0
			if(!on_fire && !fireproof)
				on_fire	= 1
				overlays += FIRE_OVERLAY
				animate(src, color = "#303030", time = 10, loop = -1)
				animate(color = null, time = 10)
				var/i = 0
				while(health && on_fire && !active_game.intermission && !fireproof)
					if(!hellfire && i > pick(5,12))
						break
					edit_health(-2, owner)
					if(prob(5)) drop_fire(1, src)
					i ++
					sleep 5
				animate(src)
				overlays -= FIRE_OVERLAY
				on_fire = 0

		bleedout(time = 1, mob/owner)
			set waitfor = 0
			if(!bleeding && can_bleed)
				bleeding	= 1
				var/i 		= 0
				while(health && bleeding && !active_game.intermission)
					if(i > pick(5,12))
						break
					edit_health(-2, owner)
					i ++
					sleep 5
				bleeding = 0

		shock(time = 1, mob/owner)
			set waitfor = 0
			if(!shocked && can_shock)
				shocked	= 1
				var/i 	= 0
				while(health && shocked && !active_game.intermission)
					if(i > pick(5,12))
						break
					edit_health(-1, owner)
					if(move_disabled) move_disabled = 0
					else	move_disabled = 1
					i ++
					sleep 5
				shocked 			= 0
				move_disabled	= 0


		censor(remove = 0)
			if(!censored && can_censor)
				censored = 1
				overlays += CENSOR_OVERLAY
				if(istype(src, /mob/player))
					overlays -= src:shirt
					overlays -= src:pants
			else if(remove)
				censored = 0
				if(istype(src, /mob/player))
					overlays += src:shirt
					overlays += src:pants
				overlays -= CENSOR_OVERLAY


		fireproof()
			set waitfor = 0
			if(!fireproof)
				fireproof 	= 1
				animate(src, color = "blue", time = 10, loop = -1)
				animate(color = null, time = 10, loop = -1)
				sleep 300
				fireproof 	= 0
				animate(src)

		shield(_addpower = 0, npc_shield = 0)
			/*
				you can call shield() with no args and it will refresh the shield overlay to keep it accurate.
			*/
			if(shielded) return // if shielded already by an exotic shield; stop
			shield += _addpower
			if(shield < 0) shield = 0
			if(shield > 3) shield = 3
			if(npc_shield) 	overlays.Remove(NPCSHIELD_OVERLAY1, NPCSHIELD_OVERLAY2, NPCSHIELD_OVERLAY3)
			else			overlays.Remove(SHIELD_OVERLAY1, SHIELD_OVERLAY2, SHIELD_OVERLAY3)
			if(shield)
				if(shield == 1)
					if(npc_shield)	overlays += NPCSHIELD_OVERLAY1
					else			overlays += SHIELD_OVERLAY1
					edit_spotlight(, , "#ecc8b8", 1.3, )
				else if(shield == 2)
					if(npc_shield)	overlays += NPCSHIELD_OVERLAY2
					else			overlays += SHIELD_OVERLAY2
					edit_spotlight(, , "#1e8ef6", 1.6, )
				else if(shield == 3)
					if(npc_shield)	overlays += NPCSHIELD_OVERLAY3
					else			overlays += SHIELD_OVERLAY3
					edit_spotlight(, , "#df5333", 1.9, )
			else edit_spotlight(, , "#ffffff", 0.8, )

		shield_of_russia(npc_shield = 0)
			set waitfor = 0
			shielded = 1 // to stop other shield drops from being picked up by owners of this shield.
			shield = 3
			var/last_hp  = health// the last hp of the owner
			var/last_shield = 0
			while(src) // shield of russia serve always, comrade
				if(last_shield == shield)
					if(!shield)
						. ++
						if(last_hp != health) . = 0
						if(. > 30) shield = 3;. = 0
				else
					if(!shield)
						overlays.Remove(SHIELD_RUSSIA)
					else if(!last_shield)
						overlays += SHIELD_RUSSIA
					last_shield = shield
				sleep 5


		cowbell()
			set waitfor = 0
			if(!cowbell)
				cowbell	= 1
				overlays += COWBELL_OVERLAY
				var/i 	= 0
				while(health && cowbell)
					if(i > 5) break
					i ++
					sleep 10
				cowbell = 0
				overlays -= COWBELL_OVERLAY
		slow()
			set waitfor = 0
			if(!slowed && can_slow)
				slowed	= 1
			//	overlays += SLOWED_OVERLAY
				var/i 			= 0
				var/init_stize 	= step_size
				step_size		= 1
				while(health && slowed)
					if(i > 2) break
					i ++
					sleep 10
				slowed 		= 0
				step_size	= init_stize
			//	overlays -= SLOWED_OVERLAY
