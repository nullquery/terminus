/client
{
	control_freak = CONTROL_FREAK_SKIN;
}

/client/New()
{
	. = ..();
}

/client/Del()
{
	return ..();
}

/client/proc/SetEye(location)
{
	if (isturf(location))
	{
		src.perspective			= EYE_PERSPECTIVE;
		src.eye					= location;
	}
	else
	{
		src.eye					= src.mob;
		src.perspective			= MOB_PERSPECTIVE;
	}
}

/client/Topic(href, href_list[], hsrc)
{
	world.log << href
	if (hsrc)					{ return ..() }
	else
	{
		switch (href_list["class"])
		{
			if ("playerinfo")
			{
				var/id			= href_list["control"];

				switch (href_list["action"])
				{
					if("update")
					{
						if (mob){ src << output(list("[mob.r_name]", mob.GetIcon(SOUTH, 64)), id); }
					}
				}
			}
			else
			{
				// Global functions.

				switch (href_list["action"])
				{
					if ("feedback")
					{
						var/title		= href_list["title"];
						var/type		= href_list["type"];
						var/system_os	= href_list["system_os"];
						var/browser		= href_list["browser"];
						var/message		= href_list["message"];

						try
						{
							database_connection.exec("INSERT INTO feedback (type, author, title, system_os, browser, message, created, updated) VALUES($1, $2, $3, $4, $5, $6, NOW(), NOW())", "[type]", "[src.key]", " [title]", "[system_os]", "[browser]", "[message]");
						}
						catch (var/exception/ex)
						{
							LogException(ex);
						}
					}
				}
			}
		}
		if (href == "test")
		{
			world.log << "Cool."
		}

		if (href == "get_player_info")
		{
			mob << output(list("[mob.r_name]"), "playerinfo");
		}

		if (href == "Logout")
		{
			mob.Logout();
		}
	}
}

/client/proc/SendChatMessage(name, type, message)
{
	src << output(list("[name]", "[type]", "[message]"), "main_output");
}
/client/proc/WhoseOnline(name)
{
	src << output(list("[name]"), "players_online");
}

/*
/client/verb/switch_view()
{
	set category				= "Debug";

	if (src.eye == src.mob)
	{
		src.eye					= src.mob.loc;
		src.perspective			= EYE_PERSPECTIVE;
	}
	else
	{
		src.eye					= src.mob;
		src.perspective			= MOB_PERSPECTIVE;
	}
}

/client/Move(new_loc, new_dir)
{
	if (src.eye == src.mob)
	{
		return ..();
	}
	else
	{
		src.eye = get_step(src.eye, new_dir) || src.eye;
	}
}
*/
