#!/usr/bin/env bash
set -e
source $USER_ENV_VARS/Kafka.sh

if [ -z "$APP_VERSION" ]
then
    APP_VERSION=2.6.0
fi
SCALA_VERSION=2.13  # For binary installations, need scala version built with
APP_VERSION_SHORT="${APP_VERSION:0:3}"

echo "Installing $APP_VERSION, built with Scala $SCALA_VERSION"

util_dir=$USER_ENV_UTILS/Kafka
mkdir -p $util_dir
cd $util_dir

# Clean up any previous attempts
rm -rf $USER_ENV_UTILS/Kafka/kafka-$APP_VERSION
rm -f kafka.tar.xz

mkdir -p $USER_ENV_UTILS/Kafka/kafka-$APP_VERSION

echo "Downloading..."
wget -q https://mirrors.sonic.net/apache/kafka/$APP_VERSION/kafka_$SCALA_VERSION-$APP_VERSION.tgz -O kafka.tgz

echo "Extracting..."
tar xzf kafka.tgz -C kafka-$APP_VERSION --strip-components 1

echo "Building..."
cd kafka-$APP_VERSION

cd $USER_ENV_UTILS/Kafka
ln -f -s kafka-$APP_VERSION latest

echo "Setting up this version as 'latest'"
cd $USER_ENV_UTILS/Kafka
rm -f latest
ln -s kafka-$APP_VERSION latest

echo "Making kafka-logs directory if it doesn't exist"
mkdir -p /tmp/kafka-logs
echo "Done!"
