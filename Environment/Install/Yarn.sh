#!/usr/bin/env bash
YARN_VERSION=1.3.2
mkdir -p $USER_ENV_UTILS/Yarn
mkdir -p $USER_ENV_UTILS/Yarn/yarn-$YARN_VERSION
cd $USER_ENV_UTILS/Yarn
wget https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz -O yarn.tar.gz
tar xzf yarn.tar.gz -C yarn-$YARN_VERSION --strip-components 1
rm yarn.tar.gz
rm -f latest
ln -s -f -i yarn-$YARN_VERSION latest
