
var
	tmp
<<<<<<< HEAD
		list/ai_list 	= new/list()
	speed_modi			= 5
=======
		list/ai_list = new/list()
>>>>>>> origin/master


proc
	ai_loop()
		set waitfor = 0
		for()
			if(active_game.pause) while(active_game.pause && active_game.started == 2 ) sleep 5
			if((support_ai.len || ai_list.len) && active_game.started == 2) for(var/mob/npc/m in ai_list+support_ai)	// tracks support ai and enemy ai
				if(active_game.intermission && istype(m, /mob/npc/hostile))
		//			world << "debug: enemies leftover during intermission ; culling."
					m.health = 0
					m.GC()
					ai_list -= m
				else if(!m.stunned)
					if(istype(m,/mob/npc/hostile/puppet_master)) m:puppet.ai_check()
					m.ai_check()
			sleep world.tick_lag

	speed_modifier()
		/*
			call this to set the speed_modi variable which controls the speed enemies move.
			Enemies will get incrementally faster over the first 20 waves.
		*/
		var/divisor = round(active_game.current_round/2)
		if(divisor < 1) divisor = 1
		if(divisor > 10) divisor = 10
		speed_modi = 5.0/divisor



mob/npc
	is_garbage			= 1
	bound_height		= 20
	var/tmp
		resting			= 0 // whether or not the npc should get ignored by the ai loop proc
		ig_bump			= 0 // 1 if Bump() should be ignored.
		lock_step		= 0	// 1 if the npc's step size shouldn't scale with wave progression.
		auto_target		= 1	// 1 if the mob should automatically target the nearest player.
		has_spotlight 	= 1 // 1 if the mob should/can have a spotlight
		can_phantom		= 1	// 0 if the enemy is immune to phantom status
		mob/target


	proc
		generate_gibs()
		ai_check()
			// this is where you add the npcs behavior.
			if(!target) // target selection
<<<<<<< HEAD
				if(prob(55))
					/* when no target is had, add a chance to step around or do quirky stuff.
					*/
					step(src, pick(dir, turn(dir, pick(-45, 45))))
					if(prob(35)) // chance to hop in place.
						dust()
						animate(src, pixel_z = 8, time = 3)
						animate(pixel_z = 0, time = 2, easing = BOUNCE_EASING)
				for(var/mob/p in (active_game.participants+support_ai))
					if(!p.health || !p.loc || p.z != z) continue
					if(p.cowbell)
						target = p
						break	// since cowbells will attract every enemy.
					if(!target) if(get_dist(src, p) <= 15) target = p
=======
				if(prob(55)) step(src, pick(dir, turn(dir, pick(-45, 45))))
				for(var/mob/p in (active_game.participants+support_ai))
					if(!p.health || !p.loc || p.cowbell) continue
					if(!target) if(get_dist(src, p) <= 12) target = p
>>>>>>> origin/master
					else if(get_dist(src, p) < get_dist(src, target))
						target = p
				if(!target && prob(25)) respawn()

	Bump(atom/a)
		if(kb_init)
			kb_init = 0
			if(istype(a, /mob/player) || istype(a, /mob/npc))
				a:knockback(6, get_dir(src, a))
			stun()
		if(istype(a, /obj/barricade))
			var/obj/barricade/b = a
			if((kb_init || istype(src, /mob/npc/hostile/brute)) && istype(b, /obj/barricade/crate))
				b:Break()
			else
				b.last_pusher = src
				step(b, dir)
		if(!ig_bump && target && world.cpu < 40)
			ig_bump = 1
			step_to(src, target, 0,0)
			ig_bump = 0

	hostile
		verb/killoffdel()
			set src in oview()
			world << "del'ing [src]"
			del src
		var/tmp
			mob/player/last_attacker
			turf/last_loc
			same_loc_steps	// how many times the mob has been stuck in the same tile.
			spawn_rate	= 100
			mob/npc/hostile/puppet_master/puppet_master

		New()
			..()
			if(has_spotlight && !spotlight) draw_spotlight(x_os = -41, y_os = -38, hex = "#FFFFFF", size_modi = 0.8, alph = 155)//"#FF3333")
		GC()
			..()
			if(censored) censor(1)
			if(puppet_master) puppet_master = null
			if(can_smudge) clear_smudges(src)
			world << "test 2"
			animate(src, 0)
			density			= 1
			alpha			= 255
			last_attacker	= null
			transform		= matrix()
			step_size		= initial(step_size)

		death()
