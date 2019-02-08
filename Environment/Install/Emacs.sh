#!/usr/bin/env bash

set -e

EMACS_VERSION=25.2
mkdir -p $USER_ENV_UTILS/Emacs
mkdir -p $USER_ENV_UTILS/Emacs/$EMACS_VERSION
cd $USER_ENV_UTILS/Emacs/$EMACS_VERSION
wget https://emacsformacosx.com/emacs-builds/Emacs-$EMACS_VERSION-universal.dmg -O Emacs.dmg
hdiutil attach -mountpoint $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer Emacs.dmg
cp -rf $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer/Emacs.app ~/Applications/
hdiutil detach $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer
cd ..
unlink $USER_ENV_HOME/.emacs.d
ln -s  $USER_ENV_DATA/Emacs/ $USER_ENV_HOME/.emacs.d
exit 0
