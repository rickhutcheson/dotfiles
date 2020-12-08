#!/usr/bin/env bash
set -e
MAKE_VERSION=4.3
VERSION_DIR=$USER_ENV_UTILS/Make/Make-$MAKE_VERSION

echo "Installing Make $MAKE_VERSION..."
mkdir -p $VERSION_DIR/src
cd $VERSION_DIR/src
wget https://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz -O src.tar.gz
tar xzf src.tar.gz --strip-components=1
rm src.tar.gz
./configure --prefix=$USER_ENV_UTILS/Make/Make-$MAKE_VERSION
make && make install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s Make-$MAKE_VERSION latest
