#!/usr/bin/env bash

set -e

EMACS_VERSION=26.3
mkdir -p $USER_ENV_UTILS/Emacs
mkdir -p $USER_ENV_UTILS/Emacs/$EMACS_VERSION
cd $USER_ENV_UTILS/Emacs/$EMACS_VERSION
wget https://emacsformacosx.com/emacs-builds/Emacs-$EMACS_VERSION-universal.dmg -O Emacs.dmg
hdiutil attach -mountpoint $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer Emacs.dmg
echo "Copying Emacs.app..."
cp -Rfv $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer/Emacs.app ~/Applications/Emacs.app
echo "Done."
hdiutil detach $USER_ENV_UTILS/Emacs/$EMACS_VERSION/installer
cd ..
unlink ~/.emacs.d
ln -s  $USER_ENV_DATA/Emacs/ ~/.emacs.d
exit 0
