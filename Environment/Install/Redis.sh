#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Redis.sh

export REDIS_VERSION=4.0.8

echo "Installing Redis $REDIS_VERSION"
rm -rf $USER_ENV_UTILS/Redis/redis-$REDIS_VERSION
mkdir -p $USER_ENV_UTILS/Redis/
cd $USER_ENV_UTILS/Redis
wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz -O redis.tar.gz
tar xzf redis.tar.gz
ln -f -s redis-$REDIS_VERSION latest
cd redis-$REDIS_VERSION
make PREFIX=$USER_ENV_UTILS/Redis/redis-$REDIS_VERSION
make install
