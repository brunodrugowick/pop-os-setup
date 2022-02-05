#!/bin/bash

# There's a bug with media keys. This works around it.
# Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160

# Comments line with '{ Scroll_Lock }'
sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
setxkbmap
