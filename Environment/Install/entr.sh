#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/entr.sh

export APP_VERSION=5.1

echo "Installing Entr $APP_VERSION"
rm -rf $USER_ENV_UTILS/entr/entr-$APP_VERSION
mkdir -p $USER_ENV_UTILS/entr/
cd $USER_ENV_UTILS/entr
wget http://eradman.com/entrproject/code/entr-$APP_VERSION.tar.gz -O entr.tar.gz
tar xzf entr.tar.gz
ln -f -s entr-$APP_VERSION latest
cd entr-$APP_VERSION
./configure # --prefix=$USER_ENV_UTILS/entr/entr-$APP_VERSION
 # from their instructions
make PREFIX=$USER_ENV_UTILS/entr/entr-$APP_VERSION test
make PREFIX=$USER_ENV_UTILS/entr/entr-$APP_VERSION install
