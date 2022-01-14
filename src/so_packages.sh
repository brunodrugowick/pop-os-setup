#!/bin/bash

# Install basic apt and flatpak packages
sudo apt install -y $SO_PACKAGES
sudo apt update -y

# Clean up
sudo apt autoremove -y

