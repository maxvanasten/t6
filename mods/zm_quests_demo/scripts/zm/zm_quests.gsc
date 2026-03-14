#include common_scripts\utility;
#include scripts\zm\maxlib;

init_hud()
{
	self.zm_quests_hud_name = ml_create_text(1.25, -250, 140, "");
	self.zm_quests_hud_desc = ml_create_text(1.25, -250, 155, "");
	self.zm_quests_hud_prog = ml_create_text(1.25, -250, 170, "");
}

add_quest(quest_id, quest_name, quest_desc, quest_check, quest_reward, quest_prog)
{
	if (!isdefined(self.zm_quests_hud_name)) {
		self thread init_hud();
	}
	if (!isdefined(self.zm_quests)) {
		self.zm_quests = [];
	}

	quest = spawnstruct();
	quest.id = quest_id;
	quest.name = quest_name;
	quest.desc = quest_desc;
	quest.check = quest_check;
	quest.reward = quest_reward;

	if (isdefined(quest_prog)) {
		quest.prog = quest_prog;
	}

	self.zm_quests[self.zm_quests.size] = quest;
}

start_quest(index)
{
	if (!isdefined(self.zm_quests)) {
		return;
	}

	if (self.zm_quests.size <= index) {
		return;
	}

	self.current_quest = self.zm_quests[index];
	self.current_quest_index = index;

	self.zm_quests_hud_name ml_update_text("^5"+self.current_quest.name);
	self.zm_quests_hud_desc ml_update_text(self.current_quest.desc);
}

check_quest()
{
	if (!isdefined(self.current_quest)) {
		return;
	}

	if (isdefined(self.current_quest.prog)) {
		prog = self [[ self.current_quest.prog ]]();
		self.zm_quests_hud_prog ml_update_text(prog);	
	}

	quest_complete = self [[ self.current_quest.check ]]();

	if (quest_complete) {
		self thread [[ self.current_quest.reward ]]();

		if (self.current_quest_index+1 < self.zm_quests.size) {
			self thread start_quest(self.current_quest_index+1);
		} else {
			self.current_quest = undefined;
			self.zm_quests_hud_name ml_update_text("");
			self.zm_quests_hud_desc ml_update_text("^3All quests complete!");
			self.zm_quests_hud_prog ml_update_text("");
		}
	}
}
