#!/usr/bin/env bash

set -e

PHP_VERSION=7.1.10
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
rm -f latest
ln -sf php-$PHP_VERSION latest
echo Setting version $PHP_VERSION as latest.
cd php-$PHP_VERSION

echo "Compiling files..."

export PKG_CONFIG_PATH=$(brew --prefix openssl)/lib/pkgconfig
export CFLAGS="-I$(brew --prefix openssl)/include/ \
-I$(brew --prefix libpng)/include  \
-I$(brew --prefix libjpeg)/include \
-I$(brew --prefix zlib)/include"
export CPPFLAGS="-I$(brew --prefix openssl)/include/ \
-I$(brew --prefix libpng)/include  \
-I$(brew --prefix libjpeg)/include \
-I$(brew --prefix zlib)/include"
export LDFLAGS="-L$(brew --prefix openssl)/lib \
-L$(brew --prefix libpng)/lib \
-L$(brew --prefix libjpeg)/lib \
-L$(brew --prefix zlib)/lib"

./configure --enable-mbstring \
            --with-gd \
            --enable-exif \
            --enable-zip \
            --with-openssl \
            --with-curl=$(brew --prefix curl) \
            --with-openssl-dir=$(brew --prefix openssl) \
            --with-libxml-dir=$(brew --prefix libxml2) \
            --with-zlib=$(brew --prefix zlib) \
            --with-zlib-dir=$(brew --prefix zlib) \
            --prefix=$USER_ENV_UTILS/PHP/php-$PHP_VERSION
make
make install
