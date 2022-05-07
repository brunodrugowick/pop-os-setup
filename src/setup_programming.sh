#!/bin/bash

if [ -z "$GO_VERSION" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script

  BASHRC=$HOME/.bashrc
  GO_VERSION=1.18.1
fi

# SDKMAN (Java)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java

# NVM (Node)
NVM_VERSION="v0.39.1"
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  source "$HOME/.bashrc"
  nvm install node
fi;

# Golang
echo "Installing go v${GO_VERSION}"
sudo rm -rf /usr/local/go
wget --progress=bar:noscroll -N https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
# 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
mkdir -p $HOME/go
if ! grep -q "/usr/local/go/bin" $BASHRC; then
    printf "\n# Golang stuff\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $BASHRC
    printf "export GOPATH=$HOME/go\n" >> $BASHRC
fi;

# GIT
GIT_USER="Bruno Drugowick"
GIT_EMAIL="bruno.drugowick@gmail.com"
GIT_CONFIG=$(git config --list | grep 'user.name\|user.email')
if [[ -z "$GIT_CONFIG" ]]; then
  #read -p "Username for git: " GIT_USER
  #read -p "Email for git: " GIT_EMAIL
  git config --global user.name "$GIT_USER"
  git config --global user.email "$GIT_EMAIL"
fi;

# Jekyll (for GitHub Pages, from official docs)
sudo apt install ruby-full build-essential zlib1g-dev
echo '' >> ~/.bashrc
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
gem install jekyll bundler

