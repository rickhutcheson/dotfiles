#!/usr/bin/env bash

set -e
export RABBIT_VERSION=3.7.14
echo "Installing Rabbit v. $RABBIT_VERSION"
echo "Please ensure that you've installed Erlang!"
mkdir -p $USER_ENV_UTILS/RabbitMQ
cd $USER_ENV_UTILS/RabbitMQ
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v$RABBIT_VERSION/rabbitmq-server-generic-unix-$RABBIT_VERSION.tar.xz -O rabbit.tar.xz
rm -rf $USER_ENV_UTILS/RabbitMQ/rabbitmq-$RABBIT_VERSION
mkdir -p rabbitmq-$RABBIT_VERSION
tar -xf rabbit.tar.xz -C rabbitmq-$RABBIT_VERSION --strip-components 1
rm rabbit.tar.xz
ln -f -s rabbitmq-$RABBIT_VERSION latest
