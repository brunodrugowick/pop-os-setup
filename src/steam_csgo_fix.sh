#!/bin/bash

# Thanks to https://github.com/ValveSoftware/csgo-osx-linux/issues/2659#issuecomment-994514415
# Without the game installed this probably will fail silently.

# NEED TO MANUALLY ADD '-vulkan -nojoy -novid -fullscreen' TO LAUNCH OPTIONS IN STEAM

CS_LIB_PATH="${HOME}/.steam/debian-installation/steamapps/common/Counter-Strike Global Offensive/bin/linux64"

sudo apt install libtcmalloc-minimal4
mv "$CS_LIB_PATH"/libtcmalloc_minimal.so.0 "$CS_LIB_PATH"/libtcmalloc_minimal.so.0.bak
mv "$CS_LIB_PATH"/libtcmalloc_minimal.so.4 "$CS_LIB_PATH"/libtcmalloc_minimal.so.4.bak
ln -s /usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 "$CS_LIB_PATH"/libtcmalloc_minimal.so.0
ln -s /usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4 "$CS_LIB_PATH"/libtcmalloc_minimal.so.4
