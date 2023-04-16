#!/bin/bash

# My tmux setup
VIM_CONFIG=$(cat <<- 'EOF'
set tabstop=8 softtabstop=0
set shiftwidth=4 smarttab expandtab
set number
EOF
)

sudo apt -y install vim

rm -f "$HOME"/.vimrc

# Create config files
printf '%s' "$VIM_CONFIG" > "$HOME"/.vimrc

