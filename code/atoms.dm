/atom/movable
{
	var
		tmp/datum/map_chunk/chunk;

	proc
		SetChunk()
		{
			if (x && y && z == 1)
			{
				var/datum/map_chunk/new_chunk		= map.GetChunk(x, y);

				if (new_chunk != src.chunk)
				{
					var/datum/map_chunk/old_chunk	= src.chunk;

					src.chunk						= new_chunk;

					new_chunk.Entered(src);
					if (old_chunk != null)			{ old_chunk.Exited(src); }
				}
			}
			else
			{
				if (src.chunk)						{ src.chunk.Exited(src); }

				src.chunk							= null;
			}
		}

		SetLocation(x, y, z)
		{
			src.loc									= locate(x, y, z);

			SetChunk();
		}

	New()
	{
		. = ..();

		SetChunk();
	}

	Move()
	{
		. = ..();

		SetChunk();
	}
}
