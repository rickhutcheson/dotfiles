#!/usr/bin/env bash
NODE_VERSION=6.11.1
mkdir -p $USER_ENV_UTILS/Node.js
mkdir -p $USER_ENV_UTILS/Node.js/node-$NODE_VERSION
cd $USER_ENV_UTILS/Node.js
wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-$USER_ENV_OS-x64.tar.gz -O node.tar.gz
tar xzf node.tar.gz -C node-$NODE_VERSION --strip-components 1
rm node.tar.gz
rm -f latest
ln -s -f -i node-$NODE_VERSION latest

PKGS="browserify js-beautify docco jshint groc watchify phantomjs-prebuilt"

mkdir -p $USER_ENV_UTILS/NPM
cd $USER_ENV_UTILS/NPM

npm install $PKGS
