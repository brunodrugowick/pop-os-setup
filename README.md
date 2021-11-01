# Pop!_OS fresh install

This script just makes it easier to install software after a fresh install of the OS.

This is a work in progress, but the script is designed to run multiple times without adverse effects.

# TODO

Looks like now I need a list to keep track of everything I want to do/fix:

- [ ] Add a Changelog
- [X] ~~Fix location of Go installation file~~
- [ ] Fix SDKMAN to DO NOT ASK anything to the user
- [ ] Fix/add Epic Games (via Legendary) things (currently it's kind of incomplete)
- [ ] Move to Makefile to address dependencies better
- [ ] Maybe allowing to run modules separately was not a good idea. After all, this
  is a setup script, the idea is to run once after SO installation. So, to keep it 
  simple, one idea is:
    - [ ] Make `install.sh` a `install-all.sh`; and
    - [ ] Instruct usage of individual "modules" (if/when necessary) and do a "best 
      effort" approach to make this possible.
      
