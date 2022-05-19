#!/bin/bash

if [ -z "$GNOME_EXTENSIONS" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script

  # 1319 GSConnect
  # 906  Sound Input & Output Device Chooser
  # 779  Clipboard Indicator
  # 4105 Notification Banner Position
  # 1262 Bing Wallpaper
  # 3851 Workspaces Bar
  GNOME_EXTENSIONS="1319 906 779 4105 1262 3851"
fi

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
