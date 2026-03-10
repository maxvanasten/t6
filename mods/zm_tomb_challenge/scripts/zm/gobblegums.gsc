#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
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
	self thread ttg_init();
	for ( ;; )
	{
		self thread ttg_update();
		wait 0.05;
	}
}

ttg_init()
{
	self iPrintLn("[^2gobblegums^7] This script was made using ts_gsc, the TypeScript to GSC transpiler! (^5https://github.com/maxvanasten/ts_gsc^7)");
	gobblegum_pos = (0, 0, 0);
	switch(tolower(getdvar(#"mapname"))) {
		case "zm_tomb":
			gobblegum_pos = (2381, 4752, -301);
			break;
		case "zm_prison":
			gobblegum_pos = (727, 10670, 1336);
			break;
		case "zm_buried":
			gobblegum_pos = (152, 133, 10);
			break;
		case "zm_transit":
			gobblegum_pos = (-6361, 5480, -55);
			break;
		case "zm_nuked":
			gobblegum_pos = (-237, 996, -63);
			break;
		default:
	}

	level thread setup_gobblegum_machine(gobblegum_pos[0], gobblegum_pos[1], gobblegum_pos[2]);
	self.gobblegum_cooldown = 0;
	self.last_gobblegum_round = -1;
	self.powerup_list = array("nuke", "insta_kill", "full_ammo", "double_points", "carpenter", "fire_sale", "free_perk");
	self.gobblegum_list = array("in_plain_sight", "resupply", "multiplier", "perkdrop", "weapon_upgrade", "perkaholic", "killjoy");
	self.perk_list = array("specialty_quickrevive", "specialty_deadshot", "specialty_fastreload", "specialty_armorvest", "specialty_longersprint", "specialty_rof", "specialty_grenadepulldeath");
	self.gg_hud_name = create_text(1.2, 0, 150, "");
	self.gg_hud_desc = create_text(1, 0, 160, "no gobblegum");
	self.gobblegum = spawnstruct();
	self.gobblegum get_gobblegum("killjoy");
	self update_hud();
}

ttg_update()
{
	if (self.gobblegum.cooldown <= 0 && self.gobblegum.name != "")
	{
		if (self adsbuttonpressed() && self usebuttonpressed())
		{
			self iprintlnbold("Activated gobblegum: " + self.gobblegum.name);
			self thread activate_gobblegum();
			self.gobblegum.name = "";
			self update_hud();
		}
	}

	else
	{
		self.gobblegum.cooldown = self.gobblegum.cooldown - 0.05;
	}
}

setup_gobblegum_machine(x, y, z)
{
	level endon("end_game");
	print("Creating trigger. x: " + x + " y: " + y + " z: " + z);
	trigger_gobblegum = spawn("trigger_radius", (x, y, z + 30), 0, 50, 50);
	trigger_gobblegum setCursorHint("HINT_NOICON");
	trigger_gobblegum setHintString("^3[{+activate}]^7 to get a gobblegum.");
	while (true)
	{
		trigger_gobblegum waittill("trigger", player);
		if (player usebuttonpressed())
		{
			if (player.last_gobblegum_round != level.round_number)
			{
				player thread buy_gobblegum();
				player thread update_hud();
				wait 0.5;
			}
		
			else
			{
				player iprintlnbold("You have already received a gobblegum this round.");
				wait 0.5;
			}
		}
	}
}

activate_gobblegum()
{
	switch(self.gobblegum.identifier) {
		case "in_plain_sight":
			self thread gg_in_plain_sight();
			break;
		case "resupply":
			self thread gg_resupply();
			break;
		case "multiplier":
			self thread gg_multiplier();
			break;
		case "perkdrop":
			self thread gg_perkdrop();
			break;
		case "weapon_upgrade":
			self thread gg_weapon_upgrade();
			break;
		case "perkaholic":
			self thread gg_perkaholic();
			break;
		case "killjoy":
			self thread gg_killjoy();
			break;
		default:
	}
}

buy_gobblegum()
{
	if (self.gobblegum.name == "")
	{
		self.last_gobblegum_round = level.round_number;
		identifier = random(self.gobblegum_list);
		self.gobblegum get_gobblegum(identifier);
		self update_hud();
		self iprintlnbold("You have received a gobblegum. (" + self.gobblegum.name + ")");
	}

	else
	{
		self iprintlnbold("You already have a gobblegum!");
	}
}

get_gobblegum(identifier)
{
	self.identifier = identifier;
	self.cooldown = 0;
	switch(identifier) {
		case "in_plain_sight":
			self.name = "In plain sight";
			self.desc = "Zombies ignore the player for 10s";
			break;
		case "resupply":
			self.name = "Resupply";
			self.desc = "Drops a max ammo";
			break;
		case "multiplier":
			self.name = "Multiplier";
			self.desc = "Drops a double points";
			break;
		case "perkdrop":
			self.name = "Perk drop";
			self.desc = "Drops a free perk";
			break;
		case "weapon_upgrade":
			self.name = "Weapon upgrade";
			self.desc = "PaP your current weapon";
			break;
		case "perkaholic":
			self.name = "Perkaholic";
			self.desc = "Receive all perks";
			break;
		case "killjoy":
			self.name = "Kill Joy";
			self.desc = "Spawn an insta-kill";
			break;
		default:
			self.name = "";
			self.dec = "no gobblegum";
	}
}

gg_in_plain_sight()
{
	self.ignoreme = true;
	self.gobblegum_cooldown = 10;
	wait 10;
	self.ignoreme = false;
}

gg_resupply()
{
	self maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", self.origin);
	self.gobblegum_cooldown = 10;
}

gg_multiplier()
{
	self maps\mp\zombies\_zm_powerups::specific_powerup_drop("double_points", self.origin);
	self.gobblegum_cooldown = 10;
}

gg_perkdrop()
{
	self maps\mp\zombies\_zm_powerups::specific_powerup_drop("free_perk", self.origin);
	self.gobblegum_cooldown = 10;
}

gg_killjoy()
{
	self maps\mp\zombies\_zm_powerups::specific_powerup_drop("insta_kill", self.origin);
	self.gobblegum_cooldown = 10;
}

gg_perkaholic()
{
	foreach (perk in self.perk_list)
	{
		self maps\mp\zombies\_zm_perks::give_perk(perk);
	}

	self.gobblegum_cooldown = 10;
}

gg_weapon_upgrade()
{
	current_weapon = self getcurrentweapon();
	upgraded_weapon = maps\mp\zombies\_zm_weapons::get_upgrade_weapon(current_weapon, 1);
	if (isdefined(upgraded_weapon))
	{
		self takeweapon(current_weapon);
		self giveweapon(upgraded_weapon, 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(upgraded_weapon));
		self givestartammo(upgraded_weapon);
		self switchtoweapon(upgraded_weapon);
	}

	self.gobblegum_cooldown = 10;
}

update_text(text)
{
	if (self.stored_text != text)
	{
		self setText(text);
		self.stored_text = text;
	}
}

update_hud()
{
	if (self.gobblegum.name != "")
	{
		self.gg_hud_name update_text("^6(aim + f): " + self.gobblegum.name);
		self.gg_hud_desc update_text(self.gobblegum.desc);
	}

	else
	{
		self.gg_hud_name update_text("");
		self.gg_hud_desc update_text("");
	}
}

create_text(font_size, xoffset, yoffset, text)
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
