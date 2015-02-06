#!/usr/bin/env bash

ln -s $USER_ENV_CONFIG/Emacs/dot-emacs ~/.emacs

mkdir -p $USER_ENV_UTILS/Emacs
cd $USER_ENV_UTILS/Emacs
git clone https://github.com/marijnh/tern.git tern
cd tern
npm install
ln -s $USER_ENV_UTILS/Emacs/tern ~/.emacs.d/tern
