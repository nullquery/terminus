/mob/living/var
{
		datum/attributes/attributes = new/datum/attributes();
}

/mob/living
{
	Login()
	{
		. = ..();
	}
}
