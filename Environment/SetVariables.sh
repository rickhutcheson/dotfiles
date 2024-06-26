#!/usr/bin/env bash


export USER_ENV_HOME=$USER_ENV_HOME
export USER_ENV_ARCH=`uname -m`
export USER_ENV_OS=$USER_ENV_OS
export USER_ENV_CONFIG=$USER_ENV_HOME/Config
export USER_ENV_DATA=$USER_ENV_HOME/Data
export USER_ENV_INSTALL=$USER_ENV_HOME/Install
export USER_ENV_LIB=$USER_ENV_HOME/Libraries
export USER_ENV_REPOS=$USER_ENV_HOME/Repositories
export USER_ENV_SCRIPTS=$USER_ENV_HOME/Scripts
export USER_ENV_UTILS=$USER_ENV_HOME/Utilities
export USER_ENV_VARS=$USER_ENV_HOME/Variables

for VARS in $USER_ENV_VARS/*; do
    if [ -f $VARS ]
    then
        . $VARS
    fi
done

# Source machine-local scripts
for local_script in ~/LocalEnv/*; do
    if [ -f $local_script ]
    then
        . $local_script
    fi
done
