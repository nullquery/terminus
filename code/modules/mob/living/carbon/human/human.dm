/mob/living/carbon/human
{
	icon									= 'icon/mob/human.dmi';
	var
		skin_appearances_id;
		hair_appearances_id;
		facial_appearances_id;
		underwear_appearances_id;
		hair_color;
		facial_color;

	New()
	{
		. = ..();

		src.skin_appearances_id				= 78; // "Caucasian 2"
		src.hair_appearances_id				= 1;  // "Short hair"
		src.facial_appearances_id			= 67; // "Adam Jensen beard"
		src.underwear_appearances_id		= 85; // "Mens grey"
		hair_color							= rgb(0, 0, 0);
		facial_color						= rgb(0, 0, 0);
	}

	Login()
	{
		. = ..();

		src.UpdateIcon();
		src.UpdateItems();
	}

	UpdateIcon()
	{
		var/datum/appearance/app			= new/datum/appearance(src.gender, src.skin_appearances_id, src.hair_appearances_id, src.facial_appearances_id, src.underwear_appearances_id);

//		app.SetHairStyle(src.hair);
//		app.SetFacialHairStyle(src.facial);
//		app.SetUnderwearStyle(src.underwear);
		app.SetHairColor(src.hair_color);
		app.SetFacialHairColor(src.facial_color);

		src.icon							= app.GetIcon();
		src.icon_state						= app.GetIconState();
		src.overlays						= list();

		for (var/image/I in app.GetOverlays())
		{
			src.overlays.Add(I);
		}

		var/matrix/matrix					= new/matrix()

		if (resting)						{ matrix = turn(matrix, 90); pixel_y = -8; }
		else								{ pixel_y = 0; }

		src.transform						= matrix;

		UpdateClothing();
	}

	proc
		UpdateItems()
		{
			src.name						= src.r_name;
		}
}
