

mob
	player
		verb
			interact()
				set hidden = 1
				/*
					press e to interact with nearby things in the world.
				*/
				for(var/atom/movable/a in obounds(src, 1))
					if((istype(a, /mob/npc/support/gun_vendor) || istype(a, /mob/npc/support/face_vendor) || istype(a, /mob/npc/support/hair_vendor) || istype(a, /mob/npc/support/special_vendor) || istype(a, /mob/npc/support/vanity_vendor) || istype(a, /mob/npc/support/shirt_vendor)) && get_dir(src, a) == dir)
						a:move_disabled = 1
						a.dir = get_dir(a, src)
						MakeVendor(a:vendor_type)
						sleep 20
						a:move_disabled = 0
						break

					if(istype(a, /obj/_path))
						PathTo(a:path_to)	// teleport to the path point's destination!
						break

					if((istype(a, /obj/item/gun) || istype(a, /obj/item/melee)) && a:gun_type != equipped_weapon.type)
				//		world << "[src] got the [a]."
						var/obj/item/DROP		= garbage.Grab(equipped_weapon.drop_type)
						DROP.loc				= loc
						DROP.step_x				= step_x
						DROP.step_y				= step_y
						equipped_weapon 		= new a:gun_type
						arms_state("base-[a:state]")
						step_size				= a:step
						a.GC()
						break

					if(istype(a, /obj/item/special) && a:gun_type != equipped_special.type)
				//		world << "[src] got the [a]."
						var/obj/item/special/DROP	= garbage.Grab(equipped_special.drop_type)
						DROP.loc					= loc
						DROP.step_x					= step_x
						DROP.step_y					= step_y
						equipped_special 			= new a:gun_type
						a.GC()
						break

				//	if(istype(a, /obj/barricade))
						// pull that bitch.