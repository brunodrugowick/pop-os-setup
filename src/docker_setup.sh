#!/bin/bash

# Install and sets up Docker
function docker_setup () {
  # Install via convenience script
  TDIR=$(mktemp -d)
  TZIPFILE=$TDIR/get-docker.sh
  curl -fsSL https://get.docker.com -o $TZIPFILE
  chmod +x $TZIPFILE
  sudo $TZIPFILE

  # Allowing $USER to run docker
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
}
# TODO This script creates a nested session
docker_setup
