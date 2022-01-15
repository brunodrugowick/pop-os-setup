#!/bin/bash

if [ -z "$APPS_PATH" ]; then
  echo "Standalone run. Setting up vars"
  # Make sure to update config.properties if you change this section of the script
  APPS_PATH=$HOME/Apps
fi

DOWNLOAD_FILE=https://download.jetbrains.com/toolbox/${FILENAME}
TDIR=$(mktemp -d)
FILENAME=jetbrains-toolbox-${IDEA_TOOLBOX_VERSION}.tar.gz
TFILE=$TDIR/$FILENAME

wget -O $TFILE --progress=bar:noscroll -N https://download.jetbrains.com/toolbox/${DOWNLOAD_FILE}
mkdir -p $APPS_PATH || true

# 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
tar -C $APPS_PATH -xzf $TFILE

# Starting Toolbox sets it up to autostart
$APPS_PATH/jetbrains-toolbox*/jetbrains-toolbox &

