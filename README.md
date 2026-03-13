# My T6 mods/scripts

This is a centralized collection of my t6 mods/scripts.

## Requests

I'm always interested in fun mod ideas so that I can improve my modding skills, so if you have suggestions, please create an Issue on this repo or contact me some other way (good luck).

## Downloading mods/scripts

Raw scripts can be found in `./scripts`.

Mods are available as zip files in `./dist`:

| Mod | Description | Download |
| --- | --- | --- |
| zm_randomizer | Randomized start for zombies. | [Download zip](https://github.com/maxvanasten/t6/raw/refs/heads/master/dist/zm_randomizer.zip) |
| zm_tomb_challenge | Origins spawnroom gungame challenge. | [Download zip](https://github.com/maxvanasten/t6/raw/refs/heads/master/dist/zm_tomb_challenge.zip) |

To refresh `./dist` after mod changes, run:

`./package_mods.sh`

## Installing mods

Mods can be installed by moving the mod folder into `%localappdata%\Plutonium\storage\t6\mods`. You can then start the game and click on 'mods' and select the mod you want to play.

## Installing scripts

Scripts can be installed by moving the script (.gsc file) into `%localappdata%\Plutonium\storage\t6\scripts`. Scripts under "mp" will run on any multiplayer game, scripts under "zm" will run on any zombies game, scripts under "zm/zm_tomb" wil run on any zombies game on the map zm_tomb etc.