//			world << "check?"
			if(puppet_master)
				ai_list -= puppet_master
				puppet_master.GC()
			else ai_list -= src
			if(last_attacker) last_attacker.kills ++
			density	= 0
			death_animation()
			sleep 5
			..()
			active_game.enemies_left --
			if(prob(15)) drop_loot()
			if(is_explosive) // if is_explosive is toggled on for the mob, that means to blow it up when it dies!
				is_explosive = 0
				if(bodyparts) spontaneous_explosion(loc,1,-45,bodyparts)
				else spontaneous_explosion(loc, 1, -45)
			GC()
			active_game.progress_check()

//////////////////////////////////////



		puppet_master
			base_health = 35
			kill_score	= 20
			spawn_rate 	= 50
			var/tmp/
				mob/npc/hostile/puppet
				shiftiness = 100

			New()
				..()
				shiftiness = rand(1,100)
				puppet = garbage.Grab(pick(active_game.spawnlist + /mob/npc/hostile/feeder))
				puppet.puppet_master = src

			ai_check()
				set waitfor = 0
				spawn
					if(!resting)
						if(prob(shiftiness))
							resting = 1
							animate(puppet,transform = matrix(0,0,MATRIX_SCALE),time = world.tick_lag * 10)
							puppet.smoke()
							sleep(world.tick_lag * 10)
							var/turf/spawnpoint 	= puppet.loc
							var/stepx 				= puppet.step_x
							var/stepy 				= puppet.step_y
							var/newhealth 			= puppet.health
							puppet.GC()
							puppet 					= garbage.Grab(pick(active_game.spawnlist + /mob/npc/hostile/feeder))
							puppet.SetLoc(spawnpoint,stepx,stepy)
							puppet.health 			= newhealth
							puppet.puppet_master 	= src
							puppet.transform 		= matrix(0,0,MATRIX_SCALE)
							puppet.can_hit			= 1
							animate(puppet,transform = matrix(1,1,MATRIX_SCALE),time = world.tick_lag * 10)
							sleep(world.tick_lag * 100)
							resting = 0
			GC()
				puppet	= null
				loc 	= null
				..()

		bleeder
			icon			= 'enemies/bleeder.dmi'
			icon_state		= "bleeder1"
			density			= 1
			bound_x			= 8
			step_size		= 3
			base_health		= 10
			kill_score		= 2
			var/obj/guts	= new/obj
			var/obj/blood	= new/obj
			var/bodcolor	= null
			New()
				..()
				bodcolor			= rgb(rand(100,200),rand(100,200),rand(100,200))
				guts.icon			= 'enemies/bleeder.dmi'
				guts.icon_state		= "guts1"
				guts.layer			= MOB_LAYER
				blood.icon			= 'enemies/bleeder.dmi'
				blood.layer			= MOB_LAYER
				overlays.Add(guts, blood)
				icon				+= bodcolor
				draw_spotlight(x_os = -33, y_os = -31, hex = "#FFFFFF", size_modi = 0.8, alph = 155)

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
										target = p
							if(bounds_dist(src, target) <= 2)
						//		flick("[icon_state]-attack", src)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								drop_blood(1)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep 4.4
					resting = 0




		shade
			icon			= 'enemies/shade.dmi'
			icon_state		= "shade"
			density			= 1
			step_size		= 2
			base_health		= 45
			fireproof		= 1
			can_censor		= 0
			kill_score		= 15
			spawn_rate		= 45
			var/obj/weapon/special/skill1 = new /obj/weapon/special/shadowball

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(get_dist(src, target) <= 2)
								if(!step_away(src, target))
									smoke()
									smoke()
									smoke()
									animate(src, alpha = 0, time = 3, loop = 1)
									loc = pick(active_game.enemy_spawns)
									animate(src, alpha = 255, time = 3, loop = 1)
							else if(get_dist(src, target) < 6 && skill1.can_use && shot_lineup())
								flick("shade-attack", src)
								sleep 2.2
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 3
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1
					resting = 0


		slammer
			icon			= 'enemies/slammer.dmi'
			icon_state		= "slammer"
			density			= 1
			step_size		= 2
			base_health		= 35
			kill_score		= 10
			spawn_rate		= 5

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(8, step_dir)
								target.edit_health(-30)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1.5
					resting = 0


		blaze
			icon			= 'enemies/_Blaze.dmi'
			icon_state		= "blaze"
			density			= 1
			step_size		= 2
			base_health		= 30
			fireproof		= 1
			can_censor		= 0
			can_phantom		= 0
			kill_score		= 15
			spawn_rate		= 20
			var/obj/weapon/special/skill1 = new /obj/weapon/special/fireblast

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("blaze-attack", src)
								sleep 3
								target.knockback(6, step_dir)
								target.edit_health(-20)
								target.burn(src)
								sleep 10
							else if(prob(25) && get_dist(src, target) < 5 && skill1.can_use && shot_lineup())
								flick("blaze-attack", src)
								sleep 1.2
								dir = get_general_dir(src, target)
								skill1.use(src)
								sleep 5
							else if(!kb_init)
								step(src, step_dir)
								if(prob(30)) drop_fire(1, src, 5)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep world.tick_lag*1.5
					resting = 0

		charger
			icon			= 'enemies/_Charger.dmi'
			icon_state		= "charger"
			density			= 1
			step_size		= 3
			base_health		= 20
			is_explosive	= 1
