#!/bin/bash

SCRIPT_HOME=$(dirname "$0")

source $SCRIPT_HOME/config.properties

source $SCRIPT_HOME/reset_bashrc.sh
source $SCRIPT_HOME/so_packages.sh
source $SCRIPT_HOME/ide.sh
source $SCRIPT_HOME/auto_start_apps.sh
source $SCRIPT_HOME/media_keys_fix.sh
source $SCRIPT_HOME/xbindkeys_shortcuts.sh
source $SCRIPT_HOME/bashrc_content.sh
source $SCRIPT_HOME/gnome_config.sh
source $SCRIPT_HOME/legendary.sh
SOURCE $SCRIPT_HOME/steam_csgo_fix.sh
source $SCRIPT_HOME/tmux.sh
source $SCRIPT_HOME/setup_programming.sh
source $SCRIPT_HOME/bitwarden.sh
source $SCRIPT_HOME/docker_setup.sh

source $BASHRC

