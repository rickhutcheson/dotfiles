!/usr/bin/env bash

set -e
source $USER_ENV_VARS/TeX.sh
ln -s -f $USER_ENV_CONFIG/TeX/ ~/texmf

echo "Setting up directories..."
cd $USER_ENV_UTILS/TeX
rm -rf $USER_ENV_UTILS/TeX/$TEX_VERSION
rm -rf install
mkdir -p install

echo "Downloading..."
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O tl.tar.gz
tar xzf tl.tar.gz -C install --strip-components 1
mv install $TEX_VERSION
rm tl.tar.gz
ln -s -f $TEX_VERSION latest
cd latest

# Creates a version of the profile file with variables expanded so
# the installer can read it
echo "Creating installation profile..."
while read; do
    eval echo "$REPLY";
done < ~/Environment/Install/TeX.texlive.profile > ./texlive.profile

echo "Installing..."
./install-tl --profile=./texlive.profile
