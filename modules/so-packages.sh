#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

# A list of packages separated by a single space
packages="vim git lm-sensors lshw-gtk jq httpie gnome-tweaks menulibre steam-installer tmux direnv discord virtualbox"

# direnv requires integration with bash
if ! grep -q "direnv hook bash" $HOME/.bashrc; then
    printf "\n# direnv stuff\neval \"\$(direnv hook bash)\"\n" >> $BASHRC
fi

# Install previous list of packages
sudo apt install -y ${packages}

# A list of flatpak packages separated by spaces. Use the package ID for installation.
# You may use 'flatpak search <package-name>' if you'd like to search a package name.
flatpak_packages="com.jetbrains.IntelliJ-IDEA-Ultimate com.jetbrains.GoLand com.visualstudio.code com.spotify.Client org.telegram"

# Install previous list of flatpak packages.
flatpak install -y ${flatpak_packages}

# Some custom stuff
sudo apt install radeontop

# Clean up
sudo apt autoremove -y

