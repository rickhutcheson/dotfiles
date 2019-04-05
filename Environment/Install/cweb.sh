#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/cweb.sh
source $USER_ENV_VARS/TeX.sh

echo "Installing cweb!"

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/CWEB/latest
rm -f cweb.tar.gz

# Setup directory
mkdir -p $USER_ENV_UTILS/CWEB/latest/src
mkdir -p $USER_ENV_UTILS/CWEB/latest/man
mkdir -p $USER_ENV_UTILS/CWEB/latest/lib/cweb
mkdir -p $USER_ENV_UTILS/CWEB/latest/share/emacs/site-lisp

cd $USER_ENV_UTILS/CWEB/latest/src

echo "Downloading..."
wget -q ftp://ftp.cs.stanford.edu/pub/cweb/cweb.tar.gz -O cweb.tar.gz

echo "Extracting..."
tar xzf cweb.tar.gz  # all components extracted to cwd
rm cweb.tar.gz

echo "Building..."
make install \
     DESTDIR=$USER_ENV_UTILS/CWEB/latest/bin/ \
     MANDIR=$USER_ENV_UTILS/CWEB/latest/man/man$(MANEXT) \
     MACROSDIR=$TEX_DIR \
     EMACSDIR=$USER_ENV_UTILS/CWEB/latest/share/emacs/site-lisp \
     CWEBINPUTS=$USER_ENV_UTILS/CWEB/latest/lib/cweb

echo "Done!"
