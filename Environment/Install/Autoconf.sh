#!/usr/bin/env bash
set -e
APP_VERSION=2.69

VERSION_DIR=$USER_ENV_UTILS/autoconf/autoconf-$APP_VERSION

echo "Installing autoconf $APP_VERSION..."
mkdir -p $VERSION_DIR
cd $VERSION_DIR
wget http://ftp.gnu.org/gnu/autoconf/autoconf-$APP_VERSION.tar.xz -O src.tar.xz
tar xf src.tar.xz --strip-components=1
rm src.tar.xz
# need to set NO_GETTEXT since gettext lib not usually installed
./configure --prefix=$VERSION_DIR
make
make install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s autoconf-$APP_VERSION latest

echo "Configuring"
echo "Done. autoconf $APP_VERSION installed."
unset VERSION_DIR
unset APP_VERSION
