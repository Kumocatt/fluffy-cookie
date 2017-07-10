
atom/movable
	proc
		drop_shell(var/shotty = 0)
			/*
				called to drop an empty shell from an arom.
				shotty = empty shotgun shell or a normal bullet casing?
			*/
			var/obj/details/shell/b		= garbage.Grab(/obj/details/shell)
			b.icon						= 'game/items.dmi'
			b.pixel_y					= 8
			b.pixel_x					= 4
			if(shotty) 	b.icon_state	= "emptyshell[rand(1,4)]"
			else		b.icon_state	= "emptybullet[rand(1,4)]"
			b.SetCenter(Cx(),Cy(),z)
			animate(b, pixel_y = 32, pixel_x = rand(-16,16), time = 3)
			animate(pixel_y = rand(-8,8), time = 3, easing = BOUNCE_EASING)
		//	sleep 3
			if(shotty) 	k_sound(src, SOUND_SHELL1)
			else		k_sound(src, SOUND_CASING1)
			b.spawndel(150)

obj/details
	icon		= 'game/items.dmi'
	layer		= TURF_LAYER+0.18
	is_garbage	= 1

	shell



proc
	get_projectile(_state = "bullet", _dir, _damage = -1, _velocity = 1.5, _penetrate = 50, _max_range = 120, _accuracy = 10, _kb_dist = 4, _sway = 1, sway_loc = 0)
		if(_dir)
			/*
				figure out the nyan/laser madness stuff here.
				if sway_loc is true, the exact sway provided will be used instead of picking between a negative or positive version of [sway].
			*/
			var/obj/projectile/p 	= garbage.Grab(/obj/projectile)
			p.icon_state			= _state
			if(active_game.laser_madness)	p.icon_state = "laser-[pick("red","blue")]"
			if(active_game.nyan_madness)	p.icon_state = "nyan"
			if(active_game.fire_madness)	p.icon_state = "firebullet"
			p.dir					= _dir
			p.hp_modifier			= _damage
			p.velocity				= _velocity
			p.penetration			= _penetrate
			p.px_range				= _max_range
			p.accuracy				= _accuracy
			p.kb_dist				= _kb_dist
			p.sway					= (sway_loc ? _sway : pick(_sway, _sway-(_sway*2)))
			return p


mob
	var/tmp
		crit_rate	= 5		// probability of getting a critical shot.


