#!/bin/bash

# Location of the .bashrc file (this file will be reset and have things added to it)
BASHRC=$HOME/.bashrc
# A list of packages to install via apt separated by a single space
# You may use 'apt-cache search <package-name>' if you wanto to search packages
SO_PACKAGES="vim git lm-sensors lshw-gtk jq httpie gnome-tweaks menulibre steam-installer tmux discord virtualbox ksnip xclip wine solaar"
# A list of flatpak packages separated by spaces. Use the package ID for installation.
# A list of Gnome Extensions to install
# 1319 GSConnect
# 906  Sound Input & Output Device Chooser
# 779  Clipboard Indicator
# 4105 Notification Banner Position
GNOME_EXTENSIONS="1319 906 779 4105"
# General location of Apps
APPS_PATH=$HOME/Apps
# Sets where to install legendary (Epic Store alternative for Linux)
LEGENDARY_HOME=$APPS_PATH/legendary
# Defines Golang version to be installed
GO_VERSION=1.16.5
# IDEA Toolbox version to download
IDEA_TOOLBOX_VERSION=1.22.10970 

# Resets ~/.bashrc file to distro default. This script assumes it's the only thing editing your .bashrc file.
function reset_bashrc () {
  # Backup current .bashrc file
  cp $BASHRC $BASHRC'.'$(date +'%F_%H%M%S')'.bkp'
  # Reset .bashrc
  cp /etc/skel/.bashrc $HOME/.bashrc
}
reset_bashrc

# Install basic apt and flatpak packages
function so_packages () {
  sudo apt install -y $SO_PACKAGES
  sudo apt update -y

  # Clean up
  sudo apt autoremove -y
}
so_packages

function ides_setup () {
  TFILE=jetbrains-toolbox-${IDEA_TOOLBOX_VERSION}.tar.gz
  wget --progress=bar:noscroll -N https://download.jetbrains.com/toolbox/${TFILE}
  mkdir -p $APPS_PATH || true
  # 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
  tar -C $APPS_PATH -xzf $TFILE
  # Starting Toolbox sets it up to autostart
  $APPS_PATH/jetbrains-toolbox*/jetbrains-toolbox
}
ides_setup

# Configures autostart things
KSNIP_AUTOSTART_TEMPLATE=$(cat <<- 'EOF'
[Desktop Entry]
Name=Ksnip
Exec=ksnip
Type=Application
EOF
)
function auto_start_apps () {
  AUTOSTART_FOLDER=$HOME/.config/autostart
  # Configure KSNIP to autostart
  KSNIP_AUTOSTART_FILE=$AUTOSTART_FOLDER/ksnip.desktop
  mkdir -p $AUTOSTART_FOLDER
  touch $KSNIP_AUTOSTART_FILE
  echo "$KSNIP_AUTOSTART_TEMPLATE" > "$KSNIP_AUTOSTART_FILE"
}
auto_start_apps

# There's a bug with media keys. This works around it.
# Based on: https://askubuntu.com/questions/906723/fn-media-keys-slow-delayed-on-ubuntu-gnome-17-04/1072160#1072160
function media_keys_fix () {
  # Comments line with '{ Scroll_Lock }'
  sudo sed -i '/{ Scroll_Lock }/s/^#*/#/g' /usr/share/X11/xkb/symbols/br
  setxkbmap
}
media_keys_fix

# Configures shortcuts with xbindkeys
XBINDKEYS_TEMPLATE=$(cat <<- 'EOF'
# Workspace Up
"xte 'keydown Control_L' 'keydown Super_L' 'key Up' 'keyup Super_L' 'keyup Control_L'"
   b:9

# Workspace Down
"xte 'keydown Control_L' 'keydown Super_L' 'key Down' 'keyup Super_L' 'keyup Control_L'"
   b:8

EOF
)
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
xbindkeys_shortcuts

# Adds useful general things to .bashrc. Other functions may add additional specific things.
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
  if [[ "$1" != "" ]]; then
    echo "Opening ${URL}"
    firefox -new-window ${URL}
  else
    echo "URL copied to clipboard"
    echo $URL | xclip -sel clip
  fi;
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
function bashrc_content () {
  printf "$BASHRC_CONTENT" >> $BASHRC
}
bashrc_content

