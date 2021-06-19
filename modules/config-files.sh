#!/bin/bash

# Copy config files
cp ./templates/tmux.config $HOME/.tmux.config

# Reset .bashrc
cp /etc/skel/.bashrc $HOME/.bashrc

