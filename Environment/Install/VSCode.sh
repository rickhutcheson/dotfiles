#!/usr/bin/env bash

set -e

APP_VERSION=`date +'%Y-%m-%d'`
mkdir -p $USER_ENV_UTILS/VSCode
mkdir -p $USER_ENV_UTILS/VSCode/$APP_VERSION
cd $USER_ENV_UTILS/VSCode/$APP_VERSION
wget https://update.code.visualstudio.com/latest/darwin/stable -O VSCode.zip
unzip VSCode.zip # creates kotlinc folder
echo "Copying VSCode.app..."
cp -Rfv "$USER_ENV_UTILS/VSCode/$APP_VERSION/Visual Studio Code.app" ~/Applications/VSCode.app
echo "Done."
# Mark version as latest
cd $USER_ENV_UTILS/VSCode
rm -f latest
ln -f -s VSCode-$APP_VERSION latest
exit 0
