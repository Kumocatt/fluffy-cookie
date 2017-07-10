

var
	obj/explosion_overlay/EXPLOSION_OVERLAY	= new

obj/explosion_overlay
	icon 			= 'fire.dmi'
	icon_state 		= "explosion"
	plane			= 2
	pixel_x 		= -8
	appearance_flags= NO_CLIENT_COLOR+RESET_TRANSFORM
	New()
		..()
		draw_spotlight(x_os = -30, y_os = -38, hex = "#FFCC00", size_modi = 2.5, alph = 233)


		// <--------- Procs and stuff --------->

proc
	spontaneous_explosion(turf/_loc, pk = 0, dmg = -100, list/bodyparts)	// pk = true if explosions hurt players too.
		set waitfor = 0
		if(_loc)
			var/obj/hazard/boom_marker/boom	= garbage.Grab(/obj/hazard/boom_marker)
			boom.loc						= _loc
			if(bodyparts) boom.Explode(42, dmg, , pk, , bodyparts)
			else boom.Explode(42, dmg, , pk)

	gib(list/gibs,_loc)
		set waitfor = 0
		for(var/obj/gib in gibs)
			var/wait_time = world.tick_lag * rand(1,30)
			var/half_wait = wait_time / 2
			var/turn_degree = rand(-160,160)
			gib.loc = _loc
			var/matrix/m = matrix()
			m.Turn(turn_degree)
			m.Scale(3)
			animate(gib,transform = m,time = half_wait)
			animate(gib,pixel_z = rand(-160,160),pixel_w = rand(-160,160),time = wait_time)
			sleep(wait_time / 2)
			m = matrix()
			m.Turn(turn_degree)
			animate(gib,transform = m,time = half_wait)
			spawn(wait_time - 3) gib.layer = OBJ_LAYER
			spawn(203) gib.layer = EFFECTS_LAYER + 0.1
			gib.spawndel(200)

obj/gib
	is_garbage  = 1
	layer 		= EFFECTS_LAYER + 0.1
	appearance_flags = PIXEL_SCALE

	feeder
		icon = 'feederchunks.dmi'
	crawlerwhite
		icon	= 'white_crawlerchunks.dmi'
	crawlergrey
		icon	= 'grey_crawlerchunks.dmi'
	brute
		icon	= 'brutechunks.dmi'
	abstract1
		icon	= 'abstract1chunks.dmi'
	puker
		icon	= 'pukerchunks.dmi'

mob
	var
		list/bodyparts

atom
	movable
		var
			is_explosive	= 0
			exploded		= 0
			explosion_proof	= 0 // 1 if the mob can't be hurt by explosions.

		proc
			Explode(blastbounds = 1, damage = -100, mob/owner, pk = 0, green_smoke = 0, list/bodyparts = null)
				if(is_explosive && (exploded == 0 || exploded == 2))		// exploded = 2 for qeued explosions.
					exploded = 1
					overlays.Add(EXPLOSION_OVERLAY)
					for(var/i = 1 to 3)
						if(green_smoke) greensmoke()
						else smoke()
					gs(pick('explosion1.wav','explosion2.wav'))
					drop_boom()
					if(prob(25)) drop_fire(pick(2,4))
					icon_state 	= null
					density		= 0
					if(bodyparts)
						gib(bodyparts,loc)
					for(var/atom/movable/a in obounds(src, blastbounds))
						if(ismob(a))
<<<<<<< HEAD
							a:knockback(10, get_dir(src, a))
							if(a:client) a:client.screen_shake(4,4)
							if(a && !a:explosion_proof && (istype(a, /mob/npc) || (istype(a, /mob/player) && (pk || active_game.PvP || (owner && !owner.client && !istype(owner, /mob/npc/support))))))
=======
							a:knockback(7, get_dir(src, a))
							if(a:client) a:screenshake()
							if(!a:explosion_proof && (istype(a, /mob/npc) || (istype(a, /mob/player) && (pk || active_game.deathmatch || owner && !owner.client))))
>>>>>>> origin/master
								spawn a:edit_health(damage, owner, 1)
						if(isobj(a))
							if(a:is_explosive && !a:exploded)
								if(istype(a, /obj/barricade/barrel))
									a:knockback(7, get_dir(src, a))
									if(!a:litfuse) a:light_fuse(blastbounds, damage, owner, pk, green_smoke, bodyparts) // this will set a timer delay on exploding barrels.
								else
									spawn a.Explode(blastbounds, damage, owner)
							else
								if(istype(a, /obj/barricade/crate))
									spawn a:Break()
								if(istype(a, /turf/terrain/_breakable))
									spawn a:destroy()

					spawn(5)
						overlays.Cut()
						if(istype(src, /obj/barricade/barrel) && !exploded)
							src:repop()
							return
						if(is_garbage)
							exploded = 0
							GC()
						else
							del src
