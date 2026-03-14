#include scripts\zm\zm_quests;
#include scripts\zm\maxlib;
#include common_scripts\utility;
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

	self thread playerInit();

	for ( ;; )
	{
		self thread playerUpdate();
		wait 0.05;
	}
}

playerInit()
{
	// Add a simple quest
	self add_quest("kill_quest", "Zombie Killer", "Kill 10 zombies.", ::kill_quest_check, ::kill_quest_reward, ::kill_quest_progress);

	// Start first quest
	self start_quest(0);
}

// Check the quest every tick.
playerUpdate()
{
	self check_quest();
}

// Should return a BOOLEAN true when quest is completed.
kill_quest_check()
{
	return self.kills >= 10;
}

// Runs after a quest is completed.
kill_quest_reward()
{
	self iprintlnbold("You completed the quest!");
	self ml_give_weapon("beretta93r_zm");
}

// Should return a string which is displayed in the hud.
kill_quest_progress()
{
	return "^5" + self.kills + "^7/10";
}
