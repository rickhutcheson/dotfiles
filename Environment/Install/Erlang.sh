#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Erlang.sh

export ERLANG_VERSION=21.3

echo "Installing $ERLANG_VERSION"

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Erlang/erlang-$ERLANG_VERSION

# Setup directories
mkdir -p $USER_ENV_UTILS/Erlang/erlang-$ERLANG_VERSION/src
cd $USER_ENV_UTILS/Erlang/erlang-$ERLANG_VERSION

echo "Downloading..."
wget -q --show-progress "http://www.erlang.org/download/otp_src_$ERLANG_VERSION.tar.gz" -O erlang.tar.gz

echo "Extracting..."
tar xzf erlang.tar.gz -C src --strip-components 1
rm erlang.tar.gz

echo "Building..."
cd src

./otp_build autoconf
./configure \
    --prefix=$USER_ENV_UTILS/Erlang/erlang-$ERLANG_VERSION \
    --with-ssl=$(brew --prefix openssl) \
    --enable-builtin-zlib

make
make install

echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Erlang
rm -f latest
ln -f -s erlang-$ERLANG_VERSION latest

unset ERLANG_VERSION

echo "Done!"
