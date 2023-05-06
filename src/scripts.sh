#!/bin/bash

MY_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
LOCATION=$HOME/.local/bin/

mkdir -p $LOCATION
cp $MY_PATH/scripts/* $LOCATION

