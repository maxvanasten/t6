#!/usr/bin/env bash
rm -rf ./mods/*

create_mod() {
	echo "[build_mods] Building mod $1 ($2)"
	mkdir ./mods/$1
	mkdir ./mods/$1/scripts
	touch ./mods/$1/mod.json

	echo "{\"name\":\"$1\",\"author\":\"HasjBlok\",\"description\":\"$3\",\"version\":\"1.0\"}" > ./mods/$1/mod.json
}

add_script() {
	echo "[build_mods] Adding script $2/$3 to mod $1"
	mkdir -p ./mods/$1/scripts/$2
	cp ./scripts/$2/$3 ./mods/$1/scripts/$2/$3
}

zip_mod() {
	echo "[build_mods] Zipping mod"
	rm -rf ./mods/$1/$1.zip
	zip -r $1.zip ./mods/$1
	mv $1.zip ./mods/$1
}

create_mod zm_tomb_challenge zm "Origins spawnroom gungame challenge."
add_script zm_tomb_challenge zm gobblegums.gsc
add_script zm_tomb_challenge zm health_and_zombie_counter.gsc
add_script zm_tomb_challenge zm/zm_tomb origins_spawnroom_challenge.gsc
zip_mod zm_tomb_challenge
