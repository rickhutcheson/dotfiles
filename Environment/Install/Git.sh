#!/usr/bin/env bash
set -e
ln -sf $USER_ENV_CONFIG/git/dot-gitconfig ~/.gitconfig
GIT_VERSION=2.24.0
VERSION_DIR=$USER_ENV_UTILS/Git/Git-$GIT_VERSION

echo "Installing Git $GIT_VERSION..."
mkdir -p $VERSION_DIR
cd $VERSION_DIR
wget https://github.com/git/git/archive/v$GIT_VERSION.tar.gz -O src.tar.xz
tar xf src.tar.xz --strip-components=1
rm src.tar.xz
# need to set NO_GETTEXT since gettext lib not usually installed
NO_GETTEXT=1 make prefix=$VERSION_DIR
NO_GETTEXT=1 make prefix=$VERSION_DIR install
cd $VERSION_DIR
cd ..
rm -f latest
ln -f -s Git-$GIT_VERSION latest
echo "Done. Git $GIT_VERSION installed."
unset VERSION_DIR
unset GIT_VERSION
