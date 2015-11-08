var/datum/map/map = new/datum/map();

/datum/map
{
	var
		const
			CHUNK_SIZE					= 64;
			MAP_BOUNDS					= CHUNK_SIZE * 4;
			SCREEN_BOUNDS				= 7;

		list/chunks;
	proc
		GetChunk(x, y)
		{
			var
				cx						= round(x / 64) + 1;
				cy						= round(y / 64) + 1;

			return GetChunkC(cx, cy);
		}

		GetChunkC(cx, cy)
		{
			var
				x1;
				y1;
				x2;
				y2;
				name					= "[cx]_[cy]";

			x1							= cx == 1 ? 0 : (64 * (cx - 1));
			y1							= cy == 1 ? 0 : (64 * (cy - 1));
			x2							= x1 + CHUNK_SIZE - 1;
			y2							= y1 + CHUNK_SIZE - 1;

			if (x1 == 0)				{ x1 = 1; }
			if (y1 == 0)				{ y1 = 1; }

			if (x1 <= 0 || y1 <= 0)		{ return null; }

			if (!chunks)				{ chunks = new/list(); }

			if (!chunks[name])
			{
				AllocateLocation(x2, y2);

				chunks[name]			= new/datum/map_chunk(new/nq_chunk(x1, y1, 1, x2, y2, 1), "data/map/[name].dat", cx, cy);
			}

			return chunks[name];
		}

		LoadChunk(x, y)
		{
			var/datum/map_chunk/chunk	= y ? GetChunk(x, y) : x;

			chunk.Load();

			for (chunk in chunk.GetSurroundingChunks())
			{
				chunk.Load();
			}
		}

		AllocateLocation(x, y)
		{
			.							= FALSE;

			x							= x + SCREEN_BOUNDS;
			y							= y + SCREEN_BOUNDS;

			if (world.maxx < x)			{ world.maxx = x + MAP_BOUNDS; }
			if (world.maxy < y)			{ world.maxy = y + MAP_BOUNDS; }
		}

		Locate(x, y)
		{
			LoadChunk(x, y);

			return locate(x, y, 1);
		}

		ShowMapLoader(client/client)
		{
			if (client)
			{
				client.SetEye(map_screens.GetMapLoader());
			}
		}

		HideMapLoader(client/client)
		{
			if (client)
			{
				client.SetEye(null);
			}
		}
}

