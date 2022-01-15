#!/bin/bash

# Configures shortcuts with xbindkeys
XBINDKEYS_TEMPLATE=$(cat <<- 'EOF'
# Workspace Up
"xte 'keydown Control_L' 'keydown Super_L' 'key Up' 'keyup Super_L' 'keyup Control_L'"
   b:9

# Workspace Down
"xte 'keydown Control_L' 'keydown Super_L' 'key Down' 'keyup Super_L' 'keyup Control_L'"
   b:8

EOF
)

# Setup xbindkeys shortcut for my mouse (MX Master 3)
## from https://support.system76.com/articles/custom-mouse-buttons/
XBINDKEYS_RC_FILE=$HOME/.xbindkeysrc
sudo apt install -y xbindkeys xautomation
rm $XBINDKEYS_RC_FILE || true
echo "$XBINDKEYS_TEMPLATE" > "$XBINDKEYS_RC_FILE"
killall xbindkeys || true
xbindkeys
