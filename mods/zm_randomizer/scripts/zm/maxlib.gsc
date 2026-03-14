#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
// [player]ml_upgrade_weapon
ml_upgrade_weapon()
{
	weapon_name = self getcurrentweapon();
	if (issubstr(weapon_name, "upgraded_zm")) {
		return;
	}

	upgraded_weapon_name = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(weapon_name, 1);

	self takeweapon(weapon_name);
	self giveweapon(upgraded_weapon_name);
}

// [player]ml_take_all_weapons
ml_take_all_weapons()
{
	weaponslist = self getweaponslist();
	for (i = 0; i < weaponslist.size; i = i + 1)
	{
		if (weaponslist[i] != "knife_zm") {
			self takeweapon(weaponslist[i]);
		}
	}
}

ml_give_weapon(weapon_name)
{
	self giveweapon(weapon_name);
	self givemaxammo(weapon_name);
	self switchtoweapon(weapon_name);
}

// ml_create_text:hud_elem
ml_create_text(font_size, xoffset, yoffset, text)
{
	hud_elem = createFontString("objective", font_size);
	hud_elem setPoint("CENTER", "CENTER", xoffset, yoffset);
	hud_elem.alpha = 1;
	hud_elem.hidewheninmenu = true;
	hud_elem.hidewhendead = true;
	hud_elem.color = (1, 1, 1);
	hud_elem setText(text);
	hud_elem.stored_text = text;
	return hud_elem;
}

// [hud_elem]ml_update_text
ml_update_text(text)
{
	if (self.stored_text != text) {
		self setText(text);
		self.stored_text = text;
	}
}

// ml_powerups:string[]
ml_powerups()
{
	return array("nuke", "insta_kill", "full_ammo", "double_points", "carpenter", "fire_sale", "free_perk");
}

// ml_perks:string[]
ml_perks()
{
	switch(level.script) {
		case "zm_tomb":
			return array("specialty_quickrevive", "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_longersprint", "specialty_deadshot", "specialty_additionalprimaryweapon", "specialty_grenadepulldeath");
		case "zm_prison":
			return array("specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive", "specialty_deadshot", "specialty_grenadepulldeath");
		case "zm_buried":
			return array("specialty_quickrevive", "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_longersprint", "specialty_deadshot", "specialty_scavenger");
		case "zm_highrise":
			return array("specialty_quickrevive", "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_additionalprimaryweapon", "specialty_who");
		case "zm_transit":
			return array("specialty_quickrevive", "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_longersprint");
		case "zm_nuked":
			return array("specialty_quickrevive", "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_longersprint", "specialty_deadshot");
		default:
			return array("");
	}
}

// ml_weapons:string[]
ml_weapons(map_name)
{
	switch(map_name) {
		case "zm_tomb":
			return array("c96_zm", "c96_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "fiveseven_zm", "fiveseven_upgraded_zm", "mp40_zm", "mp40_upgraded_zm", "pdw57_zm", "pdw57_upgraded_zm", "ak74u_zm", "ak74u_upgraded_zm", "m14_zm", "m14_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "ballista_zm", "ballista_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm", "hamr_zm", "hamr_upgraded_zm", "mg08_zm", "mg08_upgraded_zm", "mp44_zm", "mp44_upgraded_zm", "m32_zm", "m32_upgraded_zm", "one_inch_punch_zm", "one_inch_punch_upgraded_zm", "one_inch_punch_air_zm", "one_inch_punch_fire_zm", "one_inch_punch_ice_zm", "one_inch_punch_lightning_zm");
		case "zm_prison":
			return array("m1911_zm", "m1911_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "fiveseven_zm", "fiveseven_upgraded_zm", "mp5k_zm", "mp5k_upgraded_zm", "pdw57_zm", "pdw57_upgraded_zm", "m14_zm", "m14_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm");
		case "zm_buried":
			return array("m1911_zm", "m1911_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "mp5k_zm", "mp5k_upgraded_zm", "pdw57_zm", "pdw57_upgraded_zm", "ak74u_zm", "ak74u_upgraded_zm", "m16_zm", "m16_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "an94_zm", "an94_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm", "hamr_zm", "hamr_upgraded_zm", "m32_zm", "m32_upgraded_zm");
		case "zm_highrise":
			return array("m1911_zm", "m1911_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "mp5k_zm", "mp5k_upgraded_zm", "pdw57_zm", "pdw57_upgraded_zm", "ak74u_zm", "ak74u_upgraded_zm", "m14_zm", "m14_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "an94_zm", "an94_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm", "hamr_zm", "hamr_upgraded_zm", "m32_zm", "m32_upgraded_zm");
		case "zm_transit":
			return array("m1911_zm", "m1911_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "mp5k_zm", "mp5k_upgraded_zm", "ak74u_zm", "ak74u_upgraded_zm", "m14_zm", "m14_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm", "hamr_zm", "hamr_upgraded_zm", "m32_zm", "m32_upgraded_zm");
		case "zm_nuked":
			return array("m1911_zm", "m1911_upgraded_zm", "beretta93r_zm", "beretta93r_upgraded_zm", "fiveseven_zm", "fiveseven_upgraded_zm", "mp5k_zm", "mp5k_upgraded_zm", "pdw57_zm", "pdw57_upgraded_zm", "ak74u_zm", "ak74u_upgraded_zm", "m14_zm", "m14_upgraded_zm", "galil_zm", "galil_upgraded_zm", "fnfal_zm", "fnfal_upgraded_zm", "an94_zm", "an94_upgraded_zm", "870mcs_zm", "870mcs_upgraded_zm", "dsr50_zm", "dsr50_upgraded_zm", "hamr_zm", "hamr_upgraded_zm", "lsat_zm", "lsat_upgraded_zm", "m32_zm", "m32_upgraded_zm");
		default:
			return array("");
	}
}

ml_unupgraded_weapons(map_name)
{
	weapons = ml_weapons(map_name);
	unupgraded_weapons = [];

	foreach (weapon in weapons)
	{
		if (!issubstr(weapon, "upgraded")) {
			unupgraded_weapons[unupgraded_weapons.size] = weapon;
		}
	}

	return unupgraded_weapons;
}

ml_upgraded_weapons(map_name)
{
	weapons = ml_weapons(map_name);
	upgraded_weapons = [];

	foreach (weapon in weapons)
	{
		if (issubstr(weapon, "upgraded")) {
			upgraded_weapons[upgraded_weapons.size] = weapon;
		}
	}

	return upgraded_weapons;
}

ml_wonder_weapons(map_name)
{
	switch(map_name) {
		case "zm_tomb":
			return array("staff_air_zm", "staff_air_upgraded_zm", "staff_fire_zm", "staff_fire_upgraded_zm", "staff_lightning_zm", "staff_lightning_upgraded_zm", "staff_water_zm", "staff_water_upgraded_zm", "ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm");
		case "zm_prison":
			return array("ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm", "blundergat_zm", "blundergat_upgraded_zm", "blundersplat_zm", "blundersplat_upgraded_zm", "minigun_alcatraz_zm", "minigun_alcatraz_upgraded_zm", "bouncing_tomahawk_zm", "upgraded_tomahawk_zm");
		case "zm_buried":
			return array("ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm", "slowgun_zm", "slowgun_upgraded_zm");
		case "zm_highrise":
			return array("ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm", "slipgun_zm", "slipgun_upgraded_zm");
		case "zm_transit":
			return array("ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm", "jetgun_zm");
		case "zm_nuked":
			return array("ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm");
		default:
			return array("");
	}
}