<<<<<<< HEAD
			kill_score		= 10
			spawn_rate		= 60
=======
>>>>>>> origin/master
			var/obj/blood	= new/obj
			var/bodcolor	= null
			var/charging	= 0
			New()
				..()
				bodcolor			= rgb(rand(100,200),rand(100,200),rand(100,200))
				blood.icon			= 'enemies/_Charger.dmi'
				blood.icon_state	= "blood"
				blood.layer			= MOB_LAYER
				overlays			+= blood
				icon				+= bodcolor
			GC()
				charging		= 0
				is_explosive	= 1
				..()
			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if((bounds_dist(src, target) <= 20) && !charging)
								charging				= 1
								var/obj/mouthanim		= new/obj
								var/obj/tummyanim		= new/obj
								var/obj/mouth			= new/obj
								var/obj/tummy			= new/obj
								mouthanim.icon			= 'enemies/_Charger.dmi'
								mouthanim.icon_state	= "mouth_anim"
								mouthanim.layer			= MOB_LAYER
								tummyanim.icon 			= 'enemies/_Charger.dmi'
								tummyanim.icon_state	= "tummy_anim"
								tummyanim.layer			= MOB_LAYER
								tummyanim.icon			+= bodcolor
								mouth.icon				= 'enemies/_Charger.dmi'
								mouth.icon_state		= "mouth"
								mouth.layer				= MOB_LAYER
								tummy.icon 				= 'enemies/_Charger.dmi'
								tummy.icon_state		= "tummy"
								tummy.layer				= MOB_LAYER
								tummy.icon				+= bodcolor
								overlays				+= mouthanim
								overlays				+= tummyanim
								sleep(5.6)
								overlays				-= mouthanim
								overlays				-= tummyanim
								overlays				+= mouth
								overlays				+= tummy
							if(bounds_dist(src, target) <= 2)
								charging = 0
								Explode(30,-30,src,1)
								death()
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					if(!charging) sleep 2
					else
						sleep world.tick_lag*1.5
					resting = 0

		feeder
			icon			= 'enemies/_Zombie.dmi'
			icon_state		= "feeder"
			density			= 1
			step_size		= 3
			bound_x			= 8
			base_health		= 18
			kill_score		= 5
			spawn_rate		= 100
			can_smudge		= 1
			pixel_x			= 2
			var/obj/blood	= new/obj
			var/obj/shirt	= new/obj
			var/bodcolor	= null
			New()
				if(has_spotlight && !spotlight) world << "woohoo";draw_spotlight(x_os = -33, y_os = -38, hex = "#FFFFFF", size_modi = 0.8, alph = 155)
				..()
				bodcolor			= rgb(rand(100,150),rand(100,150),rand(100,150))
				blood.icon			= 'enemies/_Zombie.dmi'
				blood.icon_state	= "blood[rand(1,4)]"
				blood.layer			= MOB_LAYER
				shirt.icon			= 'enemies/_Zombie.dmi'
				shirt.icon_state	= "shirt[pick(1,3)]"
				shirt.layer			= MOB_LAYER
				overlays.Add(shirt, blood)
				icon				+= bodcolor

			generate_gibs()
				if(!bodyparts) bodyparts = new()
				if(bodyparts.len) bodyparts.Cut()
				for(var/i = 1, i <= 6, i++)
					var/obj/gib = garbage.Grab(/obj/gib/feeder)
					gib.icon_state = "[i]"
					gib.icon = initial(gib.icon)
					gib.icon += bodcolor //color
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								flick("[blood.icon_state]-attack", blood)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									if(prob(35)) // chance to hop in place.
										dust()
										animate(src, pixel_z = 8, time = 3)
										animate(pixel_z = 0, time = 2, easing = BOUNCE_EASING)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi
					resting = 0
		puker
			icon			= 'enemies/_Puker.dmi'
			icon_state		= "blue"
			density			= 1
			step_size		= 3
			base_health		= 15
			can_slow		= 0
			kill_score		= 5
			spawn_rate		= 45

			generate_gibs()
				if(!bodyparts) bodyparts = new()
				if(bodyparts.len) bodyparts.Cut()
				for(var/i = 1, i <= 4, i++)
					var/obj/gib = garbage.Grab(/obj/gib/puker)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
				//	if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(prob(1))
						flick("[icon_state]-attack", src)
						var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
						f.loc					= loc
						f.step_x				= step_x-8
						f.step_y				= step_y-8
						f.spawndel(150)
						sleep 10
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
						//		target.knockback(6, step_dir)
								target.edit_health(-5)
								var/obj/hazard/puke/f 	= garbage.Grab(/obj/hazard/puke)
								f.loc					= target.loc
								f.step_x				= target.step_x-8
								f.step_y				= target.step_y-8
								f.spawndel(150)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi
					resting = 0

		crawler
			icon			= 'enemies/_Crawler.dmi'
			icon_state		= "grey"
			density			= 1
			step_size		= 4
			base_health		= 20
			kill_score		= 10
			spawn_rate		= 80

			generate_gibs()
				if(!bodyparts) bodyparts = new()
				if(bodyparts.len) bodyparts.Cut()
				for(var/i = 1, i <= 2, i++)
					var/obj/gib = garbage.Grab((icon_state == "grey" ? /obj/gib/crawlergrey : /obj/gib/crawlerwhite))
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								if(prob(get_dist(src, target)))
									for(var/i = 1 to 6)
										dust()
										step(src, step_dir, step_size+2)
										sleep world.tick_lag
								else
									step(src, step_dir)
									if(last_loc == loc)
										same_loc_steps ++
										if(same_loc_steps > 70)
											. = 1
											for(var/mob/player/p in active_game.participants)
												if(get_dist(p, src) < 15) . = 0; break
											if(.) same_loc_steps = 0; respawn()
									else
										last_loc 		= loc
										same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0

		brute
			icon			= 'enemies/_Brute.dmi'
			icon_state		= "brute"
			density			= 1
			step_size		= 3
			base_health		= 70
			can_kb			= 0
			kill_score		= 15
			spawn_rate		= 25

			generate_gibs()
				if(!bodyparts) bodyparts = new()
				if(bodyparts.len) bodyparts.Cut()
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/brute)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting)
					resting = 1
				//	if(prob(5)) k_sound(src, pick(SOUND_GROWL1, SOUND_GROWL2))
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								target.knockback(10, step_dir)	// massive knockback from brutes.
								target.edit_health(-30)
								sleep 10
							else
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1
					resting = 0
			Bump(atom/a)
				if(istype(a, /mob/npc/hostile))
					var/mob/b = a
					b.knockback(5, turn(dir, pick(-45,45)))
				..()



		beholder
			icon			= 'enemies/beholder.dmi'
			icon_state		= "beholder"
			density			= 1
			step_size		= 4
			base_health		= 20
			fireproof		= 1
			can_censor		= 0
			kill_score		= 5
			spawn_rate		= 25
			var/obj/weapon/special/skill1 = new /obj/weapon/special/fireball

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("beholder-attack", src)
								sleep 3
								target.knockback(6, step_dir)
								target.edit_health(-20)
								target.burn(src)
								sleep 10
							else if(get_dist(src, target) < 4 && skill1.can_use && shot_lineup())
								dir = get_general_dir(src, target)
								flick("beholder-attack", src)
								sleep 3
								skill1.use(src)
								sleep 3
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+1
					resting = 0


		abstract
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract1"
			density			= 1
			step_size		= 3
			base_health		= 15
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 1
			kill_score		= 10
			spawn_rate		= 55
			var/obj/weapon/special/skill1 = new /obj/weapon/special/quadbeam

			generate_gibs()
				if(!bodyparts) bodyparts = new()
				if(bodyparts.len) bodyparts.Cut()
				for(var/i = 1, i <= 3, i++)
					var/obj/gib = garbage.Grab(/obj/gib/abstract1)
					gib.icon_state = "[i]"
					bodyparts += gib

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
<<<<<<< HEAD
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							var/step_dir = get_general_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && shot_lineup())
								dir = get_dir(src, target)
								flick("abstract1-attack", src)
								sleep 3
								skill1.use(src)
								sleep 5
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0
			death()
				skill1.use(src)
				..()

		abstract2
			icon			= 'enemies/beholder.dmi'
			icon_state		= "abstract2"
			density			= 1
			step_size		= 3
			base_health		= 15
			fireproof		= 1
			can_censor		= 0
			has_spotlight	= 1
			kill_score		= 10
			spawn_rate		= 55
			var/obj/weapon/special/skill1 = new /obj/weapon/special/xbeam

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 25 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								target.knockback(6, step_dir)
								target.edit_health(-5)
								sleep 10
							else if(get_dist(src, target) < 7 && skill1.can_use && diag_lineup())
								dir = get_dir(src, target)
								flick("abstract2-attack", src)
								sleep 8
								skill1.use(src)
								sleep 5
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 15) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					else ..()
					sleep speed_modi+0.5
					resting = 0
			death()
				skill1.use(src)
				..()




