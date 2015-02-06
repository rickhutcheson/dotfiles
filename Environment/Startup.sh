#!/usr/bin/env bash

. $USER_ENV_HOME/SetVariables.sh

USER_ENV_SCRIPTS=$USER_ENV_HOME/Scripts

for SCRIPT in $USER_ENV_SCRIPTS/*; do
    if [ -f $SCRIPT ]
    then
        $SCRIPT
    fi
done
