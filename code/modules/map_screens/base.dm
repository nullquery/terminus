/datum/map_screens
{
	var
		width								= 15
		height								= 15
		x1
		y1
		z

	New(turf/turf)
	{
		. = ..();

		src.x1								= turf.x;
		src.y1								= turf.y;
		src.z								= turf.z;
	}

	proc
		Populate()							{ /* empty */ }
		Destroy()							{ /* empty */ }
}

var/datum/map_screens_global/map_screens	= new/datum/map_screens_global();

/datum/map_screens_global
{
	var
		datum/map_screens
			map_loader

	proc
		GetFreeLocation(width, height)
		{
			if (world.maxz < 2)				{ world.maxz = 2; }

			return locate(1,1,2);
		}

		GetMapLoader()
		{
			if (!src.map_loader)
			{
				src.map_loader				= new/datum/map_screens/map_loader(GetFreeLocation());

				src.map_loader.Populate();
			}

			return locate(map_loader.x1 + 7, map_loader.y1 + 7, map_loader.z);
		}
}
