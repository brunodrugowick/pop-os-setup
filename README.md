# Pop!_OS fresh install

This script just makes it easier to install software after a fresh installation of the OS.

This is a work in progress (and will always be), but the script is designed to run multiple times without adverse effects.

# TODO

Looks like now I need a list to keep track of everything I want to do/fix:

- [ ] Add a Changelog
- [ ] Add config file (ignored by git and its function is to help the script to be totally unassisted)
- [ ] Set cronjob to update repo and re-run script when new data is available
- [ ] Add a wine specific section/function
- [ ] Set `git` properties (name and email) - this might require a set of things to asked and then re-used for other runs
- [ ] Fix Telegram installation (is asking for the package that I want between 2)
- [ ] Use a huge script file with functions, maybe it's simpler and easier (?)
- [ ] Move to Makefile to address dependencies better (?)
- [ ] Fix installation of Gnome Extensions (they're installed but not enabled)
- [ ] Set Gnome preferences (including Pop OS specifics) - might require some digging
- [X] ~~Fix location of Go installation file~~
- [X] ~~Fix SDKMAN to DO NOT ASK anything to the user~~ It didn't ask last time, IIRC.
- [X] ~~Fix/add Epic Games (via Legendary) things (currently it's kind of incomplete)~~
- [ ] Review docker install and decide if I should keep
    
