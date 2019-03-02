#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Python.sh

export PY3_VERSION=3.5.6
export PY3_VERSION_SHORT="${PY3_VERSION:0:3}"

echo "Installing $PY3_VERSION"
rm -rf $USER_ENV_UTILS/Python/python-$PY3_VERSION
mkdir -p $USER_ENV_UTILS/Python/python-$PY3_VERSION
cd $USER_ENV_UTILS/Python
mkdir -p src
echo "Downloading..."
wget -q https://www.python.org/ftp/python/$PY3_VERSION/Python-$PY3_VERSION.tar.xz -O python3.tar.xz
echo "Unzipping..."
tar xf python3.tar.xz -C src --strip-components 1
mv src python-$PY3_VERSION
rm python3.tar.xz

echo "Building..."
cd python-$PY3_VERSION
cd src
# sqlite:  IPython needs native sqlite support
# readline: Proper readline support; otherwise IPython complains about libedit
export CPPFLAGS="\
       -I$(brew --prefix openssl)/include \
       -I$(brew --prefix sqlite)/include \
       -I$(brew --prefix gettext)/include \
       -I$(brew --prefix zlib)/include \
       -I$(brew --prefix readline)/include \
       -I$(xcrun --show-sdk-path)/usr/include"
export CFLAGS=$CPPFLAGS
export LDFLAGS="\
       -L$(brew --prefix openssl)/lib \
       -L$(brew --prefix sqlite)/lib \
       -L$(brew --prefix gettext)/lib \
       -L$(brew --prefix zlib)/lib \
       -L$(brew --prefix readline)/lib"  # Proper readline support; otherwise IPython complains about libedit
LD_RUN_PATH="$(brew --prefix sqlite)/lib" ./configure --prefix=$USER_ENV_UTILS/Python/python-$PY3_VERSION --with-openssl=$(brew --prefix openssl)

make
make install

./bin/easy_install-$PY3_VERSION_SHORT pip
$USER_ENV_UTILS/Python/$PY3_VERSION/bin/easy_install-$USER_ENV_PYTHON_PY3_VERSION pip
$USER_ENV_UTILS/Python/$PY3_VERSION/bin/pip install virtualenv

echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Python
unlink latest
ln -f -s python-$PY3_VERSION latest


mkdir -p $USER_ENV_DATA/Python/Envs

# Install a local virtualenv command for use with this system
cd $USER_ENV_DATA/Python/Envs

#virtualenv --python=`which python` py2default  # default python2 environment
$USER_ENV_UTILS/Python/latest/bin/virtualenv py3default # default python3 environment
unset PY3_VERSION
#$USER_ENV_UTILS/Python/latest/bin/virtualenv py3default # default python3 environment
