#!/bin/bash

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
