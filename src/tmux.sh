#!/bin/bash

# My tmux setup
TMUX_CONFIG=$(cat <<- 'EOF'
# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# don't rename windows automatically
set-option -g allow-rename off

# enable mouse
set -g mouse on

# Pane name
set -g pane-border-status top
set -g pane-border-format " [ ###P #T ] "

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'roosta/tmux-pop'
set -g @plugin 'tmux-plugin/tmux-yank'

# Open panes in current directory # https://youtu.be/DzNmUNvnB04?t=773
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
  
# Color config
set -g @plugin 'dracula/tmux'
# available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, network, network-bandwidth, network-ping, weather, time
set -g @dracula-plugins "git"
set -g @dracula-show-powerline true
set -g @dracula-show-flags true

# Continuum config
set -g @continuum-restore 'on'
set -g @continuum-save-interval '1'
set -g status-right 'Continuum status: #{continuum_status}'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

EOF
)

TMUX_BASH_CONTENT=$(cat <<- 'EOF'

# TMUX as default terminal
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi
EOF
)

sudo apt -y install tmux git

rm -rf "$HOME"/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm

# Create config files
printf '%s' "$TMUX_CONFIG" > "$HOME"/.tmux.conf

# This is a best effort approach to not duplicate things =/
if ! grep -q "# TMUX as default terminal" "$BASHRC"; then
    # Prints bash_content to BASHRC file
    printf '%s' "$TMUX_BASH_CONTENT" >> "$BASHRC"
fi

tmux source ~/.tmux.conf
