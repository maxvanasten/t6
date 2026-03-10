// [player]ml_can_upgrade_weapon:bool
ml_can_upgrade_weapon()
{
	weapon_name = self getcurrentweapon();
	switch(weapon_name) {
		case "staff_lightning_zm":
			return false;
		case "staff_fire_zm":
			return false;
		case "staff_air_zm":
			return false;
		case "ray_gun_zm":
			return false;
		case "raygun_mark2_zm":
			return false;
		default:
			return true;
	}
}

// [player]ml_upgrade_weapon
ml_upgrade_weapon()
{
	if (!self ml_can_upgrade_weapon())
	{
		return;
	}

	upgraded_weapon_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(weapon_name, 1);

	self takeweapon(weapon_name);
	self giveweapon(self.upgraded_weapon_name);
}

// [player]ml_take_all_weapons
ml_take_all_weapons()
{
	weaponslist = self getweaponslist();
	for (i = 0; i < weaponslist.size; i = i + 1)
	{
		if (weaponslist[i] != "knife_zm")
		{
			self takeweapon(weaponslist[i]);
		}
	}
}
