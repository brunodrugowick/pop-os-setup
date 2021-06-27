#!/bin/bash

sudo apt -y install python3 python3-requests python3-setuptools-git
cd $(mktemp -d)
git clone https://github.com/derrod/legendary.git
cd legendary
pip install .
# It appears that the installation doesn't create the config file, so, creating an empty one.
echo "" >> /home/drugo/.config/legendary/config.ini

# restore original directory
cd $SETUP_HOME
# TODO this function is not ready, actually... also, I have to centralize adding things to $BASHRC 
#cat ./templates/epic-store-bash-function.template >> $BASHRC

