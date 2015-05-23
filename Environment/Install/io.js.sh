#!/usr/bin/env bash
IOJS_VERSION=2.0.2
mkdir -p $USER_ENV_UTILS/io.js
mkdir -p $USER_ENV_UTILS/io.js/io.js-$IOJS_VERSION
cd $USER_ENV_UTILS/io.js
wget https://iojs.org/dist/v$IOJS_VERSION/iojs-v$IOJS_VERSION-$USER_ENV_OS-x64.tar.gz -O iojs.tar.gz
tar xzf iojs.tar.gz -C io.js-$IOJS_VERSION --strip-components 1
rm iojs.tar.gz
ln -s io.js-$IOJS_VERSION latest

PKGS="browserify js-beautify docco groc jshint groc watchify"

mkdir -p $USER_ENV_UTILS/NPM
cd $USER_ENV_UTILS/NPM

npm install $PKGS


