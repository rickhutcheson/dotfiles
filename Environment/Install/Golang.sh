#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Golang.sh

echo "Installing Golang $GOLANG_VERSION"
rm -rf $USER_ENV_UTILS/Golang/golang-$GOLANG_VERSION
mkdir -p $USER_ENV_UTILS/Golang/
cd $USER_ENV_UTILS/Golang
rm -rf install
mkdir -p install
wget https://dl.google.com/go/go$GOLANG_VERSION.darwin-amd64.tar.gz -O golang.tar.gz
tar -xzf golang.tar.gz -C install --strip-components 1
mv install golang-$GOLANG_VERSION
ln -f -s golang-$GOLANG_VERSION latest

# cd python-$PY3_VERSION
# cd src
# export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix sqlite)/include -I$(brew --prefix zlib)/include -I$(xcrun --show-sdk-path)/usr/include"
# export CFLAGS=$CPPFLAGS
# export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix sqlite)/lib -L$(brew --prefix zlib)/lib"
# LD_RUN_PATH="$(brew --prefix sqlite)/lib" ./configure --prefix=$USER_ENV_UTILS/Python/python-$PY3_VERSION --with-openssl=$(brew --prefix openssl)
# make
# make install

# ./bin/easy_install-$PY3_VERSION_SHORT pip
# $USER_ENV_UTILS/Python/$PY3_VERSION/bin/easy_install-$USER_ENV_PYTHON_PY3_VERSION pip
# $USER_ENV_UTILS/Python/$PY3_VERSION/bin/pip install virtualenv


# mkdir -p $USER_ENV_UTILS/Python/Envs

# # Install a local virtualenv command for use with this system
# cd $USER_ENV_UTILS/Python/Envs

# #virtualenv --python=`which python` py2default  # default python2 environment
# $USER_ENV_UTILS/Python/latest/bin/virtualenv py3default # default python3 environment
# unset PY3_VERSION
# #$USER_ENV_UTILS/Python/latest/bin/virtualenv py3default # default python3 environment
