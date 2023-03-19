#!/bin/bash

FILENAME=jetbrains-toolbox-${IDEA_TOOLBOX_VERSION}.tar.gz
DOWNLOAD_FILE=https://download.jetbrains.com/toolbox/${FILENAME}
TDIR=$(mktemp -d)
TFILE=$TDIR/$FILENAME

wget -O $TFILE --progress=bar:noscroll -N ${DOWNLOAD_FILE}
mkdir -p $APPS_PATH || true

# 'tar -C <DIR>' changes to DIR before (since -C is order sensitive) the other operations
tar -C $APPS_PATH -xzf $TFILE

# Starting Toolbox sets it up to autostart
$APPS_PATH/jetbrains-toolbox*/jetbrains-toolbox &

