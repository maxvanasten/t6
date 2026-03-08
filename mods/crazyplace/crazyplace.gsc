#include common_scripts\utility;
#include maps\mp\zm_tomb_teleporter;

init()
{
	level thread mapInit();
}

mapInit()
{
	level.player_out_of_playable_area_monitor = false;
	for ( ;; )
	{
		level waittill("connecting", player);
		player thread onPlayerConnected();
	}
}

onPlayerConnected()
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	for ( ;; )
	{
		self waittill("spawned_player");
		self thread initPlayer();
	}
}

initPlayer()
{
	activateChamberZone();
	wait 0.05;
	self setOrigin((10340, -7888, -412));
}

activateChamberZone()
{
	if (isdefined(level.crazyplace_chamber_zone_activated) && level.crazyplace_chamber_zone_activated)
		return;

	level.crazyplace_chamber_zone_activated = true;
	flag_set("activate_zone_chamber");
}
