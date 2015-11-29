#!/usr/bin/env bash

set -e
source $USER_ENV_VARS/TeX.sh

mkdir -p $USER_ENV_UTILS/TeX/texlive-$TEX_VERSION
cd $USER_ENV_UTILS/TeX
mkdir -p src

wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz -O tl.tar.gz
tar xzf tl.tar.gz -C src --strip-components 1
mv src texlive-$TEX_VERSION
rm tl.tar.gz
ln -s texlive-$TEX_VERSION latest
cd latest
cd src
./install-tl --profile=./TeX.texlive.profile
