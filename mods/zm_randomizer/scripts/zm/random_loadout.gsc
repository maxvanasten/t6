/# 
yo bro i’ve just a really REALLY cool video idea
is it possible to make a script on bo2 that gives you a random load out on spawn? for example 4 random perks, random chance for special equipment like g strikes or monkeys, semtexes. random guns, random chance if they’re PAPd
could make for a really interesting video where i beat all the easter eggs with random loadouts
#/

#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include scripts\zm\maxlib;

init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	self.wone = ml_create_text(1.5, 0, -170, "");
	self.wtwo = ml_create_text(1.5, 0, -150, "");

	self give_random_loadout();
}

give_random_loadout()
{
	self ml_take_all_weapons();

	for (i = 0; i < 2; i = i + 1)
	{
		weapon_name = random(ml_weapons(level.script));
		if (issubstr(weapon_name, "_upgraded_zm") && issubstr(weapon_name, "staff_"))
		{
			self thread give_upgraded_staff(weapon_name);
		}
	
		else
		{
			self giveweapon(weapon_name);
		}
	
		self givemaxammo(weapon_name);

		if (i == 0) {
			self.wone ml_update_text(weapon_name);
		} else {
			self.wtwo ml_update_text(weapon_name);
		}
	}
}

give_upgraded_staff(weapon_name)
{
	camo = self calcweaponoptions(40, 0, 0, 0);
	self giveweapon(weapon_name, 0, camo);
	self switchtoweapon(weapon_name);
	self giveweapon("staff_revive_zm");
	self setactionslot(3, "weapon", "staff_revive_zm");
	self givemaxammo(weapon_name);
	self givemaxammo("staff_revive_zm");
}
