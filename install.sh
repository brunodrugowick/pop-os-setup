#!/bin/bash

set -ex

BASHRC=$HOME/.bashrc

source ./modules/so-packages.sh
source ./modules/custom.sh
source ./modules/config-files.sh
source ./modules/java.sh
source ./modules/node.sh
source ./modules/gnome-settings.sh
source ./modules/golang.sh

# Source .bashrc at the end
source $BASHRC

