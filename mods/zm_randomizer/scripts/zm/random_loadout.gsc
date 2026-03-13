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
	if (level.script == "zm_prison") {
		flag_wait("afterlife_start_over");
	}

	self.hud_weapon_one = ml_create_text(1.25, -200, -150, "");
	self.hud_weapon_two = ml_create_text(1.25, -200, -135, "");
	self.hud_perks = [];

	for (i = 0; i < 4; i = i + 1)
	{
		offset = i * 15;
		self.hud_perks[i] = ml_create_text(1.25, -200, -120 + offset, "");
	}

	level.ml_unupgraded_weapons = ml_unupgraded_weapons(level.script);
	level.ml_upgraded_weapons = ml_upgraded_weapons(level.script);
	level.ml_wonder_weapons = ml_wonder_weapons(level.script);

	//level.weapon_list = array("jetgun_zm", "m14_zm");
	self give_random_loadout();
	self give_random_perks();
}

give_random_perks()
{
	perks = ml_perks();
	for (i = 0; i < 4; i = i + 1)
	{
		perk = random(perks);
		arrayremovevalue(perks, perk);
		self maps\mp\zombies\_zm_perks::give_perk(perk);
		self.hud_perks[i] ml_update_text("^5perk(" + i + ") ^7" + perk);
	}
}

give_random_loadout()
{
	self ml_take_all_weapons();

	// WEAPONS
	for (i = 0; i < 2; i = i + 1)
	{
		// d = random number 0...9 
		// if d = 0 WONDER WEAPON
		// if d = 1,2 PAPED WEAPON
		// if d = 3,4,5,6,7,8,9 REGULAR WEAPON
		weapon_name = "";
		d = randomint(10);
		if (d < 1) {
			weapon_name = random(level.ml_wonder_weapons);
		} else if (d >= 1 && d < 3) {
			weapon_name = random(level.ml_upgraded_weapons);
		} else {
			weapon_name = random(level.ml_unupgraded_weapons);
		}
	
		if (issubstr(weapon_name, "one_inch_punch")) {
			array_exclude(level.ml_unupgraded_weapons, array("one_inch_punch_air_zm", "one_inch_punch_fire_zm", "one_inch_punch_ice_zm", "one_inch_punch_lightning_zm", "one_inch_punch_zm", "one_inch_punch_upgraded_zm"));
		}
	
		if (issubstr(weapon_name, "_upgraded_zm")) {
			if (issubstr(weapon_name, "staff_")) {
				self thread give_upgraded_staff(weapon_name);
				arrayremovevalue(level.ml_wonder_weapons, weapon_name);
			} else {
				self thread give_upgraded_weapon(weapon_name);
				arrayremovevalue(level.ml_upgraded_weapons, weapon_name);
			}
		} else {
			self giveweapon(weapon_name);
		}
	
		if (issubstr(weapon_name, "tomahawk")) {
			self.has_hell_retriever = true;
			self.has_retriever = true;
			self notify("tomahawk_acquired");
			arrayremovevalue(level.ml_wonder_weapons, weapon_name);
		}
	
		if (issubstr(weapon_name, "jetgun")) {
			self.has_jetgun = true;
			self notify("jetgun_acquired");
			self notify("player_got_jetgun");
			self notify("player_has_jetgun");
			self switchToWeapon("knife_zm");
			wait(0.12);
			self switchToWeaponImmediate(weapon_name);
			arrayremovevalue(level.ml_wonder_weapons, weapon_name);
		}
	
		self givemaxammo(weapon_name);
		arrayremovevalue(level.ml_unupgraded_weapons, weapon_name);
	
		if (i == 0) {
			self.hud_weapon_one ml_update_text("^5weapon_one: ^7" + weapon_name);
		} else {
			self.hud_weapon_two ml_update_text("^5weapon_two: ^7" + weapon_name);
		}
	}
}

give_upgraded_weapon(weapon_name)
{
	camo = self calcweaponoptions(39, 0, 0, 0);
	if (level.script == "zm_tomb") {
		camo = self calcweaponoptions(40, 0, 0, 0);
	}

	self giveweapon(weapon_name, 0, camo);
	self switchtoweapon(weapon_name);
}

give_upgraded_staff(weapon_name)
{
	self give_upgraded_weapon(weapon_name);

	self giveweapon("staff_revive_zm");
	self setactionslot(3, "weapon", "staff_revive_zm");
	self givemaxammo("staff_revive_zm");
}
