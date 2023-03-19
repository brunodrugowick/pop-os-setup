#!/bin/bash

# Set Gnome settings that I like
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

# Install Gnome extensions that I like
# TODO I'm not being able to use the GNOME_VERSION (because 40.5) on the script. Review the script later, maybe fork it
#GNOME_VERSION=$(sudo gnome-shell --version | cut -f3 -d' ' | cut -d'.' -f1)
TDIR=$(mktemp -d)
TFILE=$TDIR/gnome-shell-extension-installer
wget -O "$TFILE" "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x "$TFILE"
for EXTENSION in ${GNOME_EXTENSIONS}; do
  $TFILE "$EXTENSION"
done
# Restart Gnome Shell
killall -3 gnome-shell
