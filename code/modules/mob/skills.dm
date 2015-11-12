/datum/attributes
{
	var
		datum/attribute
			health				= new/datum/attribute("Health", "The amount of life force you currently have.", 35, 85)
			strength			= new/datum/attribute("Strength", "The amount of physical strength your have.", 35, 85)
}

/datum/attribute
{
	var
		s_name;      // Name of attribute/skill
		s_desc;      // Description of attribute/skill (if wanted)

		current_amt; // Current amount of said attribute
		max_amt;     // Max amount of said attribute
		             // Ex: strength - 10(current)/20(max), max strength is 20, but current strength can fluctuate from 0 - Max amount

		min_exp;     // minimum/max experience for each attribute if wanted for leaving up
		max_exp;

	New(var/s_name, var/s_desc, var/c_amt, var/m_amt)
	{
		. = ..();

		if (s_name)			{ src.s_name      = s_name; }
		if (s_desc)			{ src.s_desc      = s_desc }
		if (c_amt)			{ src.current_amt = c_amt; }
		if (m_amt)			{ src.max_amt     = m_amt; }
	}

	proc/check_skill(mob/M) //Can be overridden to do whatever with (ex: activate for specific skill to do a dice roll or whatever)

	proc/level_skill()
	{
		// Can be used to check min_exp/max_exp or increasing max_amt of skill
	}
}
