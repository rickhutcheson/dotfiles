#!/usr/bin/env bash

PHP_VERSION=5.6.5
mkdir -p $USER_ENV_UTILS/PHP/php-$PHP_VERSION
cd $USER_ENV_UTILS/PHP
mkdir -p src
wget http://us1.php.net/distributions/php-5.6.5.tar.bz2 -O php.tar.bz2
tar xjf php.tar.bz2 -C src --strip-components 1
mv src php-$PHP_VERSION
rm php.tar.bz2
ln -s php-$PHP_VERSION latest
cd latest
cd src
./configure --prefix=$USER_ENV_UTILS/PHP/php-$PHP_VERSION
make
make install


