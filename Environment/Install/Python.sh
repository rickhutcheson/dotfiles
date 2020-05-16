#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Python.sh

if [ -z "$APP_VERSION" ]
then
    APP_VERSION=3.5.6
fi
APP_VERSION_SHORT="${APP_VERSION:0:3}"

echo "Installing $APP_VERSION"

util_dir=$USER_ENV_UTILS/Python
mkdir -p $util_dir
cd $util_dir

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Python/python-$APP_VERSION
rm -f python3.tar.xz

mkdir -p $USER_ENV_UTILS/Python/python-$APP_VERSION

echo "Downloading..."
wget -q https://www.python.org/ftp/python/$APP_VERSION/Python-$APP_VERSION.tar.xz -O python3.tar.xz

echo "Extracting..."
# If the system has xzcat available, prefer it
if [ -x "$(command -v xzcat)" ]; then
    # this lets us get the output directory tar will use
    dir_name=$(xzcat python3.tar.xz | tar tf - | head -1 | cut -f1 -d"/")
    xzcat python3.tar.xz | tar xf -
    mv $dir_name python-$APP_VERSION
else
    # If it doesn't, then it probably has GNU tar
    tar xf python3.tar.xz -C python-$APP_VERSION --strip-components 1
fi

rm python3.tar.xz

echo "Building..."
cd python-$APP_VERSION

# macOS customizations
if [[ "$USER_ENV_OS" == "darwin" ]]; then
    # sqlite:  IPython needs native sqlite support
    # readline: Proper readline support; otherwise IPython complains about libedit
    brew install openssl sqlite gettext zlib
    export CPPFLAGS="\
       -I$(brew --prefix openssl)/include \
       -I$(brew --prefix sqlite)/include \
       -I$(brew --prefix gettext)/include \
       -I$(brew --prefix zlib)/include \
       -I$USER_ENV_LIB/Readline/readline-7.0/include \
       -I$(xcrun --show-sdk-path)/usr/include"
    export CFLAGS=$CPPFLAGS
    export LDFLAGS="\
       -L$(brew --prefix openssl)/lib \
       -L$(brew --prefix sqlite)/lib \
       -L$(brew --prefix gettext)/lib \
       -L$(brew --prefix zlib)/lib \
       -L$USER_ENV_LIB/Readline/readline-7.0/lib"  # Proper readline support; otherwise IPython complains about libedit
    LD_RUN_PATH="$(brew --prefix sqlite)/lib" ./configure --prefix=$USER_ENV_UTILS/Python/python-$APP_VERSION --with-openssl=$(brew --prefix openssl)
else
    ./configure --prefix=$USER_ENV_UTILS/Python/python-$APP_VERSION
fi

make
make install

cd $USER_ENV_UTILS/Python
ln -f -s python-$APP_VERSION latest


echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Python
unlink latest
ln -f -s python-$APP_VERSION latest

echo "Creating Envs directory..."
mkdir -p $USER_ENV_DATA/Python/Envs
unset APP_VERSION

echo "Done!"
