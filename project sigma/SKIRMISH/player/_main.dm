

client
//	fps				= 100 		/// 60 or remove if 100 doesn't work out
	perspective		= (EYE_PERSPECTIVE | EDGE_PERSPECTIVE)
//	control_freak 	= (CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS)
atom/appearance_flags = PIXEL_SCALE


mob
	var/tmp
		kills 		= 0
		connected	= 0
		C_ID		= 0

	player
		var/tmp
<<<<<<< HEAD
			died_already = 1
=======
			died_already = 0
>>>>>>> origin/master

		proc/CharacterLoaded()
			loc = locate(1,1,1)
			draw_base()
			MovementLoop()
			weapon_loop()
			sleep 10
			active_game.participants += src
<<<<<<< HEAD
			src << output("<center><u>## Welcome to Feed ##</u></center>","lobbychat")
			src << output("<center><b><u>Controls</u><br>W,A,S,D to move.<br>Arrow keys to shoot.<br>Shift to dash.<br>Space+Arrow keys to use specials.<br>E to pickup weapons/spectate new.<br>F to cast a portal<br>F1 to fullscreen.</b><hr>","lobbychat")
=======
			src << output("<center><u>## Welcome to Feed! ##</u></center>","lobbychat")
			src << output("<center><b><u>Controls</u><br>W,A,S,D to move.<br>Arrow keys to shoot.<br>Shift to dash.<br>Space+Arrow keys to use specials.<br>E to pickup weapons/spectate new.</b><hr>","lobbychat")
>>>>>>> origin/master
			if(active_game.started == 2) // if game is already going on..
				/*	Players shouldn't get dumped into an active game.
					They should spectate and be able to opt into the game at will OR spectate until the start of the next wave.
				*/
				winset(src,,"child1.left=\"pane-map\"")
				winset(src,"default","macro=\"play\"")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				spawn_pl(src)
				for(var/mob/player/p in active_game.participants)
					p.update_pl_targets()	///////////////////////////////////////////////////////////////////////////////////
					sleep world.tick_lag

			if(active_game.started == 1)
				winset(src,,"child1.left=\"pane-lobby\"")
				winset(src,"default","macro=\"lobby\"")
				winset(src,,"pane-lobby.next-map.text=\"[active_game.next_map.name]\"")
				winset(src, "pane-lobby.to-skip", "text=0/[active_game.participants.len>1?round(active_game.participants.len/2.5):1]")
				winset(src, "pane-lobby.skip-button", "is-checked=\"false\"")
				winset(src, "pane-lobby.specbutton", "is-checked=\"false\"")
				active_game.participants << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				active_game.spectators << output("<b>++ <font color = [namecolor]>[src]</font> connected.</b>","lobbychat")
				world << "<b>++ <font color = [namecolor]>[src]</font> connected.</b>"
				active_game.update_grid()

		Login()
			..()
			winset(src,null,"hwmode=true;")	// make sure the game starts in hardware mode
			winset(src,"default","macro=\"textinput\"") // start off all clients on the textinput macro
			C_ID = client.computer_id
			if(key == "Kumorii" || key == "Unwanted4Murder")
				verbs += typesof(/mob/player/gm/verb)
				is_GM = 1		 // if the key or comp_id of a client is in the staff list, make them GM.
			players 		+= src
			client.screen 	+= scanlines
			src << MUSIC_SPOOBOOKY
			load_save()


		Logout()
<<<<<<< HEAD
			players -= src
			if(connected)
				save_account()
				remove_spectators()
=======
			if(!active_game.participants.len && !active_game.spectators.len)
				world.Reboot()
			if(connected)
				remove_spectators()
				..()
>>>>>>> origin/master
				world << "<b>-- <font color = [namecolor]>[src]</font> disconnected."
				active_game.participants << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
				active_game.spectators << output("<b>-- <font color = [namecolor]>[src]</font> disconnected.","lobbychat")
				if(src in active_game.spectators)
					active_game.spectators -= src
				if(src in active_game.participants)
					active_game.participants -= src
					if(active_game.started == 2) spawn active_game.progress_check()
				active_game.update_grid()
<<<<<<< HEAD
			if(!players.len) world.Reboot()
=======
				if(!active_game.participants.len && !active_game.spectators.len)
					world.Reboot()
>>>>>>> origin/master
			del src


		death()
			if(client.eye != src || died_already) return
			died_already 	= 1
			if(targeted)
				for(var/mob/player/p in active_game.participants)
					p.remove_target(src)
				targeted = 0
			..()
			if(prob(5)) gs('wilhelm_scream.ogg')
			remove_spectators()
			if(censored)	censor(1)
			client.eye		= loc
			loc				= locate(1,1,1)
			move_disabled 	= 1
			alpha			= 0
			world << "<b><font color = [namecolor]>[src]</font> died! ([kills] kills)"
			active_game.participants << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.spectators << output("<b><font color = [namecolor]>[src]</font> died! ([kills] kills)","lobbychat")
			active_game.progress_check()
			spawn(10) if(active_game.started == 2)	// if the game is still active after the player dies..
				spectate_rand()
				auto_revive(active_game.current_round)	// if the game is still on after the player dies, auto revive them a minute after dying(if the game is still on)
