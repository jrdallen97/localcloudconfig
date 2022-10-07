# localcloudconfig

Steam's cloud saves service leaves it up to the developer which files to sync to the cloud. Sometimes, developers choose to synchronise settings files in addition to saves, meaning that things like graphical settings are remembered across computers. When this happens for computers with different specs, sucn a gaming PC and a Steam Deck, you end up having to manually change settings each time you switch device.

This script allows you to maintain a local version of your settings for specific games, effectively preventing Steam from backing them up. It was inspired by tmplshdw's [cloud_config_workaround](https://github.com/tmplshdw/cloud_config_workaround), but unlike that script it doesn't need to be installed on each machine to work.

## Usage

Theoretically this script should work on any Linux machine (?), but I'll be assuming that you're installing it on a Steam Deck for simplicity.

1. Download this repo to your deck (e.g. with `git clone`). I installed it to `/home/deck/localcloudconfig`.
2. 

## Supported games

I'll add more games as and when I find games with issues. Feel free to PR/fork and add your own games.

- The Witcher 3

## How it works

Before the game launches, the script copies the existing config file to a backup location, then copies a local version of the file back into the game's config path. Then we launch the game, and once it exits move the local config back to a safe location, and finally replace the game config with the backed up version from earlier to prevent Steam from syncing the local version to the cloud.
