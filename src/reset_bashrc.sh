#!/bin/bash

# Resets ~/.bashrc file to distro default. This script assumes it's the only thing editing your .bashrc file.

# Backup current .bashrc file
cp $BASHRC $BASHRC'.'$(date +'%F_%H%M%S')'.bkp'
# Reset .bashrc
cp /etc/skel/.bashrc $HOME/.bashrc

