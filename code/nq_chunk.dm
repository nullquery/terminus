/world/{maxz=1;view=10}

/mob/var/turf/bla
/mob/var/obj/oooobj
/mob/Login()
	. = ..()

	spawn(10)
		world.maxx = 100
		world.maxy = 100
		world.maxz = 1
		loc = locate(10,5,1)
		world << "Done. [world.maxx],[world.maxy],[world.maxz], [src.loc], [src.client.eye], [world.view]"

		for (var/turf/T in world)
			new/turf/floor(T)

		for (var/turf/T in block(locate(1,3,1), locate(5,3,1)))
			new/turf/wall(T)

		var/mob/m = new/mob(locate(1,6,1))

		//m.bla = locate(5, 20, 1)
		m.oooobj = new/obj()
		var/turf/Tt = locate(5,20,1)
		Tt.desc = "Test"

		spawn(1)
			world << "Saving..."

			var/nq_chunk/chunk = new/nq_chunk(1, 1, 1, 20, 10, 1)

			chunk.WriteToFile("test.sav")

			spawn(1)
				world << "Wiping..."

				for(var/turf/T in world)
					new/turf(T)

				del m

				spawn (1)
					world << "Loading..."

					nq_chunk.LoadFromFile("test.sav", 1, 1, 1)

					m = locate(/mob, locate(1,6,1))

					world << "mob = [m]"
					if (m)
						world << "mob.bla = [m.bla] - [m.bla == locate(5, 20, 1)] - [m.oooobj]"

/world/Error(exception/e)
	world.log << "EXCEPTION: [e.name]"