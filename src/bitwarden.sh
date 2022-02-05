#!/bin/bash

TDIR=$(mktemp -d)
TZIPFILE=$TDIR/bitwarden.zip
DESTDIR=$HOME/.local/bin
DESTFILE=$DESTDIR/bw
curl -fsSL "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o $TZIPFILE
rm $DESTFILE || true
unzip $TZIPFILE -d $DESTDIR
chmod +x $DESTFILE
