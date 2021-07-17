#!/bin/bash

# SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash

    sdk install java
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"
