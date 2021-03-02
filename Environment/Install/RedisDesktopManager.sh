#!/usr/bin/env bash

RDM_VERSION="0.9.0-alpha4"

echo "Make sure you install QT Creator First! (brew install qt5)"

mkdir -p $USER_ENV_UTILS/RedisDesktopManager
cd $USER_ENV_UTILS/RedisDesktopManager
mkdir -p rdm-$RDM_VERSION
unlink latest
ln -f -s rdm-$RDM_VERSION latest
cd latest
git clone --recursive https://github.com/uglide/RedisDesktopManager.git -b $RDM_VERSION src && cd ./src
cd src/  # the repo has its own src/ folder

./configure --prefix=$USER_ENV_UTILS/RedisDesktopManager/rdm-$RDM_VERSION/

export PATH=$PATH:/usr/local/opt/qt5/bin/
qmake && make && make install
cd $USER_ENV_UTILS/RedisDesktopManager/rdm-$RDM_VERSION/bin
mv qt.conf qt.backup
