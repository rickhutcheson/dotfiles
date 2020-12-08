#!/usr/bin/env bash
set -e
BASH_VERSION=5.1
VERSION_DIR=$USER_ENV_UTILS/Bash/Bash-$BASH_VERSION

echo "Installing Bash $BASH_VERSION..."
mkdir -p $VERSION_DIR/src
cd $VERSION_DIR/src
wget https://ftp.gnu.org/gnu/bash/bash-$BASH_VERSION.tar.gz -O src.tar.gz
tar xzf src.tar.gz --strip-components=1
rm src.tar.gz
./configure --prefix=$USER_ENV_UTILS/Bash/Bash-$BASH_VERSION
make && make install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s Bash-$BASH_VERSION latest
