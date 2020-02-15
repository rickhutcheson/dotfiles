#!/usr/bin/env bash

echo "Removing older versions"
NGINX_VERSION=1.17.2
install_dir=$USER_ENV_UTILS/nginx/nginx-$NGINX_VERSION
rm -rf $install_dir
mkdir -p $install_dir
cd $USER_ENV_UTILS/nginx
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -O nginx.tar.gz
tar xzf nginx.tar.gz -C nginx-$NGINX_VERSION --strip-components 1
rm nginx.tar.gz
ln -s nginx-$NGINX_VERSION latest
cd $install_dir
./configure \
    --prefix=$install_dir \
    --with-http_stub_status_module
#    --with-http_ssl_module
make
make install
cd ..
if [ $? = 0 ]; then
  echo "nginx install Completed."
fi
