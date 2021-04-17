#!/bin/bash

set -ex

# A list of packages separated by a single space
packages="vim git lm-sensors lshw-gtk jq httpie gnome-tweaks menulibre steam-launcher"

# Install previous list of packages
sudo apt install -y ${packages}

# There's a bug with media keys. This solves the problem. Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160
# Comments line with '{ Scroll_Lock }'
sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
setxkbmap

# A list of flatpak packages separated by spaces. Use the package ID for installation.
# You may use 'flatpak search <package-name>' if you'd like to search a package name.
flatpak_packages="com.jetbrains.IntelliJ-IDEA-Ultimate com.visualstudio.code com.spotify.Client org.telegram"

# Install previous list of flatpak packages.
flatpak install -y ${flatpak_packages}

# Some custom stuff
sudo apt install radeontop

## Other custom stuff (dev)
# SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    sdk install java
fi

#NVM, NPM
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    source "$HOME/.bashrc"
  
    nvm install node
fi

