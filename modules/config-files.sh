#!/bin/bash

# Copy config files
cp ./templates/tmux.config $HOME/.tmux.config

# Reset .bashrc
cp /etc/skel/.bashrc $HOME/.bashrc

# Append direnv things to ~/.bashrc
if ! grep -q "direnv hook bash" $HOME/.bashrc; then
    printf "\n# direnv stuff\neval \"\$(direnv hook bash)\"\n" >> $BASHRC
fi