<<<<<<< HEAD

=======
		doppleganger
			icon			= 'enemies/doppleganger.dmi'
			icon_state		= "dopple1-"
			density			= 1
			step_size		= 4
			base_health		= 450
			can_censor		= 0
			appearance_flags= KEEP_TOGETHER
			is_garbage		= 0
			plane			= 0
			explosion_proof	= 1
			has_spotlight	= 0
			var/obj/weapon/gun/skill1 		= new /obj/weapon/gun/pistol
			var/obj/weapon/special/skill2 	= new /obj/weapon/special/molotov
			var/obj/weapon/special/skill3	= new /obj/weapon/special/dopple
			var/tmp
				obj/arms 	= new /obj/player/arms
				obj/shirt	= new /obj/player/shirt
				obj/pants	= new /obj/player/pants
				obj/hair 	= new /obj/player/hair
				obj/vanity	= new /obj/player/vanity
			New()
				..()
				overlays += /image/spotlight

			death()
				ai_list -= src
				if(targeted)
					for(var/mob/player/p in active_game.participants)
						p.remove_target(src)
					targeted = 0
				if(ai_list.len == 0) for(var/mob/player/c in active_game.participants)
					c.client.eye = src
					spawn(35)
						c.client.eye = c
				layer = EFFECTS_LAYER+2
				var/totaloot = 0
				for(var/i = 1 to 35)
					step(src, dir)
					if(prob(25))
						gs('dopple.wav')
						spontaneous_explosion(loc, 0)
						if(totaloot < 3) totaloot++; drop_loot()
						dir = turn(dir,pick(-45,45))
					sleep world.tick_lag*1.5
				animate(src, pixel_x = -2, dir = WEST, time = 1, loop = 5, easing = ELASTIC_EASING)
				animate(pixel_x = 2, dir = EAST, time = 1, easing = ELASTIC_EASING)
				sleep 10
				gs('dying.wav')
				spontaneous_explosion(loc, 0)
				var/obj/item/gun/red_baron/h = garbage.Grab(/obj/item/gun/red_baron)
				h.loc = loc
				alpha = 0
				spawn(45)
					del src

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(prob(3)) gs('dopple.wav')
					if(target)
						if(!target.health || !target.loc)	// if the target is dead, off map, or shaking a cowbell..
							target = null		// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target))
										target = p
										if(p.client) skill3.use(src)
							if(bounds_dist(src, target) <= 2)	// if super close, melee attack.
								target.knockback(8, step_dir)
								target.edit_health(-10)
								sleep 10

							else if(get_dist(src, target) < 6 && skill1.can_use && shot_lineup())
								dir = get_general_dir(src, target)
								spawn skill1.use(src)
								sleep 2
							else if(get_dist(src, target) < 4 && skill2.can_use && shot_lineup() && prob(45))
								dir = get_general_dir(src, target)
								spawn skill2.use(src)
							else if(!kb_init)
								step(src, step_dir)
							if(health <= (base_health/2) && prob(1))
								smoke()
								smoke()
								smoke()
								animate(src, alpha = 0, time = 3, loop = 1)
								loc = pick(active_game.enemy_spawns)
								animate(src, alpha = 255, time = 3, loop = 1)

					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/p in (active_game.participants+support_ai))
							if(!p.health || !p.loc) continue
							if(!target)
								target = p
								if(p.client) skill3.use(src)
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
								if(p.client) skill3.use(src)
					sleep world.tick_lag*1.5
					resting = 0
			proc
				flick_arms(fstate = "base-")
					set waitfor = 0
					var/ogstate = arms.icon_state
					overlays -= arms
					arms.icon_state = "[fstate]"
					overlays += arms
					sleep 1
					overlays -= arms
					arms.icon_state = "[ogstate]"
					overlays += arms
