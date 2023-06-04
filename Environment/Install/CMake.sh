#!/usr/bin/env bash
set -e
cmake_version=3.25.1
VERSION_DIR=$USER_ENV_UTILS/CMake/CMake-$cmake_version
mkdir -p $VERSION_DIR/src
cd $VERSION_DIR/src

echo "Downloading CMake $cmake_version..."
wget https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}.tar.gz -O src.tar.gz
tar xzf src.tar.gz --strip-components=1
rm -f ./src.tar.gz
./bootstrap --prefix=$USER_ENV_UTILS/CMake/CMake-$cmake_version
make && make install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s CMake-$cmake_version latest
