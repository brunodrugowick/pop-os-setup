#!/bin/bash

# Install a rootless container stack while keeping a Docker-compatible CLI.
function docker_setup () {
  sudo apt update -y
  sudo apt install -y podman podman-docker podman-compose uidmap slirp4netns

  mkdir -p "$HOME/.config/containers"

  if ! grep -q "# Podman Docker compatibility" "$BASHRC"; then
    printf "\n# Podman Docker compatibility\n" >> "$BASHRC"
    printf "export DOCKER_HOST=unix:///run/user/\$(id -u)/podman/podman.sock\n" >> "$BASHRC"
  fi

  systemctl --user daemon-reload >/dev/null 2>&1 || true
  systemctl --user enable --now podman.socket >/dev/null 2>&1 || true
}

docker_setup
