/*
/datum/appearance_style
{
	var
		name;
		icon_state;
		gender = NEUTER;
}
*/

/datum/appearance
{
	var
		skin_appearances_id;
		hair_appearances_id;
		facial_appearances_id;
		underwear_appearances_id;

		hair_color											= rgb(0, 0, 0);
		facial_color										= rgb(0, 0, 0);
		eye_color											= rgb(0, 0, 0);
		gender;

	New(gender, skin_appearances_id, hair_appearances_id, facial_appearances_id, underwear_appearances_id)
	{
		src.gender											= gender;
		src.skin_appearances_id								= skin_appearances_id;
		src.hair_appearances_id								= hair_appearances_id
		src.facial_appearances_id							= facial_appearances_id;
		src.underwear_appearances_id						= underwear_appearances_id;
	}

	proc
//		SetSkin(datum/appearance_style/style)				{ src.skin = style; }
//		SetHairStyle(datum/appearance_style/style)			{ src.hair_style = style; }
//		SetFacialHairStyle(datum/appearance_style/style)	{ src.facial_style = style; }
//		SetUnderwearStyle(datum/appearance_style/style)		{ src.underwear_style = style; }
		SetHairColor(color)									{ src.hair_color = color; }
		SetFacialHairColor(color)							{ src.facial_color = color; }

		Generate(direction = null)
		{
			var/icon/I										= new/icon(icon = 'icon/mob/human.dmi', icon_state = "[GetIconState()]", dir = direction);

			if (src.underwear_appearances_id > 0)
			{
				var/icon/underwearIcon						= new/icon(icon = 'icon/mob/underwear.dmi', icon_state = "[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.underwear_appearances_id)]", dir = direction);

				I.Blend(underwearIcon, ICON_OVERLAY);
			}

			if (src.hair_appearances_id > 0)
			{
				var/icon/hairIcon							= new/icon(icon = 'icon/mob/human_face.dmi', icon_state = "hair_[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.hair_appearances_id)]", dir = direction);

				hairIcon.Blend(hair_color, ICON_ADD);

				I.Blend(hairIcon, ICON_OVERLAY);
			}

			if (src.facial_appearances_id > 0)
			{
				var/icon/facialHairIcon						= new/icon(icon = 'icon/mob/human_face.dmi', icon_state = "facial_[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.facial_appearances_id)]", dir = direction);

				facialHairIcon.Blend(facial_color, ICON_ADD);

				I.Blend(facialHairIcon, ICON_OVERLAY);
			}

			return I
		}

		GetIcon()											{ return 'icon/mob/human.dmi'; }
		GetIconState()										{ return "[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.skin_appearances_id)]_[src.gender == FEMALE ? "f" : "m"]"; }

		GetOverlays()
		{
			var/list/overlays								= new/list();

			if (src.underwear_appearances_id > 0)
			{
				overlays.Add(image(icon = 'icon/mob/underwear.dmi', icon_state = "[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.underwear_appearances_id)]"));
			}

			if (src.hair_appearances_id > 0)
			{
				var/icon/hairIcon = new/icon(icon = 'icon/mob/human_face.dmi', icon_state = "hair_[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.hair_appearances_id)]");

				hairIcon.Blend(hair_color, ICON_ADD);

				overlays.Add(image(icon = hairIcon));
			}

			if (src.facial_appearances_id > 0)
			{
				var/icon/facialHairIcon						= new/icon(icon = 'icon/mob/human_face.dmi', icon_state = "facial_[CO.getRSV("SELECT icon_state FROM appearances WHERE id = $1", src.facial_appearances_id)]");

				facialHairIcon.Blend(facial_color, ICON_ADD);

				overlays.Add(image(icon = facialHairIcon));
			}

			return overlays;
		}
}
