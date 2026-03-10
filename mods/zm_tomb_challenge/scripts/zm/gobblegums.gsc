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
	level._model = [];
	foreach (model in getentarray("script_model", "classname"))
	{
		model get_model();
	}
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
	self.gobblegum_list = array("in_plain_sight", "resupply", "multiplier", "perkdrop", "weapon_upgrade");
	self.gg_hud_name = create_text(1.2, -225, -160, "");
	self.gg_hud_desc = create_text(1, -225, -145, "");
}

ttg_update()
{
	if (self.gobblegum.cooldown <= 0 && self.gobblegum.name != "")
	{
		if (self adsbuttonpressed() && self usebuttonpressed())
		{
			self iprintlnbold("Activated gobblegum: " + self.gobblegum.name);
			self thread self.gobblegum.activate();
			self.gobblegum.name = "";
			self.gg_hud_name update_text("");
			self.gg_hud_desc update_text("");
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
	entities = getEntArray("script_model", "");
	while (true)
	{
		trigger_gobblegum waittill("trigger", player);
		if (player usebuttonpressed())
		{
			if (player.last_gobblegum_round != level.round_number)
			{
				player thread buy_gobblegum();
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

buy_gobblegum()
{
	if (self.gobblegum.name == "")
	{
		self.last_gobblegum_round = level.round_number;
		self.gobblegum = get_random_gobblegum();
		self.gg_hud_name update_text("^5(AIM + F): ^7" + self.gobblegum.name);
		self.gg_hud_desc update_text(self.gobblegum.desc);
		self iprintlnbold("You have received a gobblegum. (" + self.gobblegum.name + ")");
	}
	else
	{
		self iprintlnbold("You already have a gobblegum!");
	}
}

get_random_gobblegum()
{
	identifier = random(self.gobblegum_list);
	gobblegum = get_gobblegum(identifier);
}

get_gobblegum(identifier)
{
	gobblegum = spawnStruct();
	switch(identifier) {
		case "in_plain_sight":
			gobblegum.name = "In plain sight";
			gobblegum.desc = "Zombies ignore the player for 10s";
			gobblegum.activate = ::gg_in_plain_sight;
			break;
		case "resupply":
			gobblegum.name = "Resupply";
			gobblegum.desc = "Drops a max ammo";
			gobblegum.activate = ::gg_resupply;
			break;
		case "multiplier":
			gobblegum.name = "Multiplier";
			gobblegum.desc = "Drops a double points";
			gobblegum.activate = ::gg_multiplier;
			break;
		case "perkdrop":
			gobblegum.name = "Perk drop";
			gobblegum.desc = "Drops a free perk";
			gobblegum.activate = ::gg_perkdrop;
			break;
		case "weapon_upgrade":
			gobblegum.name = "Weapon upgrade";
			gobblegum.desc = "PaP your current weapon";
			gobblegum.activate = ::gg_weapon_upgrade;
			break;
		default:
			gobblegum.name = "";
			gobblegum.dec = "";
			gobblegum.activate = false;
	}
	return gobblegum;
}

get_model()
{
	if (!isinarray(level._model, self.model))
	{
		level._model[level._model.size] = self.model;
		print("Model: " + self.model);
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
		self.stored_text = test;
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
	hud_elem setText();
	hud_elem.stored_text = text;
	return hud_elem;
}
