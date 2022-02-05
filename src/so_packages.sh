#!/bin/bash

if [ -z "$SO_PACKAGES" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script
  SO_PACKAGES="vim git lm-sensors lshw-gtk jq httpie gnome-tweaks menulibre steam-installer tmux discord virtualbox ksnip xclip wine solaar"
fi

# Install basic apt and flatpak packages
sudo apt install -y $SO_PACKAGES
sudo apt update -y

# Clean up
sudo apt autoremove -y