>>>>>>> origin/master

		hellbat
			icon			= 'enemies/hellbat.dmi'
			icon_state		= "hellbat"
			density			= 1
			step_size		= 5
			base_health		= 10
			fireproof		= 1
			explosion_proof	= 1
			can_censor		= 0
			bound_x			= 20
			bound_y			= 20
			has_spotlight	= 0
			can_phantom		= 0
			kill_score		= 10
			spawn_rate		= 35
			var/tmp/flying	= 0

			ai_check()
				set waitfor = 0
				if(health && !resting && !kb_init)
					resting = 1
					if(!flying)
						flying		= 1
						can_hit		= 0
						density		= 0
						animate(src, pixel_y = 32, alpha = 55, transform = matrix(), time = 10, easing = ELASTIC_EASING)
						sleep 10
					if(target)
						if(!target.health || !target.loc || target.z != z)	// if the target is dead, off map,
							target = null									// .. stop targeting them.
						else
							var/step_dir = get_dir(src, target)				// just log this because.
<<<<<<< HEAD
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 4 && flying)
								sleep 5
								flying 		= 0
								can_hit		= 1
								icon_state	= "hellbat-attack"
								animate(src, pixel_y = 0, alpha = 255, transform = transform/2, time = 5, easing = BOUNCE_EASING)
								density	= 1
								for(var/i = 4, i > 0, i--)
									step(src, get_dir(src, target))
									sleep world.tick_lag
								sleep 3
								if(target in obounds(src, 4))
									target.knockback(6, step_dir)
									target.edit_health(-10)
								dust()
								dust()
								icon_state	= "hellbat"
								sleep 20
							else if(!kb_init)
								step(src, step_dir)
					else ..()
					sleep 0.8
					resting = 0

		petite_feeder
			icon			= 'enemies/_Zombie.dmi'
			icon_state		= "girl"
			density			= 1
			step_size		= 3
			base_health		= 10
			kill_score		= 5
			spawn_rate		= 18
			var/obj/shirt	= new/obj
			New()
				..()
				shirt.icon			= 'enemies/_Zombie.dmi'
				shirt.icon_state	= "girlclothes1"
				shirt.layer			= MOB_LAYER
				overlays += shirt

			ai_check()
				set waitfor = 0
				if((health > 0) && !resting && !kb_init)
					resting = 1
					if(target)
						if(!target.health || !target.loc || get_dist(src, target) > 15 || target.z != z)	// if the target is dead, off map, or more than 12 tiles away
							target = null									// .. stop targeting them.
						else
