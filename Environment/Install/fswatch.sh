#!/usr/bin/env bash
set -e

. $USER_ENV_VARS/fswatch.sh
export FSWATCH_VERSION=1.14.0

echo "Cleaning previous versions..."
rm -rf $USER_ENV_UTILS/fswatch/fswatch-$FSWATCH_VERSION

echo "Installing fswatch v. $FSWATCH_VERSION"
mkdir -p $USER_ENV_UTILS/fswatch
cd $USER_ENV_UTILS/fswatch
mkdir -p fswatch-$FSWATCH_VERSION/src
cd fswatch-$FSWATCH_VERSION
wget https://github.com/emcrisostomo/fswatch/releases/download/$FSWATCH_VERSION/fswatch-$FSWATCH_VERSION.tar.gz -O fswatch.tar.xz
tar -xf fswatch.tar.xz -C src --strip-components 1
cd src

echo "\nInstalling...\n"

./configure --prefix=$USER_ENV_UTILS/fswatch/fswatch-$FSWATCH_VERSION
make
make install

cd $USER_ENV_UTILS/fswatch
ln -sf fswatch-$FSWATCH_VERSION latest

echo "\nDone!\n"
