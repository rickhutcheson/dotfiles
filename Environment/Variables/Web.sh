#!/usr/bin/bash
export PATH=$USER_ENV_UTILS/Node.js/latest/bin:$PATH
export PATH=$PATH:$USER_ENV_UTILS/php/latest/bin
export PATH=$PATH:$USER_ENV_UTILS/closure-compiler/latest/bin
export PATH=$PATH:$USER_ENV_UTILS/NPM/node_modules/.bin
export PATH=$PATH:~/node_modules/.bin

# MongoDB
export PATH=$PATH:$USER_ENV_UTILS/mongodb/latest/bin

# PhantomJS
export PATH=$USER_ENV_UTILS/NPM/node_modules/phantomjs-prebuilt/lib/phantom/bin/:$PATH
export PHANTOMJS_BIN=`which phantomjs`
