#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Python.sh

PY3_VERSION=3.4.5

echo "Installing $PY3_VERSION"
mkdir -p $USER_ENV_UTILS/Python/python-$PY3_VERSION
cd $USER_ENV_UTILS/Python
mkdir -p src
wget https://www.python.org/ftp/python/$PY3_VERSION/Python-$PY3_VERSION.tar.xz -O python3.tar.xz
tar xf python3.tar.xz -C src --strip-components 1
mv src python-$PY3_VERSION
rm python3.tar.xz
ln -f -s python-$PY3_VERSION latest
cd latest
cd src
export CPPFLAGS=-I$(brew --prefix openssl)/include;
export LDFLAGS=-L$(brew --prefix openssl)/lib
./configure --prefix=$USER_ENV_UTILS/Python/python-$PY3_VERSION
make
make install

cd
easy_install pip
$USER_ENV_UTILS/Python/latest/bin/easy_install-$USER_ENV_PYTHON_PY3_VERSION pip
$USER_ENV_UTILS/Python/latest/bin/pip install virtualenv

mkdir -p $USER_ENV_UTILS/Python
mkdir -p $USER_ENV_UTILS/Python/Envs

# Install a local virtualenv command for use with this system
cd $USER_ENV_UTILS/Python/Envs

virtualenv --python=`which python` py2default  # default python2 environment
$USER_ENV_UTILS/Python/latest/bin/virtualenv py3default # default python3 environment
unset PY3_VERSION
