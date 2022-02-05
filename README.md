# Pop!_OS fresh install

Collection of scripts to help with a new machine setup or to maintain some things. 
There's a lot of repetition, but I chose it because this way I can use the scripts separately.

To run:

```shell
git clone https://github.com/brunodrugowick/pop-os-setup ~/pop-os-setup
~/pop-os-setup/install-all.sh
```

This is a work in progress (and will always be), but the script is designed to run multiple times without adverse effects.

# TODO

Looks like now I need a list to keep track of everything I want to do/fix:

- [X] ~~Add a Changelog~~
- [X] ~~Add some software: bitwarden, bottles ...~~ Didn't add Bottles, though.
- [X] ~~Add config file (ignored by git and its function is to help the script to be totally unassisted)~~ Config file is created in the user home
- [X] ~~Automate version release on GitHub based on the Changelog~~
- [ ] Set cronjob to update repo and re-run script when new data is available
- [ ] Add a wine specific section/function
- [ ] Set `git` properties (name and email) - this might require a set of things to asked and then re-used for other runs
- [X] ~~Fix Telegram installation (is asking for the package that I want between 2)~~ I just removed Telegram
- [X] ~~Use a huge script file with functions, maybe it's simpler and easier (?)~~ It wasn't and I'm back to separated scripts being sourced. ¯\_(ツ)_/¯
- [ ] Move to Makefile to address dependencies better (?)
- [ ] Fix installation of Gnome Extensions (they're installed but not enabled)
- [ ] Set Gnome preferences (including Pop OS specifics) - might require some digging
- [X] ~~Fix location of Go installation file~~
- [X] ~~Fix SDKMAN to DO NOT ASK anything to the user~~ It didn't ask last time, IIRC.
- [X] ~~Fix/add Epic Games (via Legendary) things (currently it's kind of incomplete)~~
- [X] ~~Review docker install and decide if I should keep~~ Kept for now
    
