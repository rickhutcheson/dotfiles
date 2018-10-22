#!/usr/bin/env bash

. $USER_ENV_HOME/SetVariables.sh

USER_ENV_AUTORUN=$USER_ENV_HOME/AutoRun

for SCRIPT in $USER_ENV_AUTORUN/*; do
    if [ -f $SCRIPT ]
    then
        $SCRIPT
    fi
done
