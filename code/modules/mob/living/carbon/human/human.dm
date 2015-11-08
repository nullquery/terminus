/mob/living/carbon/human
{
	icon									= 'icon/mob/human.dmi';
	var
		datum/appearance_style/skin;
		datum/appearance_style/hair;
		datum/appearance_style/facial;
		datum/appearance_style/underwear;
		hair_color;
		facial_color;

	New()
	{
		. = ..();

		skin								= new/datum/appearance_style/skin/caucasian2();
		hair								= new/datum/appearance_style/hair/spiky();
		facial								= new/datum/appearance_style/facial/hogan();
		underwear							= new/datum/appearance_style/underwear/male_hearts();
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
		var/datum/appearance/app			= new/datum/appearance(src.gender, src.skin);

		app.SetHairStyle(src.hair);
		app.SetFacialHairStyle(src.facial);
		app.SetUnderwearStyle(src.underwear);
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
