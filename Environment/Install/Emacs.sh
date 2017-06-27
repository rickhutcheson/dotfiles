#!/usr/bin/env bash

EMACS_VERSION=25.2
mkdir -p $USER_ENV_UTILS/Emacs
mkdir -p $USER_ENV_UTILS/Emacs/$EMACS_VERSION
cd $USER_ENV_UTILS/Emacs/$EMACS_VERSION
wget https://emacsformacosx.com/emacs-builds/Emacs-$EMACS_VERSION-universal.dmg -O Emacs.dmg
hdiutil attach -mountpoint $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer Emacs.dmg
cp -r $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer/Emacs.app .
hdiutil detach $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer
cd ..
ln -s -f -i $EMACS_VERSION latest
rm Emacs.dmg
cp -r latest/Emacs.app ~/Applications/
