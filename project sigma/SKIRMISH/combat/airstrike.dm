



proc
	airstrike(turf/_loc, mob/_caller)
		/*
			airstrikes send a small barrage of missiles down on/around a given location.
		*/
		if(_loc && active_game.started == 2)
			var/list/t_list = new /list()
			for(var/turf/t in view(1,_loc))
				if(!t.density) t_list += t
			if(t_list.len)
				for(var/turf/t in t_list)
					var/obj/projectile/p 	= garbage.Grab(/obj/projectile/missile)
					p.dir					= SOUTH
					p.px_range				= 80
					p.accuracy				= pick(4,7)
					p.sway					= pick(1,-1)
					p.alpha					= 0
					p.transform				= p.transform*5
					p.owner					= _caller
					var/turf/targ 			= locate(t.x, t.y+5, t.z)
					p.loc					= targ
					active_projectiles += p
					sleep pick(2,3)

	missile_strike(turf/_loc)
		/*
			sends a missile down onto a given location.
		*/
		if(_loc && active_game.started == 2)
			var/obj/projectile/p 	= garbage.Grab(/obj/projectile/missile)
			p.dir					= SOUTH
			p.px_range				= 80
			p.accuracy				= 7
			p.sway					= pick(1,-1)
			p.alpha					= 0
			p.transform				= p.transform*5
			p.loc					= _loc
			active_projectiles += p
			sleep pick(2,3)