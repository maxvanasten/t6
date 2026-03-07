create_trigger(x, y, z)
{
	level endon("end_game");

	trigger = spawn("trigger_radius", (x, y, z), 0, 50, 50);
	trigger setCursorHint("HINT_NOICON");
	trigger setHintString("^3[{+activate}]^7 to use trigger");

	while (true)
	{
		trigger waittill("trigger", player);
		if (player usebuttonpressed())
		{
			// Check if player has enough money etc.
			player thread trigger_activation();
			wait 0.5;
		}
	}
}

trigger_activation()
{
	player iprintlnbold("Triggered trigger!");
}