<<<<<<< HEAD
							var/step_dir = get_dir(src, target)				// just log this because.
							if(!(target.cowbell) && prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc) continue
									if(get_dist(src, p) < get_dist(src, target) || p.cowbell)
=======
							var/step_dir = step_away(src, target)				// just log this because.
							if(prob(get_dist(src, target)*2))						// here we'll see if any other potential targets are closer.
								for(var/mob/p in (active_game.participants+support_ai))	// the further the target, the more likely to check for a new one.
									if(p == target || !p.health || !p.loc || p.cowbell) continue
									if(get_dist(src, p) < get_dist(src, target))
>>>>>>> origin/master
										target = p
							if(bounds_dist(src, target) <= 2)
								flick("[icon_state]-attack", src)
								flick("[shirt.icon_state]-attack", shirt)
								target.knockback(6, step_dir)
								target.edit_health(-20)
								sleep 10
							else if(!kb_init)
								step(src, step_dir)
								if(last_loc == loc)
									same_loc_steps ++
									if(same_loc_steps > 70)
										. = 1
										for(var/mob/player/p in active_game.participants)
											if(get_dist(p, src) < 12) . = 0; break
										if(.) same_loc_steps = 0; respawn()
								else
									last_loc 		= loc
									same_loc_steps	= 0
					if(!target)
						if(prob(45)) step(src, pick(dir, turn(dir, pick(-45, 45))))
						for(var/mob/player/p in active_game.participants)
							if(!p.health || !p.loc || p.cowbell) continue
							if(!target) target = p
							else if(get_dist(src, p) < get_dist(src, target))
								target = p
					sleep world.tick_lag*1.5
					resting = 0



	proc
		shot_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					// if tiles are lined up, line up the pixel coordinates!
					if(NORTH, SOUTH)
						if(target.step_x > step_x)	// target is further right on their tile than src.
							for(var/i = 1, i < pick(2,4), i++)
								step(src, EAST, 4)
								sleep world.tick_lag
						else
							for(var/i = 1, i < pick(2,4), i++)
								step(src, WEST, 4)
								sleep world.tick_lag
						return 1
					if(EAST, WEST)
						if(target.step_y > step_y)	// target is further north on their tile than src.
							for(var/i = 1, i < pick(2,4), i++)
<<<<<<< HEAD
								step(src, NORTH, 4)
								sleep world.tick_lag
						else
							for(var/i = 1, i < pick(2,4), i++)
								step(src, SOUTH, 4)
=======
								step(src, NORTH, 8)
								sleep world.tick_lag
						else
							for(var/i = 1, i < pick(2,4), i++)
								step(src, SOUTH, 8)
>>>>>>> origin/master
								sleep world.tick_lag
						return 1
				// otherwise, line up tiles.
					if(NORTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag
					if(NORTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, NORTH)
							if(get_dir(src, target) == NORTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag
					if(SOUTHEAST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, EAST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == EAST)
								return 0
							loops --
							sleep world.tick_lag
					if(SOUTHWEST)
						var/i 		= pick(1,0)
						var/loops	= 3
						while(loops && loc && target.loc)
							if(i) 	step(src, WEST)
							else	step(src, SOUTH)
							if(get_dir(src, target) == SOUTH || get_dir(src, target) == WEST)
								return 0
							loops --
							sleep world.tick_lag
			return 0



		diag_lineup()
			if(loc && target && target.loc)
				switch(get_dir(src, target))
					if(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						return 1
					else return 0