/mob/living
{
	Login()
	{
		. = ..();
	}

	var
		character

			level/level 			= new/level(1,1);

		skills

			health/health 			= new/health(100,100);
			strength/strength 		= new/strength(0,0);

}
