#!/bin/bash

# TODO I'm not being able to use the GNOME_VERSION (because 40.5) on the script. Review the script later, maybe fork it
#GNOME_VERSION=$(sudo gnome-shell --version | cut -f3 -d' ' | cut -d'.' -f1)

cd $(mktemp -d)
wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
chmod +x gnome-shell-extension-installer

# 1319 GSConnect
# 906  Sound Input & Output Device Chooser
# 779  Clipboard Indicator
# 4105 Notification Banner Position
./gnome-shell-extension-installer 1319 906 779 4105 --restart-shell

cd -
