#!/bin/bash

# A list of packages to install via apt separated by a single space
# You may use 'apt-cache search <package-name>' if you wanto to search packages
BASE_PACKAGES="curl wget git build-essential unzip ca-certificates gnupg"
SO_PACKAGES="lm-sensors jq steam-installer tmux discord xclip solaar sqlite3"

# Install basic apt and flatpak packages
sudo apt update -y
sudo apt install -y $SO_PACKAGES

# Clean up
sudo apt autoremove -y

