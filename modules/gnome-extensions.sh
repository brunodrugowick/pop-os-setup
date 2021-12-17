#!/bin/bash

cd $(mktemp -d)
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer

./gnome-shell-extension-installer 1319 # GSConnect
./gnome-shell-extension-installer 906  # Sound Input & Output Device Chooser
./gnome-shell-extension-installer 779  # Clipboard Indicator

cd -