obj
	weapon
		var/tmp
			damage				= -1	// how much damage the weapon should do.
			kb_dist				= 4		// how much knockback the weapon should do.
			recharge			= 0.2	// how long it takes before you can use the weapon again.
			can_use				= 1		// whether or not you can use the weapon.
			obj/item/drop_type			// the path for the weapon's item drop, if any.
			sound/sound_effect			// sound effect. Define these in New().
			sight_range			= 10	// how many pixels ahead of the player's direction the camera should lead.
		proc/use()

		gun
			var/tmp
				max_range		= 64 	// how many PIXELS the projectile can travel before being culled.
				accuracy		= 10 	// stray 1px from center every [accuracy] pixels.
				reload_speed	= 0		// how many seconds it takes to reload.
				fire_rate		= 0		// how many shots per second. 0 for single shot.
				mag				= 0		// how many rounds are left in the current clip.
				mag_size		= 0		// how many rounds the weapon can hold at once.
				piercing		= 0		// how likely (in %) will the projectile pierce through hit target.
				crit_chance		= 0		// chance for a critical shot.
				sway			= 1		// used to determine which way projectiles should deviate towards.
				velocity		= 1.5	// used to determine how fast projectiles are.

			proc
				reload(mob/reloader)
					/* called to reload the weapon.
					*/
					if(mag < mag_size)
						if(reloader.client) reloader:reloading = 1
						if(reloader) reloader.overlays.Add(reloader.RELOAD_OVERLAY)
						for(var/i in 1 to mag_size)
							if(mag >= mag_size) break
							mag ++
							sleep reload_speed/mag_size
						if(reloader.client) reloader << SOUND_RELOAD
						if(reloader) reloader.overlays.Remove(reloader.RELOAD_OVERLAY)
						if(reloader.client) reloader:reloading = 0
	/*  pistols----------------------------------------------------------------------------------------
		*/
			pistol
				damage			= -5
				max_range		= 120
				accuracy		= 25
				reload_speed	= 6
				mag				= 11
				mag_size		= 11
				piercing		= 10
				crit_chance		= 30
				drop_type		= /obj/item/gun/pistol

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						var/obj/projectile/p = get_projectile("bullet", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
						if(m.client) m:flick_arms("base-pistol-attack")
						m.drop_shell()
						m.gs('gunshot1.wav')
						p.loc = m.loc
						p.owner	= m
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						if(prob(m.crit_rate+crit_chance))
							p.is_crit = 1
						active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 10
					can_use = 1

			kobra
				damage				= -15
				max_range			= 200
				accuracy			= 15
				reload_speed		= 12
				mag					= 6
				mag_size			= 6
				piercing			= 75
				crit_chance			= 30
				velocity			= 0.5
				drop_type			= /obj/item/gun/kobra

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						var/obj/projectile/p = get_projectile("bullet", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+4), kb_dist, sway)
						if(m.client) m:flick_arms("base-kobra-attack")
						m.drop_shell()
						m.gs('gunshot1.wav')
						p.loc = m.loc
						p.owner	= m
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						if(prob(m.crit_rate+crit_chance))
							p.is_crit = 1
						active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 10
					can_use = 1


			edge_lord
				damage				= -12
				max_range			= 300
				accuracy			= 30
				reload_speed		= 10
				mag					= 12
				mag_size			= 12
				piercing			= 34
				crit_chance			= 44
				velocity			= 0.5
				drop_type			= /obj/item/gun/edge_lord

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						var/obj/projectile/p = get_projectile("laser-red", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
						if(m.client) m:flick_arms("base-3dg3-10rd-attack")
						m.gs('laser1.wav')
						p.loc 	= m.loc
						p.owner	= m
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						if(prob(m.crit_rate+crit_chance))
							p.is_crit = 1
						active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 10
					can_use = 1

			el_verde
				damage				= -25
				max_range			= 325
				accuracy			= 68
				reload_speed		= 5
				mag					= 10
				mag_size			= 10
				piercing			= 0
				crit_chance			= 66
				velocity			= 0.2
				drop_type			= /obj/item/gun/elverde

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						var/obj/projectile/p = get_projectile("laser-green", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
						if(m.client) m:flick_arms("base-elverde-attack")
						m.gs('laser1.wav')
						p.loc 	= m.loc
						p.owner	= m
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						if(prob(m.crit_rate+crit_chance))
							p.is_crit = 1
						active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 10
					can_use = 1

			pink_dream
				damage				= -20
				max_range			= 300
				accuracy			= 25
				reload_speed		= 6
				mag					= 10
				mag_size			= 10
				piercing			= 45
				crit_chance			= 25
				velocity			= 0.5
				drop_type			= /obj/item/gun/pink_dream

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						var/obj/projectile/p = get_projectile("laser-pink", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
						if(m.client) m:flick_arms("base-pinkdream-attack")
						m.gs('laser1.wav')
						p.loc 	= m.loc
						p.owner	= m
						switch(.)
							if(NORTH)
								p.step_x	= m.step_x
								p.step_y	= m.step_y+16
							if(NORTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+16
							if(NORTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+16
							if(SOUTHEAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y-6
							if(SOUTHWEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y-6
							if(SOUTH)
								p.step_x	= m.step_x+6
								p.step_y	= m.step_y-6
							if(EAST)
								p.step_x	= m.step_x+16
								p.step_y	= m.step_y+6
							if(WEST)
								p.step_x	= m.step_x-8
								p.step_y	= m.step_y+6
						if(prob(m.crit_rate+crit_chance))
							p.is_crit = 1
						active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 10
					can_use = 1


			krossbow
				damage				= -15
				max_range			= 128
				accuracy			= 5
				reload_speed		= 3
				mag					= 1
				mag_size			= 1
				piercing			= 66
				crit_chance			= 45
				velocity			= 0.2
				drop_type			= /obj/item/gun/krossbow

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
<<<<<<< HEAD
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						if(m.hit_streak && ((m.hit_streak%3) == 0)) for(var/i = 1 to 3)
							var/obj/projectile/p = get_projectile("bolt", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
							if(m.client) m:flick_arms("base-krossbow-attack")
							m.gs('crossbow1.ogg')
							p.loc 	= m.loc
							p.owner	= m
							if(i == 1)	p.accuracy = 100
							else		p.accuracy = 8
							if(i == 2)	p.sway = 2
							if(i == 3)	p.sway = -2
							switch(.)
=======
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("bullet", ., damage, velocity, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
							if(m.client) m:flick_arms("base-uzi-attack")
							m.drop_shell()
							m.gs('gunshot2.wav')
							p.loc = m.loc
							switch(m.dir)
>>>>>>> origin/master
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							active_projectiles += p
<<<<<<< HEAD
						else
							var/obj/projectile/p = get_projectile("bolt", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
							if(m.client) m:flick_arms("base-krossbow-attack")
							m.gs('crossbow1.ogg')
							p.loc 	= m.loc
							p.owner	= m
							switch(.)
=======
							sleep 1 //10/fire_rate
						if(m.move_disabled) sleep;m.move_disabled = 0
					can_use = 1


			red_baron
				damage				= -15
				max_range			= 266
				accuracy			= 30
				recoil				= -2
				reload_speed		= 25
				fire_rate			= 60
				mag					= 45
				mag_size			= 45
				piercing			= 44
				weight				= 1.5
				crit_chance			= 55
				velocity			= 0.2
				can_strafe			= 1
				drop_type			= /obj/item/gun/red_baron

				use(mob/m)
					can_use = 0
					if(!mag)
						reload(m)
					else
						if(m.client)
							if(m.dir != m:trigger_dir)
								sleep world.tick_lag*2
								m.dir 				= m:trigger_dir
							//	m.move_disabled		= 1
						else . = m.dir
						while((m.client ? m:trigger_down : prob(60)))
							if(!mag) break
							mag --
							if(m.client) m.dir = m:trigger_dir
							else m.dir = .
							var/obj/projectile/p 	= get_projectile("bullet", m.dir, damage, velocity, max_range, rand(accuracy, accuracy+2), kb_dist, sway)
							if(m.client) m:flick_arms("base-redbaron-attack")
							m.drop_shell()
							m.gs('gunshot1.wav')
							p.loc = m.loc
							switch(m.dir)
>>>>>>> origin/master
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
						if(m.client && !m:controller_dir) sleep 2
						else sleep 5
					can_use = 1

	/*  shotguns----------------------------------------------------------------------------------------
		*/

			shotgun
				damage				= -40
				max_range			= 82
				accuracy			= 1
				reload_speed		= 6
				mag					= 2
				mag_size			= 2
				piercing			= 80
				crit_chance			= 10
				velocity			= 0.5
				drop_type			= /obj/item/gun/shotgun

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						if(m.client) m:flick_arms("base-shotgun-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
<<<<<<< HEAD
						for(var/i = 1 to 5)
							var/obj/projectile/p
							switch(i)
								if(1) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 5, kb_dist, 2, 1)
								if(2) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 15, kb_dist, 2, 1)
								if(3) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 15, kb_dist, -2, 1)
								if(4) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 5, kb_dist, -2, 1)
								if(5) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 100, kb_dist, -2, 1)
							p.loc 	= m.loc
							p.owner	= m
							switch(.)
=======
						var/_dir = m.dir
						for(var/i = 1 to 4)
							var/obj/projectile/p = get_projectile("bullet", _dir, damage, velocity, max_range, rand(accuracy,accuracy+25), kb_dist, 2)
							p.loc = m.loc
							switch(m.dir)
>>>>>>> origin/master
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
						if(m.client && !m:controller_dir) sleep 5
						else sleep 10
					can_use = 1


			hellsredeemer
				damage				= -55
				max_range			= 122
				accuracy			= 1
				reload_speed		= 12
				mag					= 3
				mag_size			= 3
				piercing			= 100
				crit_chance			= 10
				velocity			= 1.5
				drop_type			= /obj/item/gun/hellsredeemer

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						if(m.client) m:flick_arms("base-hellredeemer-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						for(var/i = 1 to 5)
							var/obj/projectile/p
							switch(i)
								if(1) p = get_projectile("firebullet", . , damage, velocity, piercing, max_range, 5, kb_dist, 2, 1)
								if(2) p = get_projectile("firebullet", . , damage, velocity, piercing, max_range, 15, kb_dist, 2, 1)
								if(3) p = get_projectile("firebullet", . , damage, velocity, piercing, max_range, 15, kb_dist, -2, 1)
								if(4) p = get_projectile("firebullet", . , damage, velocity, piercing, max_range, 5, kb_dist, -2, 1)
								if(5) p = get_projectile("firebullet", . , damage, velocity, piercing, max_range, 100, kb_dist, -2, 1)
							p.loc 	= m.loc
							p.owner	= m
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
						if(m.client && !m:controller_dir) sleep 5
						else sleep 10
					can_use = 1

			spas_12
				damage				= -30
				max_range			= 99
				accuracy			= 1
				reload_speed		= 10
				mag					= 5
				mag_size			= 5
				piercing			= 91
				crit_chance			= 10
				velocity			= 0.2
				drop_type			= /obj/item/gun/spas_12

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						if(m.client) m:flick_arms("base-spas12-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						for(var/i = 1 to 4)
							var/obj/projectile/p
							switch(i)
								if(1) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 5, kb_dist, 2, 1)
								if(2) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 15, kb_dist, 2, 1)
								if(3) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 15, kb_dist, -2, 1)
								if(4) p = get_projectile("bullet", . , damage, velocity, piercing, max_range, 5, kb_dist, -2, 1)
							p.loc 	= m.loc
							p.owner	= m
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
						if(m.client && !m:controller_dir) sleep 5
						else sleep 10
					can_use = 1

			lysergia
				reload_speed		= 16
				mag					= 4
				mag_size			= 4
				drop_type			= /obj/item/gun/lysergia

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						mag --
						. = m.dir
						if(m.client) . = m:trigger_dir
						m.dir = .
						if(m.client) m:flick_arms("base-lysergia-attack")
						m.drop_shell(1)
						m.gs('gunshot1.wav')
						for(var/i = 1 to 3)
							var/obj/projectile/p = throw_special(/obj/projectile/thrown/grenade/sticky_bomb, . )
							p.loc 	= m.loc
							p.owner	= m
							if(i == 1)	p.accuracy = 100
							else		p.accuracy = 8
							if(i == 2)	p.sway = 2
							if(i == 3)	p.sway = -2
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							active_projectiles += p
						if(m.client && !m:controller_dir) sleep 5
						else sleep 10
					can_use = 1

	/* burstfire rifles -----------------------------------------------------------------
		*/

			wicked_one
				damage				= -8
				max_range			= 200
				accuracy			= 20
				reload_speed		= 15

				mag					= 9
				mag_size			= 9
				piercing			= 60
				crit_chance			= 25
				velocity			= 0.5
				drop_type			= /obj/item/gun/wicked_one


				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						. = m.dir
						if(m.client) . = m:trigger_dir
						var/obj/projectile/p
						for(var/i = 1 to 3)
							mag --
							m.dir = .
							p = get_projectile("bullet", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+15), kb_dist, sway)
							if(m.client) m:flick_arms("base-wickedone-attack")
							m.drop_shell()
							m.gs('gunshot1.wav')
							p.loc 	= m.loc
							p.owner	= m
							if(i == 1)	p.accuracy = 100
							if(i == 2)	p.sway = 1
							if(i == 3)	p.sway = -1
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							active_projectiles += p
							sleep world.tick_lag
						sleep 3
					can_use = 1



	/*  automatic rifles ----------------------------------------------------------------------------------------
		*/

			stalker
				damage				= -30
				max_range			= 250
				accuracy			= 50
				reload_speed		= 14
				fire_rate			= 30
				mag					= 36
				mag_size			= 36
				piercing			= 22
				crit_chance			= 5
				velocity			= 0.1
				drop_type			= /obj/item/gun/stalker

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						. = m.dir
						while((m.client ? (m:controller_dir ? m:controller_dir : m:trigger_down) : prob(45)))
							if(!mag || m.client && !m:trigger_dir) break
							mag --
							if(m.client) . = m:trigger_dir
							m.dir = .
							var/obj/projectile/p = get_projectile("laserbullet", . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+10), kb_dist, sway)
							if(m.client) m:flick_arms("base-stalker-attack")
					//		m.drop_shell()
					//		m.gs('gunshot2.wav')
							p.loc = m.loc
							p.owner	= m
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							sleep 10/fire_rate
					can_use = 1

			uzi
				damage				= -10
				max_range			= 244
				accuracy			= 40
				reload_speed		= 18
				fire_rate			= 15
				mag					= 24
				mag_size			= 24
				piercing			= 77
				crit_chance			= 5
				velocity			= 0.2
				sway 				= 2
				drop_type			= /obj/item/gun/uzi

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						. = m.dir
						var/consecutive_shots = 0
						while((m.client ? (m:controller_dir ? m:controller_dir : m:trigger_down) : prob(60)))
							if(!mag || m.client && !m:trigger_dir) break
							mag --
							if(m.client) . = m:trigger_dir
							m.dir = .
							consecutive_shots ++
							var/_accur = rand(accuracy, accuracy+10)-(2*consecutive_shots)
							if(_accur <= 0) _accur = rand(4,25)
							var/obj/projectile/p = get_projectile("bullet", . , damage, velocity, piercing, max_range, _accur, kb_dist, sway)
							if(m.client) m:flick_arms("base-uzi-attack")
							m.drop_shell()
							m.gs('gunshot2.wav')
							p.loc = m.loc
							p.owner	= m
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							sleep 10/(fire_rate+(consecutive_shots*2))
					can_use = 1



			red_baron
				damage				= -15
				max_range			= 266
				accuracy			= 30
				reload_speed		= 25
				fire_rate			= 12
				mag					= 45
				mag_size			= 45
				piercing			= 44
				crit_chance			= 55
				velocity			= 1
				drop_type			= /obj/item/gun/red_baron

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						. = m.dir
						while((m.client ? (m:controller_dir ? m:controller_dir : m:trigger_down) : prob(60)))
							if(!mag || m.client && !m:trigger_dir) break
							mag --
							if(m.client) . = m:trigger_dir
							m.dir = .
							var/obj/projectile/p = get_projectile(((mag>mag_size/2)?"bullet":"firebullet"), . , damage, velocity, piercing, max_range, rand(accuracy, accuracy+2), kb_dist, sway)
							if(m.client) m:flick_arms("base-redbaron-attack")
							m.drop_shell()
							m.gs('gunshot1.wav')
							p.loc = m.loc
							p.owner	= m
							switch(.)
								if(NORTH)
									p.step_x	= m.step_x
									p.step_y	= m.step_y+16
								if(NORTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+16
								if(NORTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+16
								if(SOUTHEAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y-6
								if(SOUTHWEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y-6
								if(SOUTH)
									p.step_x	= m.step_x+6
									p.step_y	= m.step_y-6
								if(EAST)
									p.step_x	= m.step_x+16
									p.step_y	= m.step_y+6
								if(WEST)
									p.step_x	= m.step_x-8
									p.step_y	= m.step_y+6
							if(prob(m.crit_rate+crit_chance))
								p.is_crit = 1
							active_projectiles += p
							sleep 10/fire_rate
					can_use = 1


			flamethrower
				damage				= -5
				max_range			= 99
				reload_speed		= 15
				fire_rate			= 7
				mag					= 33
				mag_size			= 33
				piercing			= 68
				crit_chance			= 44
				velocity			= 2
				drop_type			= /obj/item/gun/flamethrower

				use(mob/m)
					can_use = 0
					if(!mag)
						spawn reload(m)
					else
						. = m.dir
						while((m.client ? (m:controller_dir ? m:controller_dir : m:trigger_down) : prob(80)))
							if(!mag || m.client && !m:trigger_dir) break
							mag --
							if(m.client) . = m:trigger_dir
							m.dir = .
							for(var/i = 1 to 2)
								var/obj/projectile/p
								if(i == 1) p = get_projectile("fireblast", . , damage, velocity, piercing, max_range, 20, 0, 2)
								if(i == 2) p = get_projectile("fireblast", . , damage, velocity, piercing, max_range, 20, 0, -2)
								p.loc = m.loc
								p.owner	= m
								switch(.)
									if(NORTH)
										p.step_x	= m.step_x
										p.step_y	= m.step_y+16
									if(NORTHEAST)
										p.step_x	= m.step_x+16
										p.step_y	= m.step_y+16
									if(NORTHWEST)
										p.step_x	= m.step_x-8
										p.step_y	= m.step_y+16
									if(SOUTHEAST)
										p.step_x	= m.step_x+16
										p.step_y	= m.step_y-6
									if(SOUTHWEST)
										p.step_x	= m.step_x-8
										p.step_y	= m.step_y-6
									if(SOUTH)
										p.step_x	= m.step_x+6
										p.step_y	= m.step_y-6
									if(EAST)
										p.step_x	= m.step_x+16
										p.step_y	= m.step_y+6
									if(WEST)
										p.step_x	= m.step_x-8
										p.step_y	= m.step_y+6
								p.owner = m
								if(prob(m.crit_rate+crit_chance))
									p.is_crit = 1
								active_projectiles += p
								sleep 1
							sleep 10/fire_rate
					can_use = 1