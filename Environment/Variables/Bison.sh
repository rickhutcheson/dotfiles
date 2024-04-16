#!/usr/bin/env bash

BISON_VERSION=3.8.2
# Since the system symlinks yacc, we actually do have to put this first
export PATH="$USER_ENV_UTILS/Bison/bison-$BISON_VERSION/bin":$PATH
