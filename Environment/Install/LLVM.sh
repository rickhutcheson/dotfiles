#!/usr/bin/env bash

set -e
source $USER_ENV_VARS/LLVM.sh

if [ -z "$APP_VERSION" ]
then
    APP_VERSION=13.0.0
fi

echo "Installing $APP_VERSION"

util_dir=$USER_ENV_UTILS/LLVM
mkdir -p $util_dir
cd $util_dir

# Clean up any previous attempts
rm -rf $util_dir/llvm-$APP_VERSION
rm -f llvm.tar.xz

echo "Downloading..."
wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-$APP_VERSION/clang+llvm-$APP_VERSION-x86_64-apple-darwin.tar.xz -O llvm.tar.xz

echo "Extracting..."
# If the system has xzcat available, prefer it
if [ -x "$(command -v xzcat)" ]; then
    # this lets us get the output directory tar will use
    dir_name=$(xzcat llvm.tar.xz | tar tf - | head -1 | cut -f1 -d"/")
    xzcat llvm.tar.xz | tar xf -
    mv $dir_name llvm-$APP_VERSION
else
    # If it doesn't, then it probably has GNU tar
    mkdir llvm-$APP_VERSION
    tar xf llvm.tar.xz -C llvm-$APP_VERSION --strip-components 1
fi

rm llvm.tar.xz

echo "Setting this version as 'latest'"
cd $util_dir
rm -f ./latest
ln -s llvm-$APP_VERSION latest

echo "Done!"
