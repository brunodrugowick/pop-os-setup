#!/bin/bash

# SDKMAN (Java)
if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    curl -s "https://get.sdkman.io" | bash
fi
source "$HOME/.sdkman/bin/sdkman-init.sh"
export sdkman_auto_answer=true
if ! sdk current java >/dev/null 2>&1; then
    sdk install java
fi
if ! grep -q "# SDKMAN stuff" $BASHRC; then
    printf "\n# SDKMAN stuff\n" >> $BASHRC
    printf "source %s/.sdkman/bin/sdkman-init.sh\n" "$HOME" >> $BASHRC
fi;

# Golang
echo "Installing go v${GO_VERSION}"
sudo rm -rf /usr/local/go
wget --progress=bar:noscroll -N https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
# 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
mkdir -p $HOME/go
if ! grep -q "# Golang stuff" $BASHRC; then
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
  git config --global init.defaultBranch main
  git config --global pull.rebase false
  git config --global core.editor "vim"
fi;

# Jekyll (for GitHub Pages, from official docs)
sudo apt install -y ruby-full build-essential zlib1g-dev
if ! grep -q '# Install Ruby Gems to ~/gems' "$BASHRC"; then
  echo '' >> "$BASHRC"
  echo '# Install Ruby Gems to ~/gems' >> "$BASHRC"
  echo 'export GEM_HOME="$HOME/gems"' >> "$BASHRC"
  echo 'export PATH="$HOME/gems/bin:$PATH"' >> "$BASHRC"
fi
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
gem install --no-document jekyll bundler
