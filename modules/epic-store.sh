#!/bin/bash

LEGENDARY_HOME=$HOME/Apps/legendary

sudo apt -y install python3 python3-requests python3-setuptools-git python3-pip
mkdir -p $LEGENDARY_HOME
cd $LEGENDARY_HOME
git clone https://github.com/derrod/legendary.git .
if [ $? -eq 0 ] 
then 
    echo "Cloned new repo" 
else 
    echo "Legendary already installed. Updating..."
    git pull
fi
pip install .
# It appears that the installation doesn't create the config file, so, creating an empty one.
echo "" >> $HOME/.config/legendary/config.ini

BASHRC=$HOME/.bashrc
# This is a best effort approach to not duplicate things =/
if ! grep -q "export -f get-epic-game-name" $BASHRC; then
    cat ./templates/epic-store-bash-function.sh.template >> $BASHRC
fi

# restore original directory
cd -
