var/pgsql4dm/Connection/database_connection = new("postgresql://terminus_dev:ruzecrU4@h.nullquery.net:5432/terminus_dev");

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
	var/pgsql4dm/Changelog/changelog = new(database_connection, "sql/changelog.xml");
	changelog.Process();

	. = ..();

	spawn			{ TerminusLibrary.Start(); }
}

/world/Del()
{
	#warn TODO: Wait until all maps are saved.

	return ..();
}
