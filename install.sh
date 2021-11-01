#!/bin/bash

BASHRC=$HOME/.bashrc
SETUP_HOME=$(pwd)

echo -e "\nThis script is going to install the following:"
echo ""
echo -e "\tso-packages:\tinstall APT and Flatpak packages"
echo -e "\tcustom:\t\tfix bugs and other custom stuff"
echo -e "\tconfig-files:\tset configuration files for programs such as tmux and vim"
echo -e "\tjava:\t\tinstall Java things"
echo -e "\tnode:\t\tinstall Node things"
echo -e "\tgnome-settings:\tset Gnome settings that I like"
echo -e "\tgolang:\t\tinstall Golang things"
echo -e "\tbash-functions:\tinstall custom Bash functions that make my life easier"
echo -e "\tepic-store:\tinstall legendary, an alternative launcher for Epic Games"
echo -e "\ttmux:\t\tinstall and configures TMUX, TMUX Plugin Manager as well as a few plugins"
echo -e "\tdocker:\t\tinstall docker"
echo ""
echo -e "\nThis script can safelly run multiple times, but be aware it will rewrite things like your ~/.bashrc file, for example\n"

read -p "Continue? [yes/No]: " CONTINUE
if [[ "$CONTINUE" == "yes" ]]; then
	set -x

	source ./modules/so-packages.sh 
	source ./modules/custom.sh 
	source ./modules/config-files.sh 
	source ./modules/java.sh 
	source ./modules/node.sh 
	source ./modules/gnome-settings.sh 
	source ./modules/golang.sh 
	source ./modules/bash-functions.sh 
	source ./modules/epic-store.sh
	source ./modules/tmux.sh
	# TODO Docker installation creates another session or something, need to fix 
	#source ./modules/docker.sh

	# Source .bashrc at the end
	source $BASHRC
else 
	echo -e "Aborting execution.\n\nYou may want to take a look at the modules folder and use some of the scripts. You may need to set BASHRC and SETUP_HOME before executing them.\n\nBASHRC=/home/<user>/.bashrc SETUP_HOME=$(pwd) ./modules/so-packages.sh\n"
fi

