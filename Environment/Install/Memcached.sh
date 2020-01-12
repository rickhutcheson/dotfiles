#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Memcached.sh

MEMCACHED_VERSION=1.5.20

echo "Installing $MEMCACHED_VERSION"

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Memcached/memcached-$MEMCACHED_VERSION
rm -f memcached.tar.gz

mkdir -p $USER_ENV_UTILS/Memcached/memcached-$MEMCACHED_VERSION
cd $USER_ENV_UTILS/Memcached/memcached-$MEMCACHED_VERSION

echo "Downloading..."
wget -q https://memcached.org/files/memcached-$MEMCACHED_VERSION.tar.gz -O memcached.tar.gz

echo "Extracting..."
mkdir src
tar xzf memcached.tar.gz -C src --strip-components 1

rm memcached.tar.gz

echo "Building..."
cd src
./configure --prefix=$USER_ENV_UTILS/Memcached/memcached-$MEMCACHED_VERSION

make
make install

echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Memcached
rm -f latest
ln -f -s memcached-$MEMCACHED_VERSION latest

echo "Done!"
