#!/usr/bin/env bash

ln -s $USER_ENV_CONFIG/git/dot-gitconfig ~/.gitconfig
ln -s $USER_ENV_CONFIG/git/hub-completion.bash ~/.hub-completion.bash

mkdir -p $USER_ENV_UTILS/Git/
cp $USER_ENV_INSTALL/Git/* $USER_ENV_UTILS/Git/
