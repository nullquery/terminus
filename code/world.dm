/world
{
	name			= "Terminus";
	hub				= "NullQuery.Terminus";
	hub_password	= "Zk2nJDUigfujfOEG";
	maxx			= 1;
	maxy			= 1;
	maxz			= 2;
	view			= "15x15";
	fps				= 40;
	mob = /mob/living/carbon/human;
}

/world/New()
{
	. = ..();

	spawn			{ TerminusLibrary.Start(); }
}

/world/Del()
{
	#warn TODO: Wait until all maps are saved.

	return ..();
}
