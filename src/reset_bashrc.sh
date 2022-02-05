#!/bin/bash

if [ -z "$BASHRC" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script
  BASHRC=$HOME/.bashrc
fi

# Resets ~/.bashrc file to distro default. This script assumes it's the only thing editing your .bashrc file.

# Backup current .bashrc file
cp $BASHRC $BASHRC'.'$(date +'%F_%H%M%S')'.bkp'
# Reset .bashrc
cp /etc/skel/.bashrc $HOME/.bashrc

