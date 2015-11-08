var/datum/TerminusLibrary/TerminusLibrary = new/datum/TerminusLibrary();

/datum/TerminusLibrary/var/processing		= FALSE;

/datum/TerminusLibrary/proc/Start()
{
	if (!src.processing)					{ spawn Process(); }
}

/datum/TerminusLibrary/proc/Process()
{
	set background = TRUE;

	var/XML/Element/root;
	var/list/messages;

	src.processing							= TRUE;

	while (processing)
	{
		sleep(10);

		world.log << "messages: [html_encode(Call("getMessages"))]"
/*
		root								= xmlRootFromString(Call("getMessages"));
		messages							= root.Descendants("message");

		world.log << "Received [messages.len] messages";
*/
	}
}

/datum/TerminusLibrary/proc/Call(name, ...)
{
	var/list/L								= args.Copy(2)

	return call(world.system_type == MS_WINDOWS ? "./libterminus.dll" : "./libterminus.so", name)(arglist(L));
}
