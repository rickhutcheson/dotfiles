#!/usr/bin/env bash

# Environment Installation 
# ------------------------
# Should only be run once, during machine setup. Creates necessary
# directories and runs all individual setup scripts.
# 
# Can be run multiple times; existing installs will be overwritten.

. $USER_ENV_HOME/SetVariables.sh

mkdir -p $USER_ENV_SCRIPTS
mkdir -p $USER_ENV_UTILS

for script in $USER_ENV_INSTALL/*; do
    echo "Installing $script..."
    if [ -f $script ]
    then
        $script
    fi
    echo "$script installed"
    echo "-----------------------------------------"
    echo "\n\n\n"
done
