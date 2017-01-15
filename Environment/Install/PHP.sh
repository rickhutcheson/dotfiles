#!/usr/bin/env bash

set -e

PHP_VERSION=5.6.8
echo "Setting up PHP location"
mkdir -p $USER_ENV_UTILS/PHP/php-$PHP_VERSION
cd $USER_ENV_UTILS/PHP
rm -rf src php-$PHP_VERSION
mkdir -p src
echo "Downloading installation files..."
wget http://us1.php.net/distributions/php-$PHP_VERSION.tar.bz2 -O php.tar.bz2
tar xjf php.tar.bz2 -C src --strip-components 1
mv src php-$PHP_VERSION
echo "Cleaning Up..."
rm php.tar.bz2
ln -sf php-$PHP_VERSION latest
echo Setting version $PHP_VERSION as latest.
cd latest

echo "Compiling files..."
export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix libpng)/include  -I$(brew --prefix libjpeg)/include"
export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix libpng)/lib -L$(brew --prefix libjpeg)/lib"
./configure --enable-mbstring \
            --with-gd \
            --with-openssl \
            --with-openssl-dir=$(brew --prefix openssl)/bin \
            --with-libxml-dir=$(brew --prefix libxml2) \
            --prefix=$USER_ENV_UTILS/PHP/php-$PHP_VERSION
make
make install
