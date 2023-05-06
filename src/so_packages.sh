#!/bin/bash

# A list of packages to install via apt separated by a single space
# You may use 'apt-cache search <package-name>' if you wanto to search packages
SO_PACKAGES="git lm-sensors jq httpie gnome-tweaks steam-installer tmux discord virtualbox ksnip xclip wine solaar sqlite3"

# Install basic apt and flatpak packages
sudo apt install -y $SO_PACKAGES
sudo apt update -y

# Clean up
sudo apt autoremove -y

