#!/bin/bash

GO_VERSION=1.16.5

echo "Installing go v${GO_VERSION}"
sudo rm -rf /usr/local/go
wget --progress=bar:noscroll -N https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

# Append Golang things to ~/.bashrc
BASHRC=$HOME/.bashrc

mkdir -p ~/go

if ! grep -q "/usr/local/go/bin" $HOME/.bashrc; then
    printf "\n# Golang stuff\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $BASHRC
    printf "export GOPATH=$HOME/go\n" >> $BASHRC
fi

