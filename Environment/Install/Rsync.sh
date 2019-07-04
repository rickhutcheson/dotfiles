#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Rsync.sh

export RSYNC_VERSION=3.1.3
export RSYNC_VERSION_SHORT="${RSYNC_VERSION:0:3}"

echo "Installing $RSYNC_VERSION"
mkdir -p  $USER_ENV_UTILS/Rsync
cd $USER_ENV_UTILS/Rsync

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Rsync/rsync-$RSYNC_VERSION
rm -f rsync.tar.gz

mkdir -p $USER_ENV_UTILS/Rsync/rsync-$RSYNC_VERSION

echo "Downloading..."
wget -q https://download.samba.org/pub/rsync/rsync-$RSYNC_VERSION.tar.gz -O rsync.tar.gz

echo "Extracting..."
tar xzf rsync.tar.gz -C rsync-$RSYNC_VERSION --strip-components 1
rm rsync.tar.gz

echo "Building..."
cd rsync-$RSYNC_VERSION

# macOS customizations
./configure --prefix=$USER_ENV_UTILS/Rsync/rsync-$RSYNC_VERSION

make
make install

echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Rsync
unlink latest
ln -f -s rsync-$RSYNC_VERSION latest

unset RSYNC_VERSION
echo "Done!"