# Set Gnome settings that I like
function gnome_settings () {
  gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
}
gnome_settings

# Install Gnome extensions that I like
function gnome_extensions () {
  # TODO I'm not being able to use the GNOME_VERSION (because 40.5) on the script. Review the script later, maybe fork it
  #GNOME_VERSION=$(sudo gnome-shell --version | cut -f3 -d' ' | cut -d'.' -f1)

  TDIR=$(mktemp -d)
  TFILE=$TDIR/gnome-shell-extension-installer
  wget -O $TFILE "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
  chmod +x $TFILE

  $TFILE $GNOME_EXTENSIONS --restart-shell
}
gnome_extensions

# Install Legendary, an alternative to Epic Launcher
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
legendary_epic_store

# My tmux setup
TMUX_CONFIG=$(cat <<- 'EOF'
# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# don't rename windows automatically
set-option -g allow-rename off

# enable mouse
set -g mouse on

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

# Continuum config
set -g @continuum-restore 'on'
set -g @continuum-save-interval '1'
set -g status-right 'Continuum status: #{continuum_status}'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

EOF
)
TMUX_BASH_CONTENT=$(cat <<- 'EOF'

# TMUX as default terminal
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi
EOF
)
function tmux_setup () {
  sudo apt -y install tmux git

  rm -rf $HOME/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

  # Create config files
  printf "$TMUX_CONFIG" >> $HOME/.tmux.conf

  # This is a best effort approach to not duplicate things =/
  if ! grep -q "# TMUX as default terminal" $BASHRC; then
      # Prints bash_content to BASHRC file
      printf '%s' "$TMUX_BASH_CONTENT" >> $BASHRC
  fi

  tmux source ~/.tmux.conf
}
tmux_setup

# Install latest Java via sdkman
function java_setup () {
  # SDKMAN
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java
}
java_setup

# Install latest Node via nvm
function node_setup () {
  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    source "$HOME/.bashrc"

    nvm install node
  fi
}
node_setup

# Install specific Golang version
function golang_setup () {
  echo "Installing go v${GO_VERSION}"
  sudo rm -rf /usr/local/go
  wget --progress=bar:noscroll -N https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
  # 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
  sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

  mkdir -p $HOME/go

  if ! grep -q "/usr/local/go/bin" $BASHRC; then
      printf "\n# Golang stuff\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $BASHRC
      printf "export GOPATH=$HOME/go\n" >> $BASHRC
  fi
}
golang_setup

# Set global git user.name and user.email if not set already
function git_setup () {
  GIT_CONFIG=$(git config --list | grep 'user.name\|user.email')
  if [[ -z "$GIT_CONFIG" ]]; then
    read -p "Username for git: " GIT_USER
    read -p "Email for git: " GIT_EMAIL
    git config --global user.name "$GIT_USER"
    git config --global user.email "$GIT_EMAIL"
  fi;
}
# TODO Should I start putting interactive things here? Not sure.
#git_setup

# Bitwarden installation
function bitwarden_cli_setup () {
  TDIR=$(mktemp -d)
  TZIPFILE=$TDIR/bitwarden.zip
  DESTDIR=$HOME/.local/bin
  DESTFILE=$DESTDIR/bw
  curl -fsSL "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o $TZIPFILE
  rm $DESTFILE || true
  unzip $TZIPFILE -d $DESTDIR
  chmod +x $DESTFILE
  # TODO Should I start putting interactive things here? Not sure.
  #bw login
}
bitwarden_cli_setup

# Bitwarden app setup
function bitwarden_setup () {
  curl -fsSL "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -o $APPS_PATH
  $APPS_PATH/Bitwarde*
}
bitwarden_setup

# Install and sets up Docker
function docker_setup () {
  # Install via convenience script
  TDIR=$(mktemp -d)
  TZIPFILE=$TDIR/get-docker.sh
  curl -fsSL https://get.docker.com -o $TZIPFILE
  chmod +x $TZIPFILE
  sudo $TZIPFILE

  # Allowing $USER to run docker
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
}
# TODO This script creates a nested session
#docker_setup

source $BASHRC

