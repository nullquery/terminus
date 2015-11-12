/attributes
{
	var
		s_name;      // Name of attribute/skill
		s_desc;      // Description of attribute/skill (if wanted)

		current_amt; // Current amount of said attribute
		max_amt;     // Max amount of said attribute
		             // Ex: strength - 10(current)/20(max), max strength is 20, but current strength can fluctuate from 0 - Max amount

		min_exp;     // minimum/max experience for each attribute if wanted for leaving up
		max_exp;

	New(var/c_amt, var/m_amt)
	{
		. = ..();
		if(c_amt)src.current_amt			= c_amt;
		if(m_amt)src.max_amt				= m_amt;
	}

	proc/check_skill(mob/M) //Can be overided to do whatever with (ex: activate for specific skill to do dice roll or whatever)

	proc/level_skill()
	{
		// Can be used to check min_exp/max_exp or increasing max_amt of skill
	}
}

/level
{
	parent_type				= /attributes;

	s_name					= "Level";
	s_desc					= "Your current character level.";

	check_skill(mob/M)
	{
		// Do whatever is wanted after level.check_skill() is called
	}

}

/health
{
	parent_type				= /attributes;

	s_name					= "Health";
	s_desc					= "The amount of life force you currently have.";

	check_skill(mob/M)
	{
		// Do whatever is wanted after health.check_skill() is called
	}

}

/strength
{
	parent_type				= /attributes;

	s_name					= "Strength";
	s_desc					= "The amount of physical strength your have.";

	check_skill(mob/M)
	{
		// Do whatever is wanted after strength.check_skill() is called
	}

}