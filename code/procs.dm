/proc/qdel(obj)
{
	if (istype(obj, /atom/movable))
	{
		var/atom/movable/a				= obj;
		a.loc							= null;
	}
	else								{ del obj; }
}

/proc/LogException(var/exception/ex)
{
	if (istype(ex))
		world.log << "ERROR: [ex.name]\nFILE: [ex.file]:[ex.line]\nSTACK TRACE:\n[ex.desc]"
	else
		world.log << "ERROR: [ex]"
}
