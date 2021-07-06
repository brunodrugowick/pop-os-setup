#!/bin/bash

BASHRC=$HOME/.bashrc
SETUP_HOME=$(pwd)

if [[ "$#" -eq 0 ]]; then
	echo -e "\nUse with 'all' to install everything or add one or more of the following parameters:"
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
	echo ""

	exit 1
fi

set -ex

while [[ "$#" -gt 0 ]]; do
	case $1 in
		# TODO better 'all' handling - if used after other params it reinstall some packages
		all)
			set -- so-packages custom config-files java node gnome-settings golang bash-functions epic-store
			;;
		so-packages) 
			source ./modules/so-packages.sh 
			;;
		custom) 
			source ./modules/custom.sh 
			;;
		config-files) 
			source ./modules/config-files.sh 
			;;
		java) 
			source ./modules/java.sh 
			;;
		node) 
			source ./modules/node.sh 
			;;
		gnome-settings) 
			source ./modules/gnome-settings.sh 
			;;
		golang) 
			source ./modules/golang.sh 
			;;
		bash-functions) 
			source ./modules/bash-functions.sh 
			;;
		epic-store)
			source ./modules/epic-store.sh
			;;
		*) 
			echo "Unknown parameter: $1. Ignoring and continuing..."
			;;
	esac
	shift # on to the next parameter
done

# Source .bashrc at the end
source $BASHRC

