#!/usr/bin/env bash
set -e

YARN_VERSION=1.9.4
echo Installing Yarn $YARN_VERISION

mkdir -p $USER_ENV_UTILS/Yarn
echo "Removing existing files..."
rm -rf $USER_ENV_UTILS/Yarn/yarn-$YARN_VERSION
cd $USER_ENV_UTILS/Yarn

echo "Downloading..."
wget -q https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz -O yarn.tar.gz

echo "Extracting..."
# Get output directory name
dir_name=$(tar tzf yarn.tar.gz | head -1 | cut -f1 -d"/")

tar xzf yarn.tar.gz

# Move output directory to desired location
mv $dir_name yarn-$YARN_VERSION
rm yarn.tar.gz
rm -f latest
ln -s -f yarn-$YARN_VERSION latest

echo "Done!"
