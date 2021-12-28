#!/bin/bash

CONFIG=$(cat <<- 'EOF'
# This variable alone controls whether the script runs or not. 'yes' continues the script, anything else aborts it.
INSTALL=yes
# Location of the .bashrc file (this file will be reset and have things added to it)
BASHRC=$HOME/.bashrc
# A list of packages to install via apt separated by a single space
# You may use 'apt-cache search <package-name>' if you wanto to search packages
SO_PACKAGES="vim git lm-sensors lshw-gtk jq httpie gnome-tweaks menulibre steam-installer tmux direnv discord virtualbox ksnip xclip wine solaar"
# A list of flatpak packages separated by spaces. Use the package ID for installation.
# You may use 'flatpak search <package-name>' if you want to search packages.
FLATPAK_PACKAGES="com.jetbrains.IntelliJ-IDEA-Ultimate com.jetbrains.GoLand com.spotify.Client"
# Sets where to install legendary (Epic Store alternative for Linux)
LEGENDARY_HOME=$HOME/Apps/legendary

EOF
)

KSNIP_AUTOSTART_TEMPLATE=$(cat <<- 'EOF'
[Desktop Entry]
Name=Ksnip
Exec=ksnip
Type=Application
EOF
)

XBINDKEYS_TEMPLATE=$(cat <<- 'EOF'
# Workspace Up
"xte 'keydown Control_L' 'keydown Super_L' 'key Up' 'keyup Super_L' 'keyup Control_L'"
   b:9

# Workspace Down
"xte 'keydown Control_L' 'keydown Super_L' 'key Down' 'keyup Super_L' 'keyup Control_L'"
   b:8

EOF
)

BASHRC_CONTENT=$(cat <<- 'EOF'

# Re-set PS1 to my liking
function parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;34m\]\w\[\033[00m\] $(parse_git_branch) \n >> '
else
    PS1='\w $(parse_git_branch) \n >> '
fi
unset color_prompt force_color_prompt

# github-compare
function gh-compare () {
    if [ ! -d .git ]; then
        echo "Not a git repository"
        return
    fi;

    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo "Current branch is ${CURRENT_BRANCH}"
    MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    echo "Main branch is ${MAIN_BRANCH}"

    if [[ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]]; then
	echo "Already in ${MAIN_BRANCH}, go to another branch to compare"
	return
    fi;

    GIT_URL=$(git config --local remote.origin.url | cut -d "@" -f 2 | cut -d "." -f "1-2" | sed "s/:/\//")
    URL="https://${GIT_URL}/compare/${MAIN_BRANCH}...${CURRENT_BRANCH}"
    echo "Opening ${URL}"

    firefox -new-window ${URL}
}
export -f gh-compare

# Uses a temp file to copy from tmux buffer to default buffer
# Thanks to https://github.com/derelbenkoenig/bash-fu/blob/master/bin/tmuxclip
function cliptmux () {
	TEMP_FILE=$(mktemp)
	tmux save-buffer $TEMP_FILE && xclip -sel clip <$TEMP_FILE
}
export -f cliptmux

EOF
)

LEGENDARY_HELPER_FUNCTION=$(cat <<- 'EOF'

# get Epic game name (can be an UUID) to use with Legendary (alternative Epic Games store)
get-epic-game-name () {
  APP_NAME=$(legendary list-games | grep $1 | awk -F'App name: ' '{print $2}' | awk -F' ' '{print $1}')
  if [[ "$APP_NAME" != "" ]]; then
    echo $APP_NAME
  fi;
}
export -f get-epic-game-name

# launches a game with Legendary by its name
game () {
  APP_NAME=$(legendary list-games | grep $1 | awk -F'App name: ' '{print $2}' | awk -F' ' '{print $1}')
  if [[ "$APP_NAME" != "" ]]; then
    legendary launch $APP_NAME
  fi;
}
export -f game
EOF
)

# Sets up the configuration file for this setup by copying from the template file
function setup_script () {
  if test -f "$POP_SETUP_CONFIG_FILE"; then
    echo "Using config file $POP_SETUP_CONFIG_FILE"
  else
    echo "Creating config file $POP_SETUP_CONFIG_FILE"
    echo "$CONFIG" > "$POP_SETUP_CONFIG_FILE"
  fi
  . "$POP_SETUP_CONFIG_FILE"
}

