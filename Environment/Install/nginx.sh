#!/usr/bin/env bash

NGINX_VERSION=1.9.2
mkdir -p $USER_ENV_UTILS/nginx/build
cd $USER_ENV_UTILS/nginx
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -O nginx.tar.gz
tar xzf nginx.tar.gz -C build --strip-components 1
mv build nginx-$NGINX_VERSION
rm nginx.tar.gz
ln -s nginx-$NGINX_VERSION latest
cd latest
cd build
./configure --prefix=$USER_ENV_UTILS/nginx/nginx-$NGINX_VERSION
make
make install

