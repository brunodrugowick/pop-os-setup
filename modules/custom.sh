#!/bin/bash

# There's a bug with media keys. This solves the problem. Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160
# Comments line with '{ Scroll_Lock }'
sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
setxkbmap

# Configure ksnip to start
AUTOSTART_FOLDER=$HOME/.config/autostart
mkdir -p $AUTOSTART_FOLDER
cp $SETUP_HOME/templates/ksnip-autostart.template $AUTOSTART_FOLDER/ksnip.desktop

