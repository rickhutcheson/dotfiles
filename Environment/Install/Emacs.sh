#!/usr/bin/env bash

ln -s $USER_ENV_CONFIG/Emacs/dot-emacs ~/.emacs

mkdir -p $USER_ENV_UTILS/Emacs

# tern
cd $USER_ENV_UTILS/Emacs
git clone https://github.com/marijnh/tern.git tern
cd tern
npm install
ln -s $USER_ENV_UTILS/Emacs/tern ~/.emacs.d/tern

# helm
# from: https://github.com/emacs-helm/helm
cd $USER_ENV_UTILS/Emacs
git clone https://github.com/emacs-helm/helm.git helm
git clone https://github.com/jwiegley/emacs-async.git async
cd helm
make
