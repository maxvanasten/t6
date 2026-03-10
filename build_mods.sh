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

add_bundled_script() {
	echo "[build_mods] Bundling and adding script $2 to $1"
	input_file=./scripts/$2/$3
	lib_file=./scripts/$4
	mkdir -p ./mods/$1/scripts/$2
	output_file=./mods/$1/scripts/$2/$3
	touch $output_file
	cat $input_file > $output_file
	cat $lib_file >> $output_file
}

create_mod zm_tomb_challenge zm "Origins spawnroom gungame challenge."
add_script zm_tomb_challenge zm gobblegums.gsc
add_script zm_tomb_challenge zm health_and_zombie_counter.gsc
add_bundled_script zm_tomb_challenge zm/zm_tomb origins_spawnroom_challenge.gsc zm/maxlib.gsc
zip_mod zm_tomb_challenge
