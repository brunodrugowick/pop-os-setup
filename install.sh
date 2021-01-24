#!/bin/bash

# A list of packages separated by a single space
packages="vim git lm-sensors lshw-gtk jq httpie"

# Install previous list of packages
sudo apt install -y ${packages}

# There's a bug with media keys. This solves the problem. Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160
# Comments line with '{ Scroll_Lock }'
sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
setxkbmap

# A list of flatpak packages separated by spaces. Use the package ID for installation.
# You may use 'flatpak search <package-name>' if you'd like to search a package name.
flatpak_packages="com.jetbrains.IntelliJ-IDEA-Ultimate com.visualstudio.code com.valvesoftware.Steam com.spotify.Client"

# Install previous list of flatpak packages.
flatpak install -y ${flatpak_packages}

