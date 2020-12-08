#!/usr/bin/env bash
set -e
APP_VERSION=1.4g
VERSION_DIR=$USER_ENV_UTILS/autossh/autossh-$APP_VERSION
mkdir -p $VERSION_DIR
cd $VERSION_DIR

echo "Downloading autossh $APP_VERSION..."
mkdir -p src
cd src
wget https://www.harding.motd.ca/autossh/autossh-$APP_VERSION.tgz -O - | tar xzf - --strip-components=1
echo "Compiling autossh $APP_VERSION..."
./configure
make
cd ..
echo "Installing autossh $APP_VERSION..."
mkdir -p bin
mv src/autossh ./bin/autossh
cd ..
rm -f ./latest
ln -f -s autossh-$APP_VERSION latest
echo "Done!"
