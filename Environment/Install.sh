#!/usr/bin/env bash

. $USER_ENV_HOME/SetVariables.sh

for SCRIPT in $USER_ENV_INSTALL/*; do
    if [ -f $SCRIPT ]
    then
        $SCRIPT
    fi
done
