#!/usr/bin/env bash

# Environment Installation 
# ------------------------
# Should only be run once, during machine setup. Creates necessary
# directories and runs all individual setup scripts.
# 
# Can be run multiple times; existing installs will be overwritten.

. $USER_ENV_HOME/SetVariables.sh
BLACK=0
RED=1
GREEN=2
YELLOW=3
BLUE=4
MAGENTA=5
CYAN=6

colorecho() {
    tput setaf $1
    echo "$2"
    tput sgr0
}

proclaim() {
    echo ""
    echo ""
    colorecho $GREEN "╔══════════════════════════════════════════════════════════════════════"
    colorecho $GREEN "║"
    colorecho $GREEN "║ $1"
    colorecho $GREEN "║"
    colorecho $GREEN "╚══════════════════════════════════════════════════════════════════════"
    echo
    echo
}

echo "Making Directories..."
mkdir -p $USER_ENV_SCRIPTS
mkdir -p $USER_ENV_UTILS

for script in $USER_ENV_INSTALL/*; do
    read -n1 -p "Install $script ?[y/n] "
    echo # print a newline for next prompt
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
	continue
    fi
    proclaim "Installing $script..."
    if [ -f $script ]; then
        $script
        if [[ $? -ne 0 ]] ; then
	    colorecho $RED "FAILED: $script"
            exit 1
        fi
        proclaim "$script Installed"
    fi
done
