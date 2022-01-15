#!/bin/bash

KSNIP_AUTOSTART_TEMPLATE=$(cat <<- 'EOF'
[Desktop Entry]
Name=Ksnip
Exec=ksnip
Type=Application
EOF
)

AUTOSTART_FOLDER=$HOME/.config/autostart
# Configure KSNIP to autostart
KSNIP_AUTOSTART_FILE=$AUTOSTART_FOLDER/ksnip.desktop
mkdir -p $AUTOSTART_FOLDER
touch $KSNIP_AUTOSTART_FILE
echo "$KSNIP_AUTOSTART_TEMPLATE" > "$KSNIP_AUTOSTART_FILE"
