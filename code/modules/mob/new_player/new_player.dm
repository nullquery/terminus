/mob/new_player
	var
		tmp
			step = 1
			fake_password

			//1-on-1 copy
			datum/appearance_style/skin
			datum/appearance_style/hair
			datum/appearance_style/facial
			datum/appearance_style/underwear
			hair_color = rgb(0, 0, 0)
			facial_color = rgb(0, 0, 0)
	Login()
		if (client)
			spawn (10)
				var/sound/S = sound('sounds/music/awakening.ogg', repeat = 1, channel = BG_MUSIC_CHANNEL)
				S.status = SOUND_STREAM
				src << S

			client.hud.Hide()
			winset(src, null, list2params(list(
				"default.child.left" = "/mob/new_player",
				"default.size" = "920x640",
				"default.can-resize" = "false",
				"default.is-maximized" = "false"
			)))

			src << browse_rsc('interface/jquery-1.11.0.min.js', "jquery-1.11.0.min.js")
			src << browse_rsc('interface/style.css', "style.css")
			src << browse_rsc('interface/new_player.css', "new_player.css")
			src << browse_rsc('interface/new_player.js', "new_player.js")

			src.fake_password = pick("12345", "password", "16431879196842", "kittenrainbowmagic", "trustn01", "happpy", "letmein", "whatever", "hunnyismi", "mmmkkk", "swordfish", "opensesame", "Joshua", "flibbertigibbet", "peekaboo", "midnightsun")

			spawn (25) Init()

		return

	Logout()
		del src

	proc
		Init()
			var/firstMessage
			firstMessage = {"
  REGISTRATION REQUIRED
-------------------------

You must complete your profile to proceed.

Please validate that the following account credentials are correct:

	USERNAME  :  [src.ckey]
	PASSWORD  :  [src.fake_password]

If these are correct please type "yes"."}

			src << output({"<!DOCTYPE html>
							<html lang="en">
								<head>
									<meta http-equiv="X-UA-Compatible" content="IE=9" />
									<link rel="stylesheet" type="text/css" href="style.css" />
									<link rel="stylesheet" type="text/css" href="new_player.css" />
								</head>
								<body>
									<div id="logo">
										<span>TERMINUS</span>
									</div>
									<div id="output"></div>
									<input type="text" name="input" value="" id="input" />

									<script type="text/javascript">var hsrc = "\ref[src]";</script>
									<script type="text/javascript" src="jquery-1.11.0.min.js"></script>
									<script type="text/javascript" src="new_player.js"></script>
									<script type="text/javascript">
										$(function(){ output('[replaceText(firstMessage, "\n", "\\n")]', '', 40); });
									</script>
								</body>
							</html>"}, "/mob/new_player.browser")
		Output(text, html = "", delay = 20, special = 0)
			src << output(list2params(list("[text]", "[html]", "[delay]", "[special]")), "/mob/new_player.browser:output")
		ClearOutput() src << output(list2params(list()), "/mob/new_player.browser:clearOutput")

		GetAppearance()
			var/datum/appearance/app = new/datum/appearance(src.gender, src.skin)

			app.SetHairStyle(src.hair)
			app.SetFacialHairStyle(src.facial)
			app.SetUnderwearStyle(src.underwear)
			app.SetHairColor(src.hair_color)
			app.SetFacialHairColor(src.facial_color)

			return app

		SendAvatar(update = 1)
			if (src.skin)
				var/datum/appearance/app = GetAppearance()

				src << browse_rsc(app.Generate(direction = SOUTH), "avatar1.png")
				src << browse_rsc(app.Generate(direction = EAST), "avatar2.png")
				src << browse_rsc(app.Generate(direction = NORTH), "avatar3.png")
				src << browse_rsc(app.Generate(direction = WEST), "avatar4.png")
			else
				src << browse_rsc(icon(icon = 'icons/mob/human.dmi', icon_state = ""), "avatar1.png")
				src << browse_rsc(icon(icon = 'icons/mob/human.dmi', icon_state = ""), "avatar2.png")
				src << browse_rsc(icon(icon = 'icons/mob/human.dmi', icon_state = ""), "avatar3.png")
				src << browse_rsc(icon(icon = 'icons/mob/human.dmi', icon_state = ""), "avatar4.png")

			if (update)
				src << output(list2params(list()), "/mob/new_player.browser:updateAvatar")

		GotoStep(step)
			if (step == 2)
				src.ClearOutput()
				src.Output({"
  STEP 1 - BASIC DETAILS
--------------------------

Please provide your name.
This must be your full name (first name + last name)."})
				src.step = 2
			else if (step == 5)
				src.skin = null
				src.SendAvatar(update = 0)

				var/list
					available_skins = new/list()
					available_hair = new/list()
					available_facial = new/list()
					available_underwear = new/list()

				for (var/datum/appearance_style/style in appearance_globals.skins) if (style.gender == NEUTER || style.gender == src.gender) available_skins.Add(style)
				for (var/datum/appearance_style/style in appearance_globals.hair_styles) if (style.gender == NEUTER || style.gender == src.gender) available_hair.Add(style)
				for (var/datum/appearance_style/style in appearance_globals.facial_styles) if (style.gender == NEUTER || style.gender == src.gender) available_facial.Add(style)
				for (var/datum/appearance_style/style in appearance_globals.underwear_styles) if (style.gender == NEUTER || style.gender == src.gender) available_underwear.Add(style)

				var
					skinHtml = ""
					skinText = ""
					hairStylesHtml = ""
					hairStylesText = ""
					facialStylesHtml = ""
					facialStylesText = ""
					underwearStylesHtml = ""
					underwearStylesText = ""

				for (var/datum/appearance_style/style in available_skins)
					if (skinHtml != "") skinHtml = skinHtml + ", "
					if (skinText != "") skinText = skinText + ", "

					skinText = skinText + "[style.name]"
					skinHtml = skinHtml + "<a href=\"byond://?src=\ref[src]&action=skin&style=\ref[style]\">[style.name]</a>"

				for (var/datum/appearance_style/style in available_hair)
					if (style.icon_state == null) src.hair = style

					if (hairStylesHtml != "") hairStylesHtml = hairStylesHtml + ", "
					if (hairStylesText != "") hairStylesText = hairStylesText + ", "

					hairStylesText = hairStylesText + "[style.name]"
					hairStylesHtml = hairStylesHtml + "<a href=\"byond://?src=\ref[src]&action=hair&style=\ref[style]\">[style.name]</a>"

				for (var/datum/appearance_style/style in available_facial)
					if (style.icon_state == null) src.facial = style

					if (facialStylesHtml != "") facialStylesHtml = facialStylesHtml + ", "
					if (facialStylesText != "") facialStylesText = facialStylesText + ", "

					facialStylesText = facialStylesText + "[style.name]"
					facialStylesHtml = facialStylesHtml + "<a href=\"byond://?src=\ref[src]&action=facial&style=\ref[style]\">[style.name]</a>"

				for (var/datum/appearance_style/style in available_underwear)
					if (style.icon_state == "male_white" || style.icon_state == "female_white") src.underwear = style

					if (underwearStylesHtml != "") underwearStylesHtml = underwearStylesHtml + ", "
					if (underwearStylesText != "") underwearStylesText = underwearStylesText + ", "

					underwearStylesText = underwearStylesText + "[style.name]"
					underwearStylesHtml = underwearStylesHtml + "<a href=\"byond://?src=\ref[src]&action=underwear&style=\ref[style]\">[style.name]</a>"

				var
					facialText
					facialHtml

				if (available_facial.len > 1)
					facialText = {"Available facial hair styles: [facialStylesText]"}
					facialHtml = {"<br />
Available facial hair styles: [facialStylesHtml]<br />"}
				else if (available_facial.len == 1)
					src.facial = available_facial[1]

				src.ClearOutput()

				src.Output("", {"<br />
<center>STEP 2 - APPEARANCE<br /></center><br />
<div style="position: absolute; overflow: hidden; width: 100%; height: 24px; left: 0px; box-sizing: border-box;">-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</div>"})

				src.Output({"
				---------		---------		---------		---------
				|       |		|       |		|       |		|       |
				|       |		|       |		|       |		|       |
				|       |		|       |		|       |		|       |
				---------		---------		---------		---------

Available skin colors: [skinText]

Available hair styles: [hairStylesText]

[facialText]

Available underwear options: [underwearStylesText]"}, html = {"<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;---------<br />
<br />
Available skin colors: [skinHtml]<br />
<br />
Available hair styles: [hairStylesHtml]<br />
[facialHtml]
<br />
Available underwear options: [underwearStylesHtml]<br />
<center><a href=\"byond://?src=\ref[src]&action=done\">\[done\]</a></center>"}, delay = 10, special = 2)
				src.step = 5
			else if (step == 6)
				src.ClearOutput()
				src.Output({"
  STEP 3 - RULES
------------------

By joining you agree to the following rules:

	1. 	It is expected that you are 18 years or older before playing on this server.
	   	While younger players are accepted both your actions on the server and the
	   	response from others is entirely at your own risk and not the responsibility
	   	of the server manager(s) and/or its staff.

	2. 	This is a role-playing game, and the common rules apply: refrain from metagaming,
	   	try to remain in-character as much as possible, and try have fun pretending.

	3. 	Being a jerk in-character is okay to a certain extent, but being a jerk while
	   	out-of-character is not okay. Be sure to make that distinction, and try not to
	   	let the in-character actions of others sway you from taking it out-of-character.

	4. 	This game is a work in progress which means that there will probably be bugs.
	   	The expectation is that you report these problems as they arise and that you will
	   	not (try to) abuse them.

The rules listed above may be changed at any time. You are expected to respect the latest
version of the rules.

If you agree with the conditions listed above please type \"yes\" to continue.

Note: If you have disabled sound playback this is the perfect time to enable it."})
				src.step = 6

		IsAffirmative(text)
			return (text == "yes" || text == "y" || text == "ye" || text == "ya" || text == "aye")

	Topic(href, href_list[])
		if (usr == src)
			if (href_list["reset"])
				src.Init()
			else
				var/text = href_list["input"]

				switch (step)
					if (1)
						if (IsAffirmative(text))
							GotoStep(2)
						else
							src.ClearOutput()
							src.Output({"
UNAUTHORIZED ACCESS DETECTED
----------------------------

The remote connection has been dropped."}, delay = 40, special = 1)

					if (2)
						if (html_encode(text) == text)
							src.Output({"
> [text]

Please choose your gender from the list below.
Available options: male, female"})
							src.step    = 3
							src.r_name  = "[TextOperations.ProperCase(text)]"

					if (3)
						var/ok          = 0

						if (text == "male" || text == "m" || text == "guy" || text == "man" || copytext(text, 1, 12) == "SAXTON HALE")
							src.gender  = MALE
							ok          = 1
						else if (text == "female" || text == "f" || text == "gal" || text == "woman" || text == "wench") // totally not sexist
							src.gender  = FEMALE
							ok          = 1

						if (ok)
							var/message = "If the above details are correct, please type \"yes\"."

							if (TextOperations.IndexOf(src.r_name, " ") <= 0)
								message = "An invalid name was provided. You must go back and type a first and last name before you may proceed. Type anything to continue."

							src.Output({"
> [text]

Please confirm that the following details are correct:

	Name:      [src.r_name]
	Gender:    [src.gender == FEMALE ? "female" : "male"]

[message]"})
							src.step     = 4

					if (4)
						if (IsAffirmative(text) && TextOperations.IndexOf(src.r_name, " ") > 0)
							GotoStep(5)
						else
							GotoStep(2)

					if (5)
						switch (href_list["action"])
							if ("skin") src.skin           = locate(href_list["style"])
							if ("hair")
								src.hair                   = locate(href_list["style"])

								if (src.hair.icon_state)
									var/color = input(usr, "Pick the hair color you would like to have or cancel this prompt to use the existing color.") as null|color

									if (color != null)     src.hair_color = color
								else
									src.hair_color         = rgb(0, 0, 0)

							if ("facial")
								src.facial                 = locate(href_list["style"])

								if (src.facial.icon_state)
									var/color = input(usr, "Pick the facial hair color you would like to have or cancel this prompt to use the existing color.") as null|color

									if (color != null)      src.facial_color = color
								else
									src.facial_color       = rgb(0, 0, 0)

							if ("underwear") src.underwear = locate(href_list["style"])
							if ("done")
								if (src.skin && src.hair && src.facial && src.underwear)
									GotoStep(6)

						src.SendAvatar()

					if (6)
						if (IsAffirmative(text))
							var/mob/living/carbon/human/mob = new

							mob.r_name                      = src.r_name
							mob.skin                        = src.skin
							mob.hair                        = src.hair
							mob.facial                      = src.facial
							mob.underwear                   = src.underwear
							mob.hair_color                  = src.hair_color
							mob.facial_color                = src.facial_color
							mob.saving                      = "yes" // save the mob on logout

							var/item/clothing/uniform/blue_pyjamas/uniform = new(mob)
							mob.uniform                     = uniform

							var/item/clothing/shoes/tourist/shoes = new(mob)
							mob.shoes                       = shoes

							mob.resting                     = 1

							if (client)
								// Intro
								winset(src, null, list2params(list(
									"default.child.left"    = "default/main",
									"default.can-resize"    = "true",
									"default.is-maximized"  = "true"
								)))

								src.invisibility            = 100
								src.sight                   = SEE_SELF

								var/datum/appearance/app    = GetAppearance()
								src.icon                    = app.GetIcon()
								src.icon_state              = app.GetIconState()

								for (var/image/I in app.GetOverlays())
									src.overlays.Add(I)

								src.loc                     = locate(8, 8, 2)

								src << sound(null, volume = 50)
								src << sound('sounds/misc/intro.ogg', channel = 8)

								spawn (340)                 src.loc = null

								spawn(530)
									// Disconnect from the current object so this proc will continue running
									// even if the mob is deleted.
									var/client/C            = src.client
									src                     = null

									if (C)
										C.mob               = mob

										mob.show_message("You're still a little loopy from the drugs that you were injected with prior to being sent down that chute, and your past is a mystery to you. All you can remember is your name: [mob.r_name].")

										spawn (100)
											mob.resting     = 0
											mob.UpdateIcon()