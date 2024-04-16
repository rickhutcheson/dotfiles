#!/usr/bin/env bash

set -e

. $USER_ENV_VARS/Bison.sh

app_version=$BISON_VERSION
app_url="http://ftpmirror.gnu.org/bison/bison-$app_version.tar.xz"
app_name="Bison"
app_lowername="bison"
app_dir=$app_lowername-$app_version
app_path="$USER_ENV_UTILS/$app_name/$app_dir"

echo "Setting up app location"
mkdir -p $app_path
cd $USER_ENV_UTILS/$app_name
rm -rf src -$app_dir
mkdir -p $app_dir
echo "Downloading installation files..."
wget $app_url -O $app_lowername.tar.xz
tar xf $app_lowername.tar.xz -C $app_dir --strip-components 1


echo "Compiling files..."

cd $app_dir
./configure --prefix="$app_path"
make
make install

echo "Cleaning Up..."
#mv php.tar.bz2 ~/php.tar.bz2
rm -f latest
ln -sf $app_dir latest
echo Setting app version $app_version as latest.
