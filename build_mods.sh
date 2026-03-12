#!/usr/bin/env bash
rm -rf ./mods/*

create_mod() {
	mod_name=$1
	mod_desc=$2

	echo "[build_mods] Building mod $mod_name"
	mkdir ./mods/$mod_name
	mkdir ./mods/$mod_name/scripts
	touch ./mods/$mod_name/mod.json

	echo "{\"name\":\"$mod_name\",\"author\":\"HasjBlok\",\"description\":\"$mod_desc\",\"version\":\"1.0\"}" > ./mods/$mod_name/mod.json
}

add_script() {
	mod_name=$1
	script_path=$2
	output_path="${3:-$2}"

	mkdir -p "./mods/$mod_name/scripts/$(dirname $output_path)"
	cat ./scripts/$script_path > ./mods/$mod_name/scripts/$output_path
}

create_mod zm_tomb_challenge "Origins spawnroom gungame challenge."
add_script zm_tomb_challenge zm/maxlib.gsc zm/zm_tomb/maxlib.gsc
add_script zm_tomb_challenge zm/gobblegums.gsc zm/zm_tomb/gobblegums.gsc
add_script zm_tomb_challenge zm/zm_tomb/challenge.gsc zm/zm_tomb/challenge.gsc
add_script zm_tomb_challenge zm/health_and_zombie_counter.gsc

create_mod zm_randomizer "Randomized start for zombies."
add_script zm_randomizer zm/maxlib.gsc
add_script zm_randomizer zm/random_loadout.gsc
