/var/CO/CO = new/CO();

/CO
{
	var/list/last_action_hero

	proc/LastActionHero(object, proc_name, timeout = 0, atomic = TRUE, ...)
	{
		if (!last_action_hero)					{ last_action_hero = new/list() }

		var/key									= "\ref[object]_[proc_name]";

		if (!(key in last_action_hero))
		{
			last_action_hero.Add(key);

			var/list/arguments;

			if (args.len > 4)					{ arguments = args.Copy(5); }
			else								{ arguments = list(); }

			if (timeout != 0)					{ sleep (timeout); }

			if (!atomic)						{ last_action_hero.Remove(key); }

			call(object, proc_name)(arglist(arguments));

			if (atomic)							{ last_action_hero.Remove(key); }

			if (!last_action_hero.len)			{ last_action_hero = null; }
		}
	}

	proc/getRSV(query, ...)
	{
		try
		{
			var/pgsql4dm/ResultSet/rs			= database_connection.query(arglist(args));

			if (rs.next())						{ return rs.getString(1); }
			else								{ return ""; }
		}
		catch ()								{ return ""; }
	}
}