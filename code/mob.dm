/mob
{
	var
		r_name;
		resting											= FALSE;

	proc
		UpdateIcon()									{ /* empty */ }
		UpdateClothing()								{ /* empty */ }
		GetIcon(dir, size)								{ /* empty */ }

	Login()
	{
		src.r_name = src.key

		spawn(10)src << output(list("[src.r_name]"), "playerinfo");

		if (src.chunk)									{ src.chunk.Login(src); }

		spawn(30)
			world.log << "src.chunk = [src.chunk] - [src.chunk.used_by]"

/*
		spawn (10)
			while (TRUE)
				sleep(1)
				say("Can't... stop... talking...! Your lucky number is [rand(1,100)].")
*/

		return ..()
	}

	Logout()
	{
		if (src.chunk)									{ src.chunk.Logout(src); }

		return ..()
	}

	Move(turf/new_loc, new_dir)
	{
		. = ..();

		if (src.client && src.client.eye == src && chunk.HasState(chunk.STATE_LOADING))
		{
			map.ShowMapLoader(src.client);

			while (chunk.HasState(chunk.STATE_LOADING))	{ sleep(1); }

			map.HideMapLoader(src.client);
		}
	}

	Stat()
	{
		if (statpanel("Info"))
		{
			stat("Location", "[src.x],[src.y],[src.z]")
		}
	}

	verb/create()
		var/datum/map_screens/ms = new/datum/map_screens/map_loader()
		ms.Populate(2, 2, 1)
}

/mob/verb/say(t as text)
{
	for (var/mob/mob in view(src))
	{
		if (mob.client)
		{
			mob.client.SendChatMessage(src.name, "says", t);
		}
	}
}

var/list/times = new/list()

/mob/verb/database_test()
{
	var/pgsql4dm/Connection/conn = new("postgresql://terminus_dev:ruzecrU4@h.nullquery.net:5432/terminus_dev");

	var/pgsql4dm/ResultSet/rs = conn.query("SELECT 123");

	if (rs.next())
	{
		world.log << "123 = [rs.getNumber(1)]"
	}
}

/mob/verb/Init()
{
	set instant = 1;
	/*
	if (world.port == 0)
	{
		world.log << "Opening port 8000"
		world.OpenPort(8000);
	}
	*/

	. = TerminusLibrary.Call("initialize")
	if (. in times)
		world.log << "ERROR CONDITION"
	times.Add(.)
	world.log << "output: [.]"
}
var/xxx = 0

/mob/verb/Test(var/x as text)
{
//	world.log << "Start"
	for (var/i = 1 to 1)
	{
		TerminusLibrary.Call("allocateComputer", "[x][i]")
	}
/*
	world.log << "Mid"

	for (var/i = 1 to 5000)
	{
		TerminusLibrary.Call("evaluate", "[x][i]", file2text("test.js"))
	}

	world.log << "End"
*/
}

/mob/verb/Test2(var/n as text)
{
	set instant = 1;
	world.log << "Trying to execute: [file2text("test.js")]"
	world.log << "output: [TerminusLibrary.Call("evaluate", n, file2text("test.js"))]"
}

var/init = 0

mob/verb/progo()
	if (!init)
		init = 1
		Init()
		Test("test")

mob/verb/go()
	if (!init)
		init = 1
		Init()
		Test("test")
		//sleep(30)
	fdel("log_v8.txt");
	Test2("test1")

/world/Topic(T)
	world.log << "Received world.Topic with \"[T]\""
	return "hello2"