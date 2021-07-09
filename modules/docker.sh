#!/bin/bash

# Install via convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Allowing $USER to run docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

