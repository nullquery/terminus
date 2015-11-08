var/const
	HUD_BACKGROUND_LAYER                                      = 80
	HUD_FOREGROUND_LAYER                                      = 81

/screen
	icon                                                      = 'icons/mob/screen_midnight.dmi'
	parent_type                                               = /obj
	layer                                                     = HUD_BACKGROUND_LAYER
	var
		datum/hud/hud
		always_visible                                        = 1

	New(datum/hud/hud)
		src.hud                                               = hud

	canAttack(mob/user)                                       return user.client == hud.client

	inventory
		always_visible                                        = 0
		var/slot

		attack_hand(mob/user, params)
			if (user.vars[slot])
				var/item/item                                 = user.vars[slot]
				var/item/eqp_item                             = user.GetItemInHand()

				if (eqp_item)                                 item.attack_by(eqp_item, user, params)
				else                                          item.MoveToSlot(user.hand ? "l_hand" : "r_hand")

		attack_by(item/item, mob/user, params)
			if (user.vars[slot])                              attack_hand(user, params)
			else                                              item.MoveToSlot(src.slot)

		suit
			icon_state                                        = "suit"
			screen_loc                                        = "1,3"
			slot                                              = "suit"

		glasses
			icon_state                                        = "glasses"
			screen_loc                                        = "3,4"
			slot                                              = "glasses"

		uniform
			icon_state                                        = "uniform"
			screen_loc                                        = "2,3"
			slot                                              = "uniform"

		shoes
			icon_state                                        = "shoes"
			screen_loc                                        = "2,2"
			slot                                              = "shoes"

		l_hand
			icon_state                                        = "hand_l_inactive"
			screen_loc                                        = "13,1"
			slot                                              = "l_hand"
			always_visible                                    = 1

		r_hand
			icon_state                                        = "hand_r_inactive"
			screen_loc                                        = "14,1"
			slot                                              = "r_hand"
			always_visible                                    = 1

		pocket1
			icon_state                                        = "pocket"
			screen_loc                                        = "2,1"
			slot                                              = "pocket1"
			always_visible                                    = 1

		pocket2
			icon_state                                        = "pocket"
			screen_loc                                        = "3,1"
			slot                                              = "pocket2"
			always_visible                                    = 1

		pocket3
			icon_state                                        = "pocket"
			screen_loc                                        = "4,1"
			slot                                              = "pocket3"
			always_visible                                    = 1

	buttons
		attack_by(item/item, mob/user, params)                attack_hand(user, params)

		drop
			icon_state                                        = "act_drop"
			screen_loc                                        = "15,1"

			attack_hand(mob/user, params)
				var/item/I                                    = user.GetItemInHand()

				if (I)                                        I.Drop()

		swap
			attack_hand(mob/user)
				user.hand                                     = !user.hand

				hud.Update()

			s1
				icon_state                                    = "swap_1_m"
				screen_loc                                    = "13,2"
			s2
				icon_state                                    = "swap_2"
				screen_loc                                    = "14,2"

		toggle
			icon_state                                        = "toggle"
			screen_loc                                        = "1,1"

			attack_hand(mob/user)                             hud.ToggleVisibility()

/datum/hud
	var
		client/client
		screen
			inventory
				uniform/uniform
				shoes/shoes
				l_hand/l_hand
				r_hand/r_hand
				pocket1/pocket1
				pocket2/pocket2
				pocket3/pocket3
				suit/suit
				glasses/glasses
			buttons
				drop/drop
				swap
					s1/swap_1
					s2/swap_2
				toggle/toggle
		visible = 0
	New(client/client)
		src.client                                            = client

		src.uniform                                           = new(src)
		src.shoes                                             = new(src)
		src.l_hand                                            = new(src)
		src.r_hand                                            = new(src)
		src.drop                                              = new(src)
		src.swap_1                                            = new(src)
		src.swap_2                                            = new(src)
		src.pocket1                                           = new(src)
		src.pocket2                                           = new(src)
		src.pocket3                                           = new(src)
		src.suit                                              = new(src)
		src.glasses                                           = new(src)
		src.toggle                                            = new(src)

	proc
		GetInventoryScreenObjects()
			var/list/L                                        = new/list()

			for (var/variable in client.mob.GetInventoryVariables())
				L.Add(src.vars[variable])

			return L

		ToggleVisibility()
			if (visible == 1)                                  visible = 2
			else if (visible == 2)                             visible = 1

			src.UpdateScreen()

		UpdateScreen()
			client.screen.Remove(GetInventoryScreenObjects())
			client.screen.Remove(list(drop, swap_1, swap_2, toggle))

			if (visible)
				client.screen.Add(list(drop, swap_1, swap_2, toggle))

				for (var/screen/inventory/obj in GetInventoryScreenObjects())
					if (obj.always_visible || visible == 2)
						client.screen.Add(obj)

			src.Update()

		Show()
			if (!visible)
				visible                                       = 1

				src.UpdateScreen()

		Hide()
			if (visible)
				visible                                       = 0

			client.screen                                     = list()

			src.Update()

		Update()
			if (client.mob)
				if (client.mob.hand)
					l_hand.icon_state                         = "hand_l_active"
					r_hand.icon_state                         = "hand_r_inactive"
				else
					l_hand.icon_state                         = "hand_l_inactive"
					r_hand.icon_state                         = "hand_r_active"

				for (var/item/I in client.screen)             client.screen.Remove(I)

				// This variable is tmp so it will reset upon a reconnection.
				for (var/item/I in client.mob)                I.mouse_opacity = 0

				if (visible)
					var
						item/item
						screen/inventory/si

					for (var/variable in client.mob.GetInventoryVariables())
						if (client.mob.vars[variable])
							item                               = client.mob.vars[variable]
							si                                 = src.vars[variable]

							if (visible == 2 || si.always_visible)
								item.screen_loc                = si.screen_loc
								client.screen.Add(item)