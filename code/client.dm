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

/client/proc/SendChatMessage(name, type, message)
{
	src << output(list("[name]", "[type]", "[message]"), "main_output");
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
