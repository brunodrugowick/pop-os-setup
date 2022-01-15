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
source $SCRIPT_HOME/tmux.sh

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
  TFILE=$APPS_PATH/Bitwarden.AppImage
  curl -fsSL "https://vault.bitwarden.com/download/?app=desktop&platform=linux" -o $TFILE
  chmod +x $TFILE
  $TFILE &
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