# Install basic apt and flatpak packages
function so_packages () {
  sudo apt update -y
  sudo apt upgrade -y

  # direnv requires integration with bash
  if ! grep -q "direnv hook bash" $BASHRC; then
      printf "\n# direnv stuff\neval \"\$(direnv hook bash)\"\n" >> $BASHRC
  fi

  sudo apt install -y $SO_PACKAGES
  flatpak install -y $FLATPAK_PACKAGES

  # Clean up
  sudo apt autoremove -y
}

# There's a bug with media keys. This works around it.
# Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160
function media_keys_fix () {
  # Comments line with '{ Scroll_Lock }'
  sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
  setxkbmap
}

# Configures autostart things
function auto_start_apps () {
  AUTOSTART_FOLDER=$HOME/.config/autostart
  # Configure ksnip to autostart
  KSNIP_AUTOSTART_FILE=$AUTOSTART_FOLDER/ksnip.desktop
  mkdir -p $AUTOSTART_FOLDER
  touch $KSNIP_AUTOSTART_FILE
  echo "$KSNIP_AUTOSTART_TEMPLATE" > "$KSNIP_AUTOSTART_FILE"
}

function xbindkeys_shortcuts () {
  # Setup xbindkeys shortcut for my mouse (MX Master 3)
  ## from https://support.system76.com/articles/custom-mouse-buttons/
  XBINDKEYS_RC_FILE=$HOME/.xbindkeysrc
  sudo apt install -y xbindkeys xautomation
  rm $XBINDKEYS_RC_FILE || true
  echo "$XBINDKEYS_TEMPLATE" > "$XBINDKEYS_RC_FILE"
  killall xbindkeys || true
  xbindkeys
}

function reset_bashrc () {
  # Backup current .bashrc file
  cp $BASHRC $BASHRC'.'$(date +'%F_%H%M%S')'.bkp'
  # Reset .bashrc
  cp /etc/skel/.bashrc $HOME/.bashrc
}

function gnome_settings () {
  gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
}

function gnome_extensions () {
  # TODO I'm not being able to use the GNOME_VERSION (because 40.5) on the script. Review the script later, maybe fork it
  #GNOME_VERSION=$(sudo gnome-shell --version | cut -f3 -d' ' | cut -d'.' -f1)

  TDIR=$(mktemp -d)
  TFILE=$TDIR/gnome-shell-extension-installer
  wget -O $TFILE "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
  chmod +x $TFILE

  # 1319 GSConnect
  # 906  Sound Input & Output Device Chooser
  # 779  Clipboard Indicator
  # 4105 Notification Banner Position
  $TFILE 1319 906 779 4105 --restart-shell
}

function bashrc_content () {
  printf "$BASHRC_CONTENT" >> $BASHRC
}

function legendary_epic_store () {
  sudo apt -y install python3 python3-requests python3-setuptools-git python3-pip
  mkdir -p $LEGENDARY_HOME || true
  git clone https://github.com/derrod/legendary.git $LEGENDARY_HOME
  if [ $? -eq 0 ]
  then
      echo "Cloned new repo"
  else
      echo "Legendary already installed. Updating..."
      ( cd $LEGENDARY_HOME && git pull )
  fi
  pip install $LEGENDARY_HOME
  # It appears that the installation doesn't create the config file, so, creating an empty one.
  echo "" >> $HOME/.config/legendary/config.ini

  # This is a best effort approach to not duplicate things =/
  if ! grep -q "export -f get-epic-game-name" $BASHRC; then
      printf "$LEGENDARY_HELPER_FUNCTION" >> $BASHRC
  fi
}

# The script itself should go from here to the end of the file, let's keep it short and neat.
POP_SETUP_CONFIG_FILE=$HOME/.pop-os-setup.config
if [ $# -gt 0 ]; then
  POP_SETUP_CONFIG_FILE=$1
fi

setup_script

if [[ "$INSTALL" == "yes" ]]; then
  reset_bashrc

  so_packages
  media_keys_fix
  auto_start_apps
  xbindkeys_shortcuts

  bashrc_content

  gnome_settings
  gnome_extensions

  legendary_epic_store
  source ./modules/tmux.sh

  source ./modules/java.sh
  source ./modules/node.sh
  source ./modules/golang.sh
  source ./modules/docker.sh

	source $BASHRC
else
	echo -e "Aborting execution."
fi
