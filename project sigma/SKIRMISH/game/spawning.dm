

proc

	spawn_pl(mob/player/p)
		/* called to spawn a player (p) to the map.
		*/
		if(!p) return
		p.health		= p.base_health
		p.client.eye	= p
		p.density		= 1
		p.move_disabled	= 1
		p.alpha			= 0
		p.pixel_z		= 64
		p.died_already	= 0
		p.loc			= return_pspawn()
		animate(p, pixel_z = 0, alpha = 255, easing = QUAD_EASING, time = 20)
		spawn(20)
			p.move_disabled 	= 0
			p.can_hit			= 1


	return_pspawn()
		/* returns an available player spawn point.
		*/
		top
		var/turf/t = pick(active_game.player_spawns)
		for(var/atom/movable/a in t)
			if(a.density)
				sleep 1
				goto top
		return t

	return_vspawn()
		/* returns an available vendor spawn point.
		*/
		top
		var/turf/t = pick(active_game.vendor_spawns)
		for(var/atom/movable/a in t)
			if(a.density)
				sleep 1
				goto top
		return t


	spawn_en(mob/npc/hostile/h)
		/* called to spawn a hostile (h) to the map.
		*/
		if(!h) return
		top
		while(!active_game.enemy_spawns) sleep 10
		var/turf/t = pick(active_game.enemy_spawns)
		for(var/atom/movable/a in t)
			if(a.density)
				sleep 10
				goto top
		. = 0
		for(var/mob/m in ohearers(15, t))
			if(istype(m, /mob/player) || istype(m, /mob/npc/support))
				if(get_dist(t, m) <= 10) 	// if there is a mob within 10 tiles of the spawn, don't spawn there.
					sleep 1
					goto top
				else 		// if there's a valid mob nearby who isn't too close, this spawn will work!
					. = 1	// we'll do this to indicate that the spawn is close enough to a player to work, \
								 but we still need to make sure no other mobs are too close so we can keep looping.
		if(.)
			if(istype(h,/mob/npc/hostile/puppet_master))
				var/mob/npc/puppet = h:puppet
				puppet.loc 		= t
				puppet.health	= h.base_health+round(active_game.current_round*5)
				puppet.can_hit	= 1
			else
				h.loc 		= t
				h.health	= h.base_health+round(active_game.current_round*5)
				h.can_hit	= 1
			ai_list += h
			sleep 5
		else goto top


mob/npc
	proc
		respawn()
			/* called to respawn the mob to a new location on the map.
			*/
			top
			var/turf/t = pick(active_game.enemy_spawns)
			for(var/atom/movable/a in t)
				if(a.density)
					sleep 1
					goto top
			. = 0
			for(var/mob/m in ohearers(25, t))
				if(istype(m, /mob/player) || istype(m, /mob/npc/support))
					if(get_dist(src, m) <= 15) 	// if there is a mob within 10 tiles of the spawn, don't spawn here.
						sleep 1
						goto top
					else 		// if there's a valid mob nearby who isn't too close, this will work!
						. = 1	// we'll do this to indicate that the spawn is close enough to a player to work, \
									 but we still need to make sure no other mobs are too close so we can keep looping.
			if(.)
				if(istype(src,/mob/npc/hostile/puppet_master))
					var/mob/npc/hostile/puppet = src:puppet
					puppet.loc 	= t
				else loc 		= t
				can_hit = 1
