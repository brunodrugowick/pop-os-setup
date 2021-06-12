#!/bin/bash

VERSION=1.16.5

set -x

echo "Installing go v${VERSION}"
sudo rm -rf /usr/local/go
wget https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz

# Append Golang things to ~/.bashrc
BASHRC=$HOME/.bashrc

if ! grep -q "/usr/local/go/bin" $HOME/.bashrc; then
    printf "\n# Golang stuff\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $BASHRC 
fi