/datum/map_chunk
{
	var
		const
			STATE_LOADING										= 1;
			STATE_UNLOADING										= 2;
			STATE_SAVING										= 4;
			STATE_LOADED										= 8;
		state													= 0;
		used_by													= 0; // used by X players
		nq_chunk/chunk;
		filename;
		cx;
		cy;

	New(nq_chunk/chunk, filename, cx, cy)
	{
		src.chunk												= chunk;
		src.filename											= filename;
		src.cx													= cx;
		src.cy													= cy;
	}

	proc
		HasState(state)											{ return (src.state & state) == state; }

		Entered(atom/movable/atom)
		{
			if (ismob(atom))
			{
				var/mob/mob										= atom;

				if (mob.client)									{ used_by++; }
			}

			spawn(-1)											{ map.LoadChunk(src); }
		}

		Exited(atom/movable/atom)
		{
			if (ismob(atom))
			{
				var/mob/mob										= atom;

				if (mob.client)									{ RemoveUsedBy(); }
			}
		}

		Login(mob/mob)											{ used_by++; }
		Logout(mob/mob)											{ RemoveUsedBy(); }

		RemoveUsedBy()
		{
			if (--used_by <= 0)									{ CO.LastActionHero(src, "CheckUsedBy", 10 * 45, TRUE); }
		}

		CheckUsedBy(isSurrounding = FALSE)
		{
			if (src.HasState(STATE_LOADED) && !src.HasState(STATE_UNLOADING) && src.used_by <= 0)
			{
				var/list/chunks									= GetSurroundingChunks();

				if (isSurrounding)
				{
					for (var/datum/map_chunk/chunk in chunks)
					{
						// Can't unload if a surrounding chunk is used.
						if (chunk.used_by > 0)					{ return; }
					}

					src.Unload(TRUE);

					// Try to unload the surrounding chunks (as they have a used_by <= 0)
					for (var/datum/map_chunk/chunk in chunks)	{ chunk.CheckUsedBy(TRUE); }
				}
				else
				{
					// The current chunk may always be in use (is surrounding chunk of the players' new chunk)
					// Try to unload the surrounding chunks instead.
					for (var/datum/map_chunk/chunk in chunks)	{ chunk.CheckUsedBy(TRUE); }
				}
			}
		}

		Load()													{ CO.LastActionHero(src, "LoadChunk", 0, TRUE); }

		LoadChunk()
		{
			while (src.HasState(STATE_SAVING))					{ sleep(1); }

			if (!src.HasState(STATE_LOADED))
			{
				src.state										= src.state | STATE_LOADING;

				world.log << "Loading [chunk.x1],[chunk.y1] to [chunk.x2],[chunk.y2]"

				if (/*FALSE &&*/ fexists(filename))
				{
					try											{ nq_chunk.LoadFromFile(filename, chunk.x1, chunk.y1, chunk.z1); }
					catch (var/ex)								{ LogException(ex); }
				}
				else
				{
					for (var/turf/turf in chunk.turfs)
					{
						new/turf/floor(turf);
					}
				}

				world.log << "Loaded [chunk.x1],[chunk.y1] to [chunk.x2],[chunk.y2]"

				src.state										= src.state &~ STATE_LOADING;
				src.state										= src.state | STATE_LOADED;
			}
		}

		Save()													{ CO.LastActionHero(src, "SaveChunk", 0, TRUE); }

		SaveChunk()
		{
			while (src.HasState(STATE_LOADING))					{ sleep(1); }

			if (src.HasState(STATE_LOADED))
			{
				src.state										= src.state | STATE_SAVING;


				try												{ chunk.WriteToFile(filename); }
				catch (var/ex)									{ LogException(ex); }

				src.state										= src.state &~ STATE_SAVING;
			}
		}

		Unload(save)											{ CO.LastActionHero(src, "UnloadChunk", 0, TRUE, save); }

		UnloadChunk(save)
		{
			if (src.HasState(STATE_LOADED))
			{
				src.state										= src.state | STATE_UNLOADING;

				world.log << "Unloading [chunk.x1],[chunk.y1] to [chunk.x2],[chunk.y2]"

				if (save)										{ Save(); }

				var/mob/mob
				for (var/turf/turf in chunk.turfs)
				{
					for (var/atom/atom in turf.contents)
					{
						if (ismob(atom))
						{
							mob									= atom;

							if (mob.ckey)						{ continue; }
						}

						qdel(atom);
					}

					qdel(turf);
				}

				world.log << "Unloaded [chunk.x1],[chunk.y1] to [chunk.x2],[chunk.y2]"

				src.state										= src.state &~ STATE_UNLOADING;
				src.state										= src.state &~ STATE_LOADED;
			}
		}

		_AddToList(datum/map_chunk/chunk, list/L)
		{
			if (chunk)											{ L.Add(chunk); }
		}

		GetSurroundingChunks()
		{
			var/list/L											= new/list();

			_AddToList(map.GetChunkC(src.cx - 1,	src.cy - 1),	L);
			_AddToList(map.GetChunkC(src.cx - 1,	src.cy),		L);
			_AddToList(map.GetChunkC(src.cx - 1,	src.cy + 1),	L);
			_AddToList(map.GetChunkC(src.cx - 1,	src.cy + 1),	L);
			_AddToList(map.GetChunkC(src.cx,		src.cy + 1),	L);
			_AddToList(map.GetChunkC(src.cx + 1,	src.cy + 1),	L);
			_AddToList(map.GetChunkC(src.cx + 1,	src.cy),		L);
			_AddToList(map.GetChunkC(src.cx + 1,	src.cy - 1),	L);
			_AddToList(map.GetChunkC(src.cx,		src.cy - 1),	L);

			return L;
		}
}
