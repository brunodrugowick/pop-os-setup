#!/bin/bash

GO_VERSION=1.16.5
TEMP_FOLDER=$(mktemp -d)

echo "Installing go v${GO_VERSION}"
sudo rm -rf /usr/local/go
cd $TEMP_FOLDER
wget --progress=bar:noscroll -N https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz
# 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

mkdir -p $HOME/go

if ! grep -q "/usr/local/go/bin" $BASHRC; then
    printf "\n# Golang stuff\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $BASHRC
    printf "export GOPATH=$HOME/go\n" >> $BASHRC
fi

# Remove temp folder
rm -rf $TEMP_FOLDER

# Go back to setup directory
cd $SETUP_HOME